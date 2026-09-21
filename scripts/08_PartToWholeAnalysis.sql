-- =================================================
-- 08_PartToWholeAnalysis.sql
-- Analyses how individual parts contribute to the whole
-- Percentages and proportions across the database
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- MEDICINE TYPE DISTRIBUTION
-- Percentage of allopathic vs herbal medicines
-- out of total medicines
-- ==========================

SELECT 
    type,
    COUNT(*) AS medicine_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM medicine
GROUP BY type
ORDER BY medicine_count DESC;

-- ==========================
-- MEDICINES BY DOSAGE FORM
-- Percentage of medicines per dosage form
-- out of total medicines
-- ==========================

SELECT 
    COALESCE(df.dosage_form_name, 'Unknown') AS dosage_form,
    COUNT(m.brand_id) AS medicine_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM medicine m
LEFT JOIN dosage_form df
    ON m.dosage_form_id = df.dosage_form_id
GROUP BY COALESCE(df.dosage_form_name, 'Unknown')
ORDER BY medicine_count DESC;

-- ==========================
-- MEDICINES BY MANUFACTURER
-- Percentage of medicines per manufacturer
-- out of total medicines
-- ==========================

SELECT 
    COALESCE(m.manufacturer_name, 'Unknown') AS manufacturer,
    COUNT(med.brand_id) AS medicine_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM medicine med
LEFT JOIN manufacturer m
    ON med.manufacturer_id = m.manufacturer_id
GROUP BY COALESCE(m.manufacturer_name, 'Unknown')
ORDER BY medicine_count DESC;

-- ==========================
-- GENERICS BY DRUG CLASS
-- Percentage of generics per drug class
-- out of total generics
-- ==========================

SELECT 
    dc.drug_class_name AS drug_class,
    COUNT(g.generic_id) AS generics_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM generic g
JOIN drug_class dc
    ON g.drug_class_id = dc.drug_class_id
GROUP BY dc.drug_class_name
ORDER BY generics_count DESC;

-- ==========================
-- CONTAINER TYPE DISTRIBUTION
-- Percentage of medicines per container type
-- out of total container records
-- ==========================

SELECT 
    pc.container_type AS container_type,
    COUNT(m.brand_id) AS medicine_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM medicine m
JOIN medicine_package_container pc 
    ON m.brand_id = pc.brand_id
GROUP BY pc.container_type
ORDER BY medicine_count DESC;
