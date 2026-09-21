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
-- Run through run_full_eda.sql with psql. The runner builds
-- all file paths from its source_data_dir variable.
--
-- NOTES:
-- PostgreSQL COPY reads the files on the database server.
-- For this local setup, PostgreSQL and the CSV files are on
-- the same Windows machine.
--
-- CSV files were exported with utf-8-sig encoding
-- (BOM marker) for SQL Server compatibility. PostgreSQL
-- handles this automatically with ENCODING 'UTF8'.
-- =================================================


-- ==========================
-- LOAD TABLES
-- Load in FK dependency order (parents before children)
-- ==========================

\if :{?source_data_dir}
\else
    \echo 'source_data_dir is required. Run this script through run_full_eda.sql.'
    \quit 3
\endif

\set drug_class_file :source_data_dir '/Drug_Class.csv'
\set dosage_form_file :source_data_dir '/Dosage_Form.csv'
\set manufacturer_file :source_data_dir '/Manufacturer.csv'
\set indication_file :source_data_dir '/Indication.csv'
\set generic_file :source_data_dir '/Generic.csv'
\set medicine_file :source_data_dir '/Medicine.csv'
\set package_size_file :source_data_dir '/Medicine_PackageSize.csv'
\set package_container_file :source_data_dir '/Medicine_PackageContainer.csv'
\set generic_indication_file :source_data_dir '/Generic_Indication.csv'

-- Drug_Class
COPY drug_class (drug_class_id, drug_class_name) FROM :'drug_class_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Dosage_Form
COPY dosage_form (dosage_form_id, dosage_form_name) FROM :'dosage_form_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Manufacturer
COPY manufacturer (manufacturer_id, manufacturer_name) FROM :'manufacturer_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Indication
COPY indication (indication_id, indication_name) FROM :'indication_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Generic
COPY generic (generic_id, generic_name, drug_class_id) FROM :'generic_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Medicine
COPY medicine (brand_id, brand_name, type, dosage_form_id, generic_id, strength, manufacturer_id) FROM :'medicine_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Medicine_PackageSize
COPY medicine_package_size (package_size_id, brand_id, pack_size, pack_price) FROM :'package_size_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Medicine_PackageContainer
COPY medicine_package_container (package_container_id, brand_id, container_size, unit_price, container_type) FROM :'package_container_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

-- Generic_Indication
COPY generic_indication (generic_indication_id, generic_id, indication_id) FROM :'generic_indication_file' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');


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
