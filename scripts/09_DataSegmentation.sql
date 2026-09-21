-- =================================================
-- 09_DataSegmentation.sql
-- Segments data into meaningful groups
-- Price ranges, medicine categories and size buckets
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- MEDICINES BY PRICE RANGE (PACK PRICE)
-- Segment medicines into price buckets
-- based on pack price
-- Low:    < 100
-- Medium: 100 - 500
-- High:   500 - 1000
-- Premium: > 1000
-- ==========================

SELECT 
    CASE 
    WHEN ps.pack_price IS NULL              THEN 'Unknown'
    WHEN ps.pack_price < 100                THEN 'Low'
    WHEN ps.pack_price BETWEEN 100 AND 500  THEN 'Medium'
    WHEN ps.pack_price BETWEEN 500 AND 1000 THEN 'High'
    ELSE                                         'Premium'
END AS price_range,
COUNT(*) AS medicine_count
FROM medicine m
JOIN medicine_package_size ps
    ON m.brand_id = ps.brand_id
GROUP BY price_range
ORDER BY medicine_count DESC;

-- ==========================
-- MEDICINES BY PRICE RANGE (UNIT PRICE)
-- Segment medicines into price buckets
-- based on unit price
-- Low:    < 10
-- Medium: 10 - 100
-- High:   100 - 500
-- Premium: > 500
-- ==========================

SELECT 
    CASE 
    WHEN pc.unit_price IS NULL             THEN 'Unknown'
    WHEN pc.unit_price < 10                THEN 'Low'
    WHEN pc.unit_price BETWEEN 10 AND 100  THEN 'Medium'
    WHEN pc.unit_price BETWEEN 100 AND 500 THEN 'High'
    ELSE                                         'Premium'
END AS price_range,
COUNT(*) AS medicine_count
FROM medicine m
JOIN medicine_package_container pc
    ON m.brand_id = pc.brand_id
GROUP BY price_range
ORDER BY medicine_count DESC;

-- ==========================
-- AVERAGE PACK PRICE BY DOSAGE FORM
-- Compare pricing levels across
-- different dosage forms
-- Order by highest average price first
-- ==========================

SELECT
    df.dosage_form_name AS dosage_form,
    ROUND(AVG(ps.pack_price), 2) AS avg_pack_price,
    MIN(ps.pack_price) AS min_pack_price,
    MAX(ps.pack_price) AS max_pack_price
FROM medicine m
JOIN dosage_form df
    ON m.dosage_form_id = df.dosage_form_id
JOIN medicine_package_size ps
    ON m.brand_id = ps.brand_id
GROUP BY df.dosage_form_name
ORDER BY avg_pack_price DESC;

-- ==========================
-- GENERICS BY DRUG CLASS SIZE
-- Segment drug classes by how many generics they contain
-- Small:  1 - 5 generics
-- Medium: 6 - 20 generics
-- Large:  > 20 generics
-- ==========================

SELECT 
    CASE 
        WHEN generics_count BETWEEN 1 AND 5  THEN 'Small'
        WHEN generics_count BETWEEN 6 AND 20 THEN 'Medium'
        ELSE                                      'Large'
    END AS drug_class_size,
    COUNT(*) AS drug_class_count
FROM (
    SELECT 
        dc.drug_class_name,
        COUNT(g.generic_id) AS generics_count
    FROM drug_class dc
    JOIN generic g ON dc.drug_class_id = g.drug_class_id
    GROUP BY dc.drug_class_name
) sub
GROUP BY drug_class_size
ORDER BY drug_class_count DESC;

-- ==========================
-- MANUFACTURERS BY PORTFOLIO SIZE
-- Segment manufacturers by how many medicines they produce
-- Small:  1 - 10 medicines
-- Medium: 11 - 50 medicines
-- Large:  > 50 medicines
-- ==========================

SELECT
    CASE
        WHEN medicine_count BETWEEN 1 AND 10  THEN 'Small'
        WHEN medicine_count BETWEEN 11 AND 50 THEN 'Medium'
        ELSE                                       'Large'
    END AS portfolio_size,
    COUNT(*) AS manufacturer_count
FROM (
    SELECT 
        m.manufacturer_name,
        COUNT(med.brand_id) AS medicine_count
    FROM medicine med 
    JOIN manufacturer m
        ON med.manufacturer_id = m.manufacturer_id
    GROUP BY m.manufacturer_name
) sub
GROUP BY portfolio_size
ORDER BY manufacturer_count DESC;

-- ==========================
-- GENERIC MARKET COMPETITION
-- Segment generics based on how many
-- branded medicines exist for each generic
--
-- Monopoly:        1 brand
-- Low Competition: 2 - 5 brands
-- Medium:          6 - 15 brands
-- High:            > 15 brands
-- ==========================

SELECT
    CASE
        WHEN brand_count = 1              THEN 'Monopoly'
        WHEN brand_count BETWEEN 2 AND 5  THEN 'Low Competition'
        WHEN brand_count BETWEEN 6 AND 15 THEN 'Moderate Competition'
        ELSE                                   'High Competition'
    END AS competition_level,
    COUNT(*) AS generic_count
FROM (
    SELECT
        g.generic_id,
        COUNT(m.brand_id) AS brand_count
    FROM generic g
    JOIN medicine m
        ON g.generic_id = m.generic_id
    GROUP BY g.generic_id
) sub
GROUP BY competition_level
ORDER BY generic_count DESC;
