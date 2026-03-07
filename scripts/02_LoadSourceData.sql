-- =================================================
-- 02_LoadSourceData.sql
-- Loads CSV snapshots from source_data/ into
-- PharmaMarketAnalytics_EDA
--
-- REQUIREMENTS:
-- - 00_InitDatabase.sql must have been run first
-- - CSV files must exist in the source_data/ folder
-- - 01_ExportSourceData.py must have been run first
--   to generate the CSV snapshots
--
-- USAGE:
-- 1. Update the file path in each COPY statement
--    to match the location of source_data/ on your
--    local machine
-- 2. Run this script in your preferred PostgreSQL client
--    (VS Code with SQLTools, pgAdmin, or psql)
--
-- NOTES:
-- PostgreSQL COPY requires absolute file paths with
-- forward slashes. Update the path below to match
-- your local setup:
--   E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data
--
-- CSV files were exported with utf-8-sig encoding
-- (BOM marker) for SQL Server compatibility. PostgreSQL
-- handles this automatically with ENCODING 'UTF8'.
-- =================================================


-- ==========================
-- LOAD TABLES
-- Load in FK dependency order (parents before children)
-- ==========================

-- Drug_Class
COPY drug_class (drug_class_id, drug_class_name)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Drug_Class.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Dosage_Form
COPY dosage_form (dosage_form_id, dosage_form_name)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Dosage_Form.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Manufacturer
COPY manufacturer (manufacturer_id, manufacturer_name)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Manufacturer.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Indication
COPY indication (indication_id, indication_name)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Indication.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Generic
COPY generic (generic_id, generic_name, drug_class_id)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Generic.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Medicine
COPY medicine (brand_id, brand_name, type, dosage_form_id, generic_id, strength, manufacturer_id)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Medicine.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Medicine_PackageSize
COPY medicine_package_size (package_size_id, brand_id, pack_size, pack_price)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Medicine_PackageSize.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Medicine_PackageContainer
COPY medicine_package_container (package_container_id, brand_id, container_size, unit_price, container_type)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Medicine_PackageContainer.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Generic_Indication
COPY generic_indication (generic_indication_id, generic_id, indication_id)
FROM 'E:/Data Analysis/My Projects/PharmaMarket_EDA/source_data/Generic_Indication.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


-- ==========================
-- VERIFY
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