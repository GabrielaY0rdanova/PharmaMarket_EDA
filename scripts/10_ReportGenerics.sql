-- =================================================
-- 10_ReportGenerics.sql
-- Comprehensive report on generics
-- Combines drug class, indications and medicine counts
-- per generic into a single summary view
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- GENERICS REPORT
-- For each generic show:
--   - Generic name
--   - Drug class name
--   - Number of medicines (brands) using this generic
--   - Number of indications linked to this generic
--   - Number of dosage forms available for this generic
-- Order by medicine count descending
-- ==========================

WITH generic_medicine_stats AS (
    SELECT 
        generic_id,
        COUNT(DISTINCT brand_id)       AS medicine_count,
        COUNT(DISTINCT dosage_form_id) AS dosage_form_count
    FROM medicine
    GROUP BY generic_id
),
generic_indications AS (
    SELECT 
        generic_id, 
        COUNT(indication_id) AS indication_count
    FROM generic_indication
    GROUP BY generic_id
)
SELECT 
    g.generic_name,
    dc.drug_class_name,
    gms.medicine_count,
    COALESCE(gi.indication_count, 0) AS indication_count,
    gms.dosage_form_count
FROM generic g
JOIN drug_class dc               ON g.drug_class_id = dc.drug_class_id
JOIN generic_medicine_stats gms  ON g.generic_id = gms.generic_id
LEFT JOIN generic_indications gi ON g.generic_id = gi.generic_id
ORDER BY medicine_count DESC;