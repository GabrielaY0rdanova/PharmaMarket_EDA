-- =================================================
-- 11_ReportMedicines.sql
-- Comprehensive report on medicines
-- Combines generic, manufacturer, dosage form,
-- and pricing information per medicine
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- MEDICINES REPORT
-- For each medicine show:
--   - Brand name
--   - Type (allopathic/herbal)
--   - Generic name
--   - Drug class name
--   - Manufacturer name
--   - Dosage form name
--   - Number of pack size options available
--   - Minimum pack price
--   - Maximum pack price
--   - Number of container options available
--   - Minimum unit price
--   - Maximum unit price
-- Order by brand name ascending
-- ==========================

WITH pack_stats AS (
    SELECT
        brand_id,
        COUNT(*)            AS pack_options,
        MIN(pack_price)     AS min_pack_price,
        MAX(pack_price)     AS max_pack_price
    FROM medicine_package_size
    GROUP BY brand_id
),
container_stats AS (
    SELECT
        brand_id,
        COUNT(*)            AS container_options,
        MIN(unit_price)     AS min_unit_price,
        MAX(unit_price)     AS max_unit_price
    FROM medicine_package_container
    GROUP BY brand_id
)
SELECT
    m.brand_name,
    m.type,
    g.generic_name,
    dc.drug_class_name,
    mfr.manufacturer_name,
    df.dosage_form_name,
    COALESCE(ps.pack_options, 0)            AS pack_options,
    ps.min_pack_price,
    ps.max_pack_price,
    COALESCE(cs.container_options, 0)       AS container_options,
    cs.min_unit_price,
    cs.max_unit_price
FROM medicine m
LEFT JOIN generic g             ON m.generic_id = g.generic_id
LEFT JOIN drug_class dc         ON g.drug_class_id = dc.drug_class_id
LEFT JOIN manufacturer mfr      ON m.manufacturer_id = mfr.manufacturer_id
JOIN dosage_form df              ON m.dosage_form_id = df.dosage_form_id
LEFT JOIN pack_stats ps         ON m.brand_id = ps.brand_id
LEFT JOIN container_stats cs    ON m.brand_id = cs.brand_id
ORDER BY m.brand_name ASC;