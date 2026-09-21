# =================================================
# 01_ExportSourceData.py
# Exports cleaned data from PharmaMarketAnalytics_Clean
# to CSV files in source_data/ for PostgreSQL import
#
# WHY PYTHON:
# pandas handles CSV quoting correctly by default,
# ensuring all special characters, commas, and Unicode
# values (e.g. Bengali currency symbols) are preserved
# during export and re-import into PostgreSQL.
#
# REQUIREMENTS:
# - Python 3.x
# - pandas:  pip install pandas
# - pyodbc:  pip install pyodbc
#
# USAGE:
# 1. Optionally set the PHARMAMARKET_* environment variables
# 2. Ensure the selected cleaned database is running
# 3. Run: python scripts/01_ExportSourceData.py
# =================================================

import os
from pathlib import Path

import pandas as pd
import pyodbc

# ==========================
# CONFIGURATION
# Update these values to match your local setup
# ==========================

SERVER = os.getenv("PHARMAMARKET_SQL_SERVER", r"DESKTOP-SJC0GQV\SQLEXPRESS")
DATABASE = os.getenv("PHARMAMARKET_CLEAN_DATABASE", "PharmaMarketAnalytics_Clean_Test")
ODBC_DRIVER = os.getenv("PHARMAMARKET_ODBC_DRIVER", "ODBC Driver 17 for SQL Server")
OUTPUT_FOLDER = Path(
    os.getenv(
        "PHARMAMARKET_EDA_SOURCE_DIR",
        Path(__file__).resolve().parents[1] / "source_data",
    )
)
OUTPUT_FOLDER.mkdir(parents=True, exist_ok=True)

# ==========================
# CONNECTION
# Uses Windows Authentication (Trusted_Connection)
# No username or password required
# ==========================

conn = pyodbc.connect(
    f'DRIVER={{{ODBC_DRIVER}}};'
    f'SERVER={SERVER};'
    f'DATABASE={DATABASE};'
    f'Trusted_Connection=yes;'
)

print(f'Connected to {DATABASE} on {SERVER}')
print(f'Exporting to: {OUTPUT_FOLDER}')
print('-' * 50)

# ==========================
# EXPORT QUERIES
# Each table is exported without Slug columns as they
# are URL identifiers not needed for EDA analysis.
# Ordered by primary key for consistency.
#
# Schema notes:
#   - Medicine_PackageSize and Medicine_PackageContainer
#     are child tables created during the ETL phase by
#     splitting package and pricing data out of Medicine.
#   - Unit_Price and Container_Type live in
#     Medicine_PackageContainer.
#   - Medicine itself holds Brand_ID, Brand_Name, Type,
#     Dosage_Form_ID, Generic_ID, Strength,
#     and Manufacturer_ID.
# ==========================

tables = {
    'Drug_Class': '''
        SELECT Drug_Class_ID,
               Drug_Class_Name
        FROM Drug_Class
        ORDER BY Drug_Class_ID
    ''',

    'Dosage_Form': '''
        SELECT Dosage_Form_ID,
               Dosage_Form_Name
        FROM Dosage_Form
        ORDER BY Dosage_Form_ID
    ''',

    'Manufacturer': '''
        SELECT Manufacturer_ID,
               Manufacturer_Name
        FROM Manufacturer
        ORDER BY Manufacturer_ID
    ''',

    'Indication': '''
        SELECT Indication_ID,
               Indication_Name
        FROM Indication
        ORDER BY Indication_ID
    ''',

    'Generic': '''
        SELECT Generic_ID,
               Generic_Name,
               Drug_Class_ID
        FROM Generic
        ORDER BY Generic_ID
    ''',

    'Medicine': '''
        SELECT Brand_ID,
               Brand_Name,
               Type,
               Dosage_Form_ID,
               Generic_ID,
               Strength,
               Manufacturer_ID
        FROM Medicine
        ORDER BY Brand_ID
    ''',

    'Medicine_PackageSize': '''
        SELECT PackageSize_ID,
               Brand_ID,
               Pack_Size,
               Pack_Price
        FROM Medicine_PackageSize
        ORDER BY PackageSize_ID
    ''',

    'Medicine_PackageContainer': '''
        SELECT PackageContainer_ID,
               Brand_ID,
               Container_Size,
               Unit_Price,
               Container_Type
        FROM Medicine_PackageContainer
        ORDER BY PackageContainer_ID
    ''',

    'Generic_Indication': '''
        SELECT Generic_Indication_ID,
               Generic_ID,
               Indication_ID
        FROM Generic_Indication
        ORDER BY Generic_Indication_ID
    '''
}

# ==========================
# INTEGER COLUMNS PER TABLE
# pyodbc reads nullable INT columns from SQL Server as
# float (e.g. 299.0 instead of 299) when NULLs are present.
# Casting to pandas Int64 (nullable integer) before export
# ensures clean integer formatting in the CSV, which
# PostgreSQL COPY can then load without errors.
# ==========================

integer_columns = {
    'Drug_Class':               ['Drug_Class_ID'],
    'Dosage_Form':              ['Dosage_Form_ID'],
    'Manufacturer':             ['Manufacturer_ID'],
    'Indication':               ['Indication_ID'],
    'Generic':                  ['Generic_ID', 'Drug_Class_ID'],
    'Medicine':                 ['Brand_ID', 'Dosage_Form_ID', 'Generic_ID', 'Manufacturer_ID'],
    'Medicine_PackageSize':     ['PackageSize_ID', 'Brand_ID', 'Pack_Size'],
    'Medicine_PackageContainer':['PackageContainer_ID', 'Brand_ID'],
    'Generic_Indication':       ['Generic_Indication_ID', 'Generic_ID', 'Indication_ID'],
}

# ==========================
# EXPORT
# pandas to_csv handles quoted fields automatically.
# encoding='utf-8-sig' adds BOM marker for broader
# compatibility and preserves Unicode characters.
# Integer columns are cast to Int64 before export so
# they write as plain integers (e.g. 299, not 299.0).
# ==========================

for table_name, query in tables.items():
    print(f'Exporting {table_name}...', end=' ')

    df = pd.read_sql(query, conn)

    # Cast integer columns to nullable Int64 to prevent
    # float formatting (299.0) caused by NULLs in the data
    for col in integer_columns.get(table_name, []):
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors='coerce').astype('Int64')

    output_path = OUTPUT_FOLDER / f'{table_name}.csv'
    df.to_csv(output_path, index=False, encoding='utf-8-sig')

    print(f'{len(df):,} rows exported to {output_path}')

# ==========================
# CLEANUP
# ==========================

conn.close()

print('-' * 50)
print('Export complete. All tables saved to source_data/')
print('Next step: run 02_LoadSourceData.sql')
