-- =================================================
-- 05_MeasuresExploration.sql
-- Explores the numeric measures in the database
-- Summary statistics for prices and pack sizes
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- PACK PRICE
-- Total, average, min and max pack price
-- from medicine_package_size
-- ==========================

SELECT 
    COUNT(*)                    AS total_records,
    COUNT(pack_price)           AS non_null_prices,
    ROUND(AVG(pack_price), 2)   AS avg_price,
    MIN(pack_price)             AS min_price,
    MAX(pack_price)             AS max_price
FROM medicine_package_size;

-- ==========================
-- UNIT PRICE
-- Total, average, min and max unit price
-- from medicine_package_container
-- ==========================

SELECT 
    COUNT(*)                    AS total_records,
    COUNT(unit_price)           AS non_null_prices,
    ROUND(AVG(unit_price), 2)   AS avg_price,
    MIN(unit_price)             AS min_price,
    MAX(unit_price)             AS max_price
FROM medicine_package_container;

-- ==========================
-- NULL CHECKS
-- Check for NULLs in numeric and key columns
-- pack_price, unit_price and container_type
-- ==========================

SELECT 'pack_price'      AS column_name, COUNT(*) AS null_count FROM medicine_package_size      WHERE pack_price     IS NULL
UNION ALL
SELECT 'unit_price',                     COUNT(*) FROM medicine_package_container WHERE unit_price     IS NULL
UNION ALL
SELECT 'container_type',                 COUNT(*) FROM medicine_package_container WHERE container_type IS NULL;