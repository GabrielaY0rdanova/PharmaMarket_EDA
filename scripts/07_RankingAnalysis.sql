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
-- MANUFACTURERS BY DRUG CLASS COVERAGE
-- Number of distinct drug classes
-- represented in each manufacturer's portfolio
-- Order by highest coverage first
-- ==========================

SELECT
    mfr.manufacturer_name AS manufacturer,
    COUNT(DISTINCT dc.drug_class_id) AS drug_class_count
FROM manufacturer mfr
JOIN medicine m
    ON mfr.manufacturer_id = m.manufacturer_id
JOIN generic g
    ON m.generic_id = g.generic_id
JOIN drug_class dc
    ON g.drug_class_id = dc.drug_class_id
GROUP BY mfr.manufacturer_name
ORDER BY drug_class_count DESC;

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

-- ==========================
-- DRUG CLASSES BY AVERAGE PACK PRICE
-- Average, minimum and maximum pack price
-- for medicines in each drug class
-- Order by highest average price first
-- ==========================

SELECT 
    dc.drug_class_name AS drug_class,
    ROUND(AVG(ps.pack_price), 2) AS avg_pack_price,
    MIN(ps.pack_price) AS min_pack_price,
    MAX(ps.pack_price) AS max_pack_price
FROM medicine m
JOIN generic g 
    ON m.generic_id = g.generic_id
JOIN drug_class dc 
    ON g.drug_class_id = dc.drug_class_id
JOIN medicine_package_size ps
    ON m.brand_id = ps.brand_id
GROUP BY dc.drug_class_name
ORDER BY avg_pack_price DESC;