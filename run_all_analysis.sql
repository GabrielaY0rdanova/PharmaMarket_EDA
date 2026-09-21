\set ON_ERROR_STOP on
\encoding UTF8
\echo 'Running PharmaMarket EDA scripts against:' :DBNAME
\ir scripts/03_DatabaseExploration.sql
\ir scripts/04_DimensionsExploration.sql
\ir scripts/05_MeasuresExploration.sql
\ir scripts/06_MagnitudeAnalysis.sql
\ir scripts/07_RankingAnalysis.sql
\ir scripts/08_PartToWholeAnalysis.sql
\ir scripts/09_DataSegmentation.sql
\ir scripts/10_ReportGenerics.sql
\ir scripts/11_ReportMedicines.sql
\ir scripts/12_ReportManufacturers.sql
\echo 'All EDA scripts completed successfully.'
