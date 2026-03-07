-- =================================================
-- 07_RankingAnalysis.sql
-- Ranks key entities by various metrics
-- Top and bottom performers across the database
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- TOP 10 MANUFACTURERS BY MEDICINE COUNT
-- The 10 manufacturers with the most medicines
-- ==========================

SELECT 
    m.manufacturer_name AS manufacturer,
    COUNT(med.brand_id) AS medicine_count
FROM manufacturer m
JOIN medicine med
    ON m.manufacturer_id = med.manufacturer_id
GROUP BY m.manufacturer_id, m.manufacturer_name
ORDER BY medicine_count DESC
LIMIT 10;

-- ==========================
-- BOTTOM 10 MANUFACTURERS BY MEDICINE COUNT
-- The 10 manufacturers with the fewest medicines
-- ==========================

SELECT 
    m.manufacturer_name AS manufacturer,
    COUNT(med.brand_id) AS medicine_count
FROM manufacturer m
JOIN medicine med
    ON m.manufacturer_id = med.manufacturer_id
GROUP BY m.manufacturer_id, m.manufacturer_name
ORDER BY medicine_count ASC
LIMIT 10;

-- ==========================
-- TOP 10 DRUG CLASSES BY GENERIC COUNT
-- The 10 drug classes with the most generics
-- ==========================

SELECT 
    dc.drug_class_name AS drug_class,
    COUNT(g.generic_id) AS generics_count
FROM drug_class dc
JOIN generic g
    ON dc.drug_class_id = g.drug_class_id
GROUP BY dc.drug_class_id, dc.drug_class_name
ORDER BY generics_count DESC
LIMIT 10;

-- ==========================
-- TOP 10 MEDICINES BY PACK PRICE
-- The 10 most expensive medicines by pack price
-- ==========================

SELECT 
    m.brand_name AS medicine,
    ps.pack_price AS pack_price
FROM medicine m
JOIN medicine_package_size ps
    ON m.brand_id = ps.brand_id
ORDER BY pack_price DESC
LIMIT 10;

-- ==========================
-- TOP 10 MEDICINES BY UNIT PRICE
-- The 10 most expensive medicines by unit price
-- ==========================

SELECT 
    m.brand_name AS medicine,
    pc.unit_price AS unit_price
FROM medicine m
JOIN medicine_package_container pc
    ON m.brand_id = pc.brand_id
ORDER BY unit_price DESC NULLS LAST
LIMIT 10;

-- ==========================
-- TOP 10 DOSAGE FORMS BY MEDICINE COUNT
-- The 10 most common dosage forms
-- ==========================

SELECT
    df.dosage_form_name AS dosage_form,
    COUNT(m.brand_id) AS medicine_count
FROM dosage_form df 
JOIN medicine m
    ON df.dosage_form_id = m.dosage_form_id
GROUP BY df.dosage_form_name
ORDER BY medicine_count DESC
LIMIT 10;