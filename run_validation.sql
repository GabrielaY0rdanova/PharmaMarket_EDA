\set ON_ERROR_STOP on
\encoding UTF8
\echo 'Validating database:' :DBNAME
\ir tests/13_ValidationGate.sql
\echo 'Validation completed.'
