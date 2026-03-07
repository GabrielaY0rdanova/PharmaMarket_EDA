-- =================================================
-- 03_DatabaseExploration.sql
-- Explores the structure of the database
-- Tables, columns, data types and row counts
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- EXPLORE TABLES
-- List all tables in the public schema
-- ==========================

SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'public';


-- ==========================
-- EXPLORE COLUMNS
-- List all columns, their data types and nullability
-- for each table in the public schema
-- ==========================

SELECT 
    TABLE_NAME,
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- ==========================
-- EXPLORE ROW COUNTS
-- Count the number of rows in each table
-- ==========================

SELECT 'drug_class'                AS table_name, COUNT(*) AS row_count FROM drug_class
UNION ALL
SELECT 'dosage_form',                              COUNT(*) FROM dosage_form
UNION ALL
SELECT 'manufacturer',                             COUNT(*) FROM manufacturer
UNION ALL
SELECT 'indication',                               COUNT(*) FROM indication
UNION ALL
SELECT 'generic',                                  COUNT(*) FROM generic
UNION ALL
SELECT 'medicine',                                 COUNT(*) FROM medicine
UNION ALL
SELECT 'medicine_package_size',                    COUNT(*) FROM medicine_package_size
UNION ALL
SELECT 'medicine_package_container',               COUNT(*) FROM medicine_package_container
UNION ALL
SELECT 'generic_indication',                       COUNT(*) FROM generic_indication
ORDER BY table_name;