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