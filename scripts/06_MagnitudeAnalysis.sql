-- =================================================
-- 06_MagnitudeAnalysis.sql
-- Analyses the magnitude of key entities
-- Counts and distributions across the database
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- MEDICINES BY DOSAGE FORM
-- Count the number of medicines per dosage form
-- Order by highest count first
-- ==========================

SELECT 
    df.dosage_form_name AS dosage_form,
    COUNT(m.brand_id) AS medicine_count
FROM medicine m
JOIN dosage_form df
    ON m.dosage_form_id = df.dosage_form_id
GROUP BY df.dosage_form_name
ORDER BY medicine_count DESC;

-- ==========================
-- MEDICINES BY MANUFACTURER
-- Count the number of medicines per manufacturer
-- Order by highest count first
-- ==========================

SELECT 
    m.manufacturer_name AS manufacturer,
    COUNT(med.brand_id) AS medicine_count
FROM medicine med 
JOIN manufacturer m
    ON med.manufacturer_id = m.manufacturer_id
GROUP BY m.manufacturer_name
ORDER BY medicine_count DESC;

-- ==========================
-- MEDICINES BY TYPE
-- Count the number of medicines per type
-- (allopathic, herbal, etc.)
-- Order by highest count first
-- ==========================

SELECT 
    type,
    COUNT(*) AS medicine_count
FROM medicine
GROUP BY type
ORDER BY medicine_count DESC;

-- ==========================
-- GENERICS BY DRUG CLASS
-- Count the number of generics per drug class
-- Order by highest count first
-- ==========================

SELECT 
    dc.drug_class_name AS drug_class,
    COUNT(g.generic_id) AS generics_count
FROM generic g
JOIN drug_class dc
    ON g.drug_class_id = dc.drug_class_id
GROUP BY dc.drug_class_name
ORDER BY generics_count DESC;

-- ==========================
-- INDICATIONS PER GENERIC
-- Distribution of indication counts per generic
-- Note: dataset limitation -- each generic has at most
-- one indication in the source data
-- ==========================

SELECT 
    COUNT(CASE WHEN indications_count = 0 THEN 1 END) AS no_indication,
    COUNT(CASE WHEN indications_count = 1 THEN 1 END) AS one_indication,
    COUNT(CASE WHEN indications_count > 1 THEN 1 END) AS multiple_indications
FROM (
    SELECT g.generic_id, COUNT(gi.indication_id) AS indications_count
    FROM generic g
    LEFT JOIN generic_indication gi ON g.generic_id = gi.generic_id
    GROUP BY g.generic_id
) sub;

-- ==========================
-- PACKAGE OPTIONS PER MEDICINE
-- Count how many package size options
-- each medicine has
-- Order by highest count first
-- ==========================

SELECT 
    m.brand_name AS medicine,
    COUNT(ps.package_size_id) AS package_options_count
FROM medicine m 
JOIN medicine_package_size ps
    ON m.brand_id = ps.brand_id
GROUP BY m.brand_id, m.brand_name
ORDER BY package_options_count DESC;

-- ==========================
-- MEDICINES BY CONTAINER TYPE
-- Count the number of medicines per container type
-- Order by highest count first
-- ==========================

SELECT 
    pc.container_type AS container_type,
    COUNT(m.brand_id) AS medicine_count
FROM medicine m
JOIN medicine_package_container pc 
    ON m.brand_id = pc.brand_id
GROUP BY pc.container_type
ORDER BY medicine_count DESC;