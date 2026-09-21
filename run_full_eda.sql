\set ON_ERROR_STOP on
\encoding UTF8

\if :{?source_data_dir}
\else
    \echo 'Pass -v source_data_dir="E:/path/to/PharmaMarket_EDA/source_data".'
    \quit 3
\endif

\echo 'Rebuilding database:' :DBNAME
BEGIN;
\ir scripts/00_InitDatabase.sql
\ir scripts/02_LoadSourceData.sql
\ir tests/13_ValidationGate.sql
COMMIT;
\echo 'EDA database rebuild and validation completed.'
