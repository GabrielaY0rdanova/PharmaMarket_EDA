-- =================================================
-- 00_InitDatabase.sql
-- Creates all tables in PharmaMarketAnalytics_EDA
--
-- REQUIREMENTS:
-- The PharmaMarketAnalytics_EDA database must already
-- exist before running this script.
-- Create it manually in pgAdmin or via psql:
--   CREATE DATABASE "PharmaMarketAnalytics_EDA";
--
-- USAGE:
-- Run this script once before any other scripts.
-- It is safe to re-run in the named EDA databases. All tables are dropped and
-- recreated from scratch.
--
-- NOTES:
-- Slug columns are excluded as they are not needed
-- for analysis purposes.
-- Source data: PharmaMarketAnalytics_Clean (SQL Server)
--
-- NAMING CONVENTION:
-- Previous projects (ETL, Cleaning) used PascalCase
-- as per SQL Server convention. This project follows
-- snake_case, which is the PostgreSQL standard.
-- =================================================


DO $$
BEGIN
    IF lower(current_database()) NOT IN (
        'pharmamarketanalytics_eda',
        'pharmamarketanalytics_eda_test'
    ) THEN
        RAISE EXCEPTION
            'Refusing destructive reset in database %', current_database();
    END IF;
END
$$;

-- ==========================
-- DROP TABLES IF EXIST
-- Drop in reverse FK dependency order
-- ==========================

DROP TABLE IF EXISTS generic_indication         CASCADE;
DROP TABLE IF EXISTS medicine_package_container CASCADE;
DROP TABLE IF EXISTS medicine_package_size      CASCADE;
DROP TABLE IF EXISTS medicine                   CASCADE;
DROP TABLE IF EXISTS generic                    CASCADE;
DROP TABLE IF EXISTS indication                 CASCADE;
DROP TABLE IF EXISTS manufacturer               CASCADE;
DROP TABLE IF EXISTS dosage_form                CASCADE;
DROP TABLE IF EXISTS drug_class                 CASCADE;


-- ==========================
-- CREATE TABLES
-- ==========================

CREATE TABLE drug_class (
    drug_class_id   INT             PRIMARY KEY,
    drug_class_name VARCHAR(255)    NOT NULL
);

CREATE TABLE dosage_form (
    dosage_form_id      INT             PRIMARY KEY,
    dosage_form_name    VARCHAR(255)    NOT NULL
);

CREATE TABLE manufacturer (
    manufacturer_id     INT             PRIMARY KEY,
    manufacturer_name   VARCHAR(255)    NOT NULL
);

CREATE TABLE indication (
    indication_id   INT             PRIMARY KEY,
    indication_name VARCHAR(255)    NOT NULL
);

CREATE TABLE generic (
    generic_id      INT             PRIMARY KEY,
    generic_name    VARCHAR(255)    NOT NULL,
    drug_class_id   INT             REFERENCES drug_class(drug_class_id)
);

CREATE TABLE medicine (
    brand_id        INT             PRIMARY KEY,
    brand_name      VARCHAR(255)    NOT NULL,
    type            VARCHAR(50),
    dosage_form_id  INT             REFERENCES dosage_form(dosage_form_id),
    generic_id      INT             REFERENCES generic(generic_id),
    strength        VARCHAR(100),
    manufacturer_id INT             REFERENCES manufacturer(manufacturer_id)
);

CREATE TABLE medicine_package_size (
    package_size_id INT             PRIMARY KEY,
    brand_id        INT             REFERENCES medicine(brand_id),
    pack_size       VARCHAR(100),
    pack_price      NUMERIC(10, 2)
);

CREATE TABLE medicine_package_container (
    package_container_id    INT             PRIMARY KEY,
    brand_id                INT             REFERENCES medicine(brand_id),
    container_size          VARCHAR(100),
    unit_price              NUMERIC(10, 2),
    container_type          VARCHAR(100)
);

CREATE TABLE generic_indication (
    generic_indication_id   INT             PRIMARY KEY,
    generic_id              INT             REFERENCES generic(generic_id),
    indication_id           INT             REFERENCES indication(indication_id)
);


-- ==========================
-- VERIFY
-- ==========================

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
