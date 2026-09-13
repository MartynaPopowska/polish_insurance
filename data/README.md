# Data sources

## KNF - Annual Insurance Market Bulletin (2020-2025)

Source: KNF website, section "Biuletyn roczny. Rynek ubezpieczen [YEAR]"
(one file published per year, separately for each year).

Files used (for each year 2020-2025):
- `III_raporty_finansowe_[YEAR].xlsx` - balance sheet data for insurance companies
- `IV_wskazniki_efektywnosci_[YEAR].xlsx` - profitability and loss ratio indicators
- `V_sprawozdanie_statystyczne_[YEAR].xlsx` - premiums and claims by insurance class

### Tables actually used in this project

| Table | What it contains | Used for |
|---|---|---|
| V.1 | Gross written premium - life insurance, Class 1-5 | source for FactPremiums (life segment) |
| V.2 | Gross claims paid - life insurance, Class 1-5 | source for FactClaims (life segment) |
| V.7 | Gross written premium - non-life insurance, Class 1-18 | source for FactPremiums (non-life segment) |
| IV.8 (2020-2023) / IV.3 (2024-2025) | Loss ratio by class, calculated by KNF | NOT used as a data source - used only to check our own loss ratio calculation (claims from V.2 / premium from V.1) |

### IMPORTANT PITFALL: table numbering changed in 2024

KNF restructured files III and IV starting with the 2024 report:
- file III: 49 tables (2020-2023) -> 14 tables (2024-2025)
- file IV: 10 tables (2020-2023) -> 5 tables (2024-2025)

The same data can sit under a different table number depending on the
year (example: loss ratio by life class is Tabl.IV.8 in 2020-2023, but
Tabl.IV.3 in 2024-2025). When loading data from the IV files, the table
number cannot be assumed fixed - it has to be mapped by table title,
separately for the 2020-2023 period and the 2024-2025 period.

Part V (premiums/claims by class) does NOT have this problem - the
structure (Class 1-5 for life, Class 1-18 for non-life) is identical
across all years 2020-2025.

## EIOPA (EU benchmark) - optional

File: `SA_Premiums_Claims_Expenses.xlsx`, sheet "Premiums (Raw data)"
(long/tidy format: country / year / business type / value, 2016-2025,
Life vs Non-Life). Poland is one of 30 countries in the dataset. This
will be used to compare Poland against the EU average / other
countries - only at Life/Non-Life level, no class-level breakdown.

## GUS - inflation (context only, not for causal claims)

File: monthly CPI for Poland. Used only as macroeconomic background -
to show whether premium growth is real or mostly nominal/inflation-
driven. No cause-and-effect conclusions are drawn from this.