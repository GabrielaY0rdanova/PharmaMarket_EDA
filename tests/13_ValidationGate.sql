DO $$
DECLARE
    failure_count integer;
    actual_count bigint;
    expected record;
BEGIN
    FOR expected IN
        SELECT *
        FROM (VALUES
            ('drug_class', 422),
            ('dosage_form', 113),
            ('manufacturer', 240),
            ('indication', 2043),
            ('generic', 1711),
            ('medicine', 21708),
            ('medicine_package_size', 14349),
            ('medicine_package_container', 22707),
            ('generic_indication', 1608)
        ) AS counts(table_name, expected_count)
    LOOP
        EXECUTE format('SELECT COUNT(*) FROM %I', expected.table_name)
        INTO actual_count;
        IF actual_count <> expected.expected_count THEN
            RAISE EXCEPTION
                'Unexpected row count for %: expected %, found %',
                expected.table_name,
                expected.expected_count,
                actual_count;
        END IF;
    END LOOP;

    SELECT COUNT(*) INTO failure_count
    FROM medicine m
    LEFT JOIN dosage_form d ON d.dosage_form_id = m.dosage_form_id
    WHERE m.dosage_form_id IS NOT NULL AND d.dosage_form_id IS NULL;
    IF failure_count > 0 THEN
        RAISE EXCEPTION 'medicine contains orphan dosage_form_id values';
    END IF;

    SELECT COUNT(*) INTO failure_count
    FROM generic g
    LEFT JOIN drug_class d ON d.drug_class_id = g.drug_class_id
    WHERE g.drug_class_id IS NOT NULL AND d.drug_class_id IS NULL;
    IF failure_count > 0 THEN
        RAISE EXCEPTION 'generic contains orphan drug_class_id values';
    END IF;

    SELECT COUNT(*) INTO failure_count
    FROM medicine m
    LEFT JOIN generic g ON g.generic_id = m.generic_id
    WHERE m.generic_id IS NOT NULL AND g.generic_id IS NULL;
    IF failure_count > 0 THEN
        RAISE EXCEPTION 'medicine contains orphan generic_id values';
    END IF;

    SELECT COUNT(*) INTO failure_count
    FROM medicine m
    LEFT JOIN manufacturer f ON f.manufacturer_id = m.manufacturer_id
    WHERE m.manufacturer_id IS NOT NULL AND f.manufacturer_id IS NULL;
    IF failure_count > 0 THEN
        RAISE EXCEPTION 'medicine contains orphan manufacturer_id values';
    END IF;

    SELECT COUNT(*) INTO failure_count
    FROM medicine_package_size p
    LEFT JOIN medicine m ON m.brand_id = p.brand_id
    WHERE p.brand_id IS NOT NULL AND m.brand_id IS NULL;
    IF failure_count > 0 THEN
        RAISE EXCEPTION 'medicine_package_size contains orphan brand_id values';
    END IF;

    SELECT COUNT(*) INTO failure_count
    FROM medicine_package_container p
    LEFT JOIN medicine m ON m.brand_id = p.brand_id
    WHERE p.brand_id IS NOT NULL AND m.brand_id IS NULL;
    IF failure_count > 0 THEN
        RAISE EXCEPTION 'medicine_package_container contains orphan brand_id values';
    END IF;

    SELECT COUNT(*) INTO failure_count
    FROM generic_indication gi
    LEFT JOIN generic g ON g.generic_id = gi.generic_id
    LEFT JOIN indication i ON i.indication_id = gi.indication_id
    WHERE (gi.generic_id IS NOT NULL AND g.generic_id IS NULL)
       OR (gi.indication_id IS NOT NULL AND i.indication_id IS NULL);
    IF failure_count > 0 THEN
        RAISE EXCEPTION 'generic_indication contains orphan keys';
    END IF;

    IF (SELECT COUNT(*) FROM medicine WHERE generic_id IS NULL) <> 214 THEN
        RAISE EXCEPTION 'Unexpected count of medicines without a generic';
    END IF;

    IF (SELECT COUNT(*) FROM medicine WHERE manufacturer_id IS NULL) <> 147 THEN
        RAISE EXCEPTION 'Unexpected count of medicines without a manufacturer';
    END IF;

    IF (SELECT COUNT(*) FROM medicine_package_container WHERE unit_price IS NULL) <> 39 THEN
        RAISE EXCEPTION 'Unexpected count of container rows without a unit price';
    END IF;

    IF EXISTS (
        SELECT generic_id
        FROM generic_indication
        GROUP BY generic_id
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'A generic is linked to more than one indication';
    END IF;
END
$$;

SELECT 'validation_passed' AS result;
