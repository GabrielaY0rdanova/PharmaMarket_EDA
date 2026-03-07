-- =================================================
-- 12_ReportManufacturers.sql
-- Comprehensive report on manufacturers
-- Combines medicine counts, dosage forms, generics,
-- and pricing information per manufacturer
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- MANUFACTURERS REPORT
-- For each manufacturer show:
--   - Manufacturer name
--   - Total number of medicines produced
--   - Number of distinct generics covered
--   - Number of distinct dosage forms produced
--   - Number of distinct drug classes covered
--   - Minimum pack price across their medicines
--   - Maximum pack price across their medicines
--   - Average pack price across their medicines
-- Order by medicine count descending
-- ==========================

WITH manufacturer_pack_stats AS (
    SELECT
        m.manufacturer_id,
        MIN(ps.pack_price)              AS min_pack_price,
        MAX(ps.pack_price)              AS max_pack_price,
        ROUND(AVG(ps.pack_price), 2)    AS avg_pack_price
    FROM medicine m
    JOIN medicine_package_size ps ON m.brand_id = ps.brand_id
    GROUP BY m.manufacturer_id
)
SELECT
    mfr.manufacturer_name,
    COUNT(DISTINCT m.brand_id)          AS medicine_count,
    COUNT(DISTINCT m.generic_id)        AS generic_count,
    COUNT(DISTINCT m.dosage_form_id)    AS dosage_form_count,
    COUNT(DISTINCT dc.drug_class_id)    AS drug_class_count,
    mps.min_pack_price,
    mps.max_pack_price,
    mps.avg_pack_price
FROM manufacturer mfr
JOIN medicine m                         ON mfr.manufacturer_id = m.manufacturer_id
LEFT JOIN generic g                     ON m.generic_id = g.generic_id
LEFT JOIN drug_class dc                 ON g.drug_class_id = dc.drug_class_id
LEFT JOIN manufacturer_pack_stats mps   ON mfr.manufacturer_id = mps.manufacturer_id
GROUP BY
    mfr.manufacturer_id,
    mfr.manufacturer_name,
    mps.min_pack_price,
    mps.max_pack_price,
    mps.avg_pack_price
ORDER BY medicine_count DESC;