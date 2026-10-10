# Data sources

## KNF - Annual Insurance Market Bulletin (2020-2025)

Source: KNF website, "Biuletyn roczny. Rynek ubezpieczen [YEAR]"
(one set of files per year):
[2020](https://www.knf.gov.pl/?articleId=74968&p_id=18) |
[2021](https://www.knf.gov.pl/?articleId=79449&p_id=18) |
[2022](https://www.knf.gov.pl/?articleId=83586&p_id=18) |
[2023](https://www.knf.gov.pl/?articleId=90351&p_id=18) |
[2024](https://www.knf.gov.pl/?articleId=94897&p_id=18) |
[2025](https://www.knf.gov.pl/dane_i_opracowania/dane_statystyczne?articleId=99470&p_id=18)

Files used (for each year):
- `III_raporty_finansowe_[YEAR].xlsx` - balance sheet data for insurance companies
- `IV_wskazniki_efektywnosci_[YEAR].xlsx` - profitability and loss ratio indicators
- `V_sprawozdanie_statystyczne_[YEAR].xlsx` - premiums and claims by insurance class

### Tables used in this project

| Table | What it contains | Used for |
|---|---|---|
| V.1 | Life insurance, Class 1-5: number of contracts and gross written premium, split into individual (col. B) and group (col. C) | `stg_v1_life_premiums` -> FactPremiums (life) |
| V.2 | Life insurance, Class 1-5: number of payments and gross claims paid, split into periodical (B, D) and single (C, E) | `stg_v2_life_claims` -> FactClaims (life) |
| V.8 | Non-life insurance, Class 1-18 + reinsurance accepted: gross written premium (B-E) and gross claims paid (F-I), split into Poland and 3 forms of activity abroad | `stg_v8_nonlife` -> FactPremiums, FactClaims (non-life) |
| IV.8 (2020-2023) / IV.3 (2024-2025) | Loss ratio by life class, calculated by KNF | Not a data source - only a cross-check of our own loss ratio. KNF's definition may differ slightly (see formulas in Tabl.IV.1), so agreement is expected to be approximate. |

### IMPORTANT PITFALL: table numbering changed in 2024

KNF restructured files III and IV starting with the 2024 report:
- file III: 49 tables (2020-2023) -> 14 tables (2024-2025)
- file IV: 10 tables (2020-2023) -> 5 tables (2024-2025)

The same data can sit under a different table number depending on the
year (e.g. loss ratio by life class is Tabl.IV.8 in 2020-2023, but
Tabl.IV.3 in 2024-2025). Tables must be mapped by title, not by number.

Part V does NOT have this problem - its structure (Class 1-5 for life,
Class 1-18 for non-life) is identical across 2020-2025.

### How the processed CSV files were built

Files in `data/processed/` are not in the repo. To rebuild them:
- copy values (not retyped, to keep full decimals) from Tabl.V.1 / Tabl.V.2
  of each year's file, 2020-2025,
- one row per year for Total (class_number left empty -> NULL) and
  Classes 1-5,
- skip the "of which sickness insurance" row (it is a subset of Class 5),
- column order as in the matching `CREATE TABLE` in `sql/staging/`,
- format: `;` as delimiter, `.` as decimal separator, no thousands separators.
- V.8: 20 rows per year in KNF order (Total, Classes 1-18, reinsurance accepted),
  with `row_type` = total / class / reinsurance_accepted. 120 data rows.
- Decimal commas were replaced with dots in Notepad, not in Excel - Excel converts
  values like `7.8` or `28.6` into dates.

Files: `v1_life_premiums_2020_2025.csv`, `v2_life_claims_2020_2025.csv`
(36 data rows each).

## EIOPA (EU benchmark) - optional

File: `SA_Premiums_Claims_Expenses.xlsx`, sheet "Premiums (Raw data)"
(long format: country / year / business type / value, 2016-2025,
Life vs Non-Life). Poland is one of 30 countries. Used to compare Poland
with other EU countries - only at Life/Non-Life level.

## GUS - inflation (context only, not for causal claims)

File: monthly CPI for Poland (GUS, "Miesieczne wskazniki cen towarow i uslug
konsumpcyjnych od 1982 roku"). Used only as background - to show whether
premium growth is real or mostly nominal. Monthly values will be
aggregated to yearly before use. No cause-and-effect conclusions.

## Notes on changes

- **V.1 individual vs group:** the first version of the staging table
  loaded only column B (individual business). Group business (column C,
  ~40% of life premium) was missing. The table was rebuilt with separate
  individual and group columns; verified that individual + group =
  periodical + single for all rows 2020-2025.
- **Non-life source V.7 -> V.8:** V.7 has premium by economic sector only (no claims),
  and its totals are ~5% lower than V.8. V.8 has both premium and claims paid by class,
  so premium and claims come from the same table with the same scope.
- **Scope definition:** V.1/V.2 cover domestic insurers' business in Poland + abroad,
  excluding reinsurance accepted (verified against V.3). For comparability, non-life
  figures use all regions from V.8 and Classes 1-18 only.

## Data quality notes

- Contract counts (V.1) are not additive across classes - one contract
  can cover several classes (e.g. Class 5 riders). Use premium for totals.
- Class 5 shows large jumps between 2023 and 2024 (individual contracts
  ~19.6M -> ~10.5M; single payments ~2.7M -> ~7.0M). Values are as reported
  by KNF; the change coincides with the 2024 report restructuring, but
  the cause is not confirmed.
- Some values in V.8 are negative (e.g. small foreign amounts) - kept as reported
  by KNF (corrections, e.g. returned premium or recoveries).