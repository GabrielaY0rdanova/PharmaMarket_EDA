# 🔍 PharmaMarket_EDA

## 🏷️ Project Badges

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python&logoColor=white)
![Kaggle](https://img.shields.io/badge/Kaggle-Dataset-orange?logo=kaggle&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

## 📖 Overview

This project performs a **structured Exploratory Data Analysis** on the cleaned PharmaMarket dataset.  
It investigates the structure, competition, pricing patterns and market composition of medicines, generics and manufacturers in the Bangladeshi pharmaceutical market using modular analytical SQL scripts.

The analysis is built on top of the cleaned database produced in [PharmaMarket_Cleaning](https://github.com/GabrielaY0rdanova/PharmaMarket_Cleaning), migrated to PostgreSQL for this project.

## 📊 Key Analytical Questions

This exploratory analysis focuses on understanding the structure, competition and pricing patterns of the pharmaceutical market. The analysis aims to answer the following questions:

- Which therapeutic classes dominate the pharmaceutical market?
- Which manufacturers produce the most medicines?
- How competitive are different generics (how many brands exist per generic)?
- What dosage forms are most commonly used?
- How are medicines priced across the market?
- How concentrated is the manufacturer landscape?
- How diverse are manufacturer portfolios across drug classes?

## 🎯 What This Project Demonstrates

This project showcases an end-to-end analytical workflow including:

- Designing and analysing a **relational pharmaceutical database** using PostgreSQL
- Performing **structured exploratory data analysis (EDA)** using modular SQL scripts
- Applying analytical techniques such as **ranking, segmentation, magnitude analysis and part-to-whole analysis**
- Writing **clean, documented and reproducible SQL workflows**
- Preparing analytical outputs that will be used for **interactive Tableau data visualisation**

## 🔗 Related Projects

This project is the **third stage** of the PharmaMarket portfolio series:

👉 **[PharmaMarket_ETL](https://github.com/GabrielaY0rdanova/PharmaMarket_ETL)** — ETL pipeline from raw CSV files into a structured SQL Server database  
👉 **[PharmaMarket_Cleaning](https://github.com/GabrielaY0rdanova/PharmaMarket_Cleaning)** — Data cleaning and quality validation on the ETL output

**If you have already run the Cleaning project**, `PharmaMarketAnalytics_Clean` is already populated on your machine. Run `01_ExportSourceData.py` to export the data to CSV, then run `00_InitDatabase.sql` and `02_LoadSourceData.sql` to set up the PostgreSQL database.

**If you have not run the Cleaning project**, the `source_data/` folder in this repository already contains the pre-exported CSV snapshots. Start from `00_InitDatabase.sql` and run `02_LoadSourceData.sql` to load directly.

---

## 🗂️ Project Structure

```
PharmaMarket_EDA/
│
├── docs/                              # Documentation and visuals
│   └── Pharma_ERD.png                 # Entity Relationship Diagram
│
├── source_data/                       # CSV snapshots exported from PharmaMarketAnalytics_Clean
│   ├── Drug_Class.csv
│   ├── Dosage_Form.csv
│   ├── Manufacturer.csv
│   ├── Indication.csv
│   ├── Generic.csv
│   ├── Medicine.csv
│   ├── Medicine_PackageSize.csv
│   ├── Medicine_PackageContainer.csv
│   └── Generic_Indication.csv
│
├── scripts/                           # SQL and Python scripts
│   ├── 01_ExportSourceData.py         # Exports cleaned data from SQL Server to CSV
│   ├── 00_InitDatabase.sql            # Creates all 9 tables in PostgreSQL
│   ├── 02_LoadSourceData.sql          # Loads CSVs into PostgreSQL using COPY
│   ├── 03_DatabaseExploration.sql     # Lists tables, columns and row counts
│   ├── 04_DimensionsExploration.sql   # Explores dimension tables and NULL checks
│   ├── 05_MeasuresExploration.sql     # Summary statistics for prices
│   ├── 06_MagnitudeAnalysis.sql       # Counts and distributions across key entities
│   ├── 07_RankingAnalysis.sql         # Top and bottom rankings by count and price
│   ├── 08_PartToWholeAnalysis.sql     # Percentage distributions across categories
│   ├── 09_DataSegmentation.sql        # Segments medicines and manufacturers into groups
│   ├── 10_ReportGenerics.sql          # Comprehensive generics report using CTEs
│   ├── 11_ReportMedicines.sql         # Comprehensive medicines report using CTEs
│   └── 12_ReportManufacturers.sql     # Comprehensive manufacturers report using CTEs
│
└── README.md
```

## 🏗️ Database Schema

The database contains 9 tables migrated from SQL Server to PostgreSQL. Column names use snake_case following PostgreSQL conventions. Slug columns were excluded from the migration as they are not needed for analysis.

![ERD Diagram](docs/Pharma_ERD.png)

### Tables & Row Counts

| Table | Rows |
|---|---|
| drug_class | 422 |
| dosage_form | 113 |
| manufacturer | 240 |
| indication | 2,043 |
| generic | 1,711 |
| medicine | 21,708 |
| medicine_package_size | 14,349 |
| medicine_package_container | 22,707 |
| generic_indication | 1,608 |

## 🔄 EDA Workflow

### Step 1 — Export source data *(skip if you have not run the Cleaning project)*

Run `01_ExportSourceData.py` to export the cleaned data from `PharmaMarketAnalytics_Clean` (SQL Server) into the `source_data/` folder as CSV files.

> ⚠️ **Only needed if you have run the Cleaning project locally.** If you have not, the `source_data/` folder already contains the pre-exported CSVs — skip this step and go straight to Step 2.

### Step 2 — Initialise the database

Run `00_InitDatabase.sql` in your preferred PostgreSQL client to create all 9 tables in the `PharmaMarketAnalytics_EDA` database.

### Step 3 — Load source data

Run `02_LoadSourceData.sql` to load the CSV files into PostgreSQL using `COPY`.

### Step 4 — Run analysis scripts

Execute the analysis scripts in order:

1. `03_DatabaseExploration.sql`
2. `04_DimensionsExploration.sql`
3. `05_MeasuresExploration.sql`
4. `06_MagnitudeAnalysis.sql`
5. `07_RankingAnalysis.sql`
6. `08_PartToWholeAnalysis.sql`
7. `09_DataSegmentation.sql`
8. `10_ReportGenerics.sql`
9. `11_ReportMedicines.sql`
10. `12_ReportManufacturers.sql`

## 🔍 Key Findings

### Market Structure
- The dataset contains **21,708 medicines** produced by **240 manufacturers**, covering **1,711 generics** across **422 drug classes**
- Medicines are distributed across **113 dosage forms**, with **tablet** being the dominant form in the dataset
- The vast majority of medicines are **allopathic**, with only a small proportion classified as herbal

### Manufacturer Landscape
- Most manufacturers have **small portfolios (1–10 medicines)**, indicating a highly fragmented producer landscape
- A relatively small number of manufacturers produce **large portfolios of medicines**, dominating overall market volume
- Manufacturer portfolios vary in **therapeutic diversity**, with some companies covering a wide range of drug classes while others specialise in only a few

### Therapeutic Coverage
- Drug classes differ significantly in the number of generics they contain, with some therapeutic areas having **many competing generics** while others remain relatively sparse
- Each generic in the dataset maps to **at most one indication**, which is a limitation of the source data rather than a reflection of real-world pharmaceutical usage

### Generic Competition
- The number of **brands per generic** varies widely, indicating different levels of **market competition**
- Some generics have **many competing brands**, suggesting highly competitive markets, while others appear with **only one or a few branded medicines**
- Generics can be segmented by **competition level** based on the number of branded medicines available, revealing a mix of **monopolistic, low-competition and highly competitive markets**

### Packaging and Product Variants
- Many medicines are available in **multiple package size options**, indicating variation in dosing or consumer packaging formats
- **Unit-Priced** is the most common container type (13,496 records), representing medicines priced per individual unit rather than by container

### Pricing Patterns
- **Pack prices** range from **10.20 to 278,400.00**, with an average of **840.73**
- **Unit prices** reach up to **8,976.66**, with an average of **69.79**
- Medicines can be segmented into **Low, Medium, High, and Premium price ranges**, with the majority falling into the lower and medium pricing tiers
- Pricing levels vary across **drug classes and dosage forms**, suggesting differences in therapeutic complexity and production cost

## ⚠️ Dataset Limitations

| Issue | Count | Decision |
|---|---|---|
| Medicines with no linked generic (NULL generic_id) | 214 | Documented — not fixable from source data |
| Medicines with no linked manufacturer (NULL manufacturer_id) | 147 | Documented — not fixable from source data |
| Unit-Priced container records with NULL unit price | 39 | Documented — accepted as-is |
| Generics with more than one indication | 0 | Dataset limitation — each generic maps to at most one indication |

## 📂⚡ File Path Configuration (Important)

This project uses a Python export script and PostgreSQL `COPY`, both of which require absolute file paths.

⚠️ **After cloning the repository, update file paths in two places:**

### In `01_ExportSourceData.py`

Update the `OUTPUT_FOLDER` variable:

```
OUTPUT_FOLDER = r'C:\Your\Path\To\PharmaMarket_EDA\source_data'
```

### In `02_LoadSourceData.sql`

Update the path in each `COPY` statement:

```
FROM 'C:/Your/Path/To/PharmaMarket_EDA/source_data/drug_class.csv'
```

> ⚠️ PostgreSQL `COPY` requires **forward slashes** in file paths, even on Windows.

## 🛠️ Technologies Used

- **PostgreSQL** — database engine for all EDA queries
- **SQL** — analytical queries including CTEs, window functions, subqueries and aggregations
- **Python 3 / pandas / pyodbc** — CSV export from SQL Server source database
- **VS Code with SQLTools** — preferred PostgreSQL client

## 🚀 Upcoming Projects

This EDA project is part of a series built on the PharmaMarketAnalytics database:

- 📊 **Data Visualization** — An interactive Tableau dashboard presenting key insights from the EDA, including drug distribution, manufacturer market share, and pricing trends.

## 📚 Data Source

The source CSV files were obtained from the Kaggle dataset:

[Assorted Medicine Dataset of Bangladesh](https://www.kaggle.com/datasets/ahmedshahriarsakib/assorted-medicine-dataset-of-bangladesh)

This dataset is used for educational purposes and to demonstrate EDA workflows.

## 👩‍💻 About Me

Hi! I'm [Gabriela Yordanova](https://www.linkedin.com/in/gabriela-yordanova-837ba2124/). Check out my full portfolio 🗂️ [here](https://gabrielay0rdanova.github.io/).

Having spent years working in pharmacy, I find this dataset genuinely interesting — 
the patterns here reflect a real market I understand well. This project is the analytical 
payoff of the pipeline: clean data, meaningful questions, and SQL to answer them.

*This project is part of my portfolio showcasing data analytics and EDA skills.*

## 🛡️ License

This project is licensed under the [MIT License](LICENSE.txt) and is available for educational and portfolio purposes.