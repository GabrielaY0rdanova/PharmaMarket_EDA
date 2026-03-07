-- =================================================
-- 04_DimensionsExploration.sql
-- Explores the dimension tables in the database
-- Distinct values, distributions and NULL checks
--
-- USAGE:
-- Run this script in your preferred PostgreSQL client
-- (VS Code with SQLTools, pgAdmin, or psql)
-- =================================================


-- ==========================
-- DRUG CLASS
-- List all distinct drug classes
-- Count total number of drug classes
-- ==========================

SELECT DISTINCT drug_class_name
FROM drug_class
ORDER BY drug_class_name;

SELECT COUNT(*) AS total_drug_classes
FROM drug_class;

-- ==========================
-- DOSAGE FORM
-- List all distinct dosage forms
-- Count total number of dosage forms
-- ==========================

SELECT DISTINCT dosage_form_name
FROM dosage_form
ORDER BY dosage_form_name;

SELECT COUNT(*) AS total_dosage_forms
FROM dosage_form;

-- ==========================
-- MANUFACTURER
-- List all distinct manufacturers
-- Count total number of manufacturers
-- ==========================

SELECT DISTINCT manufacturer_name
FROM manufacturer
ORDER BY manufacturer_name;

SELECT COUNT(*) AS total_manufacturers
FROM manufacturer;

-- ==========================
-- INDICATION
-- List all distinct indications
-- Count total number of indications
-- ==========================

SELECT DISTINCT indication_name
FROM indication
ORDER BY indication_name;

SELECT COUNT(*) AS total_indications
FROM indication;

-- ==========================
-- NULL CHECKS
-- Check for NULLs in dimension tables
-- drug_class, dosage_form, manufacturer, indication
-- ==========================

SELECT 'drug_class'  AS table_name, COUNT(*) AS null_count FROM drug_class  WHERE drug_class_name  IS NULL
UNION ALL
SELECT 'dosage_form',               COUNT(*) FROM dosage_form  WHERE dosage_form_name  IS NULL
UNION ALL
SELECT 'manufacturer',              COUNT(*) FROM manufacturer WHERE manufacturer_name IS NULL
UNION ALL
SELECT 'indication',                COUNT(*) FROM indication   WHERE indication_name   IS NULL;