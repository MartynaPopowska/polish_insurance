-- Year dimension: one row per reporting year.
-- Simplified (year only, no daily calendar) because KNF source data is annual.
-- Years are taken from the staging data, so new years are added automatically
-- when the script is re-run after loading new data.

DROP TABLE IF EXISTS dim_year;

CREATE TABLE dim_year(
	year_key INT PRIMARY KEY,
	year INT
);

	
INSERT INTO dim_year (year_key, year)
SELECT DISTINCT report_year, report_year
FROM stg_v1_life_premiums;

SELECT * FROM dim_year;