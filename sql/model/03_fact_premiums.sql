-- Fact table: gross written premium by year and insurance segment.
-- Life (Classes 1-5) from KNF V.1: individual + group business.
-- Non-Life (Classes 1-18) from KNF V.8: Poland + all forms of activity abroad.
-- Scope is the same for both: domestic insurers, Poland + abroad,
-- excluding reinsurance accepted. Total rows are not loaded (sums are calculated).

DROP TABLE IF EXISTS fact_premiums;

CREATE TABLE fact_premiums (
    year_key INT REFERENCES dim_year(year_key),
    segment_key INT REFERENCES dim_insurance_segment(segment_key),
    gross_written_premium NUMERIC(15,6),
    source_table VARCHAR(10),
    PRIMARY KEY (year_key, segment_key)
);

INSERT INTO fact_premiums (year_key, segment_key, gross_written_premium, source_table)
SELECT 
	s.report_year as year_key,
	d.segment_key,
	s.premium_individual + s.premium_group as gross_written_premium,
	'V.1' AS source_table
FROM stg_v1_life_premiums s
JOIN dim_insurance_segment d
	ON d.division = 'Life'
	AND d.class_number = s.class_number
UNION ALL
SELECT 
	n.report_year as year_key,
	d.segment_key,
	n.premium_poland + n.premium_eea_establishment + n.premium_eea_services + n.premium_other_countries as gross_written_premium,
	'V.8' AS source_table
FROM stg_v8_nonlife as n
JOIN dim_insurance_segment d
	ON d.division = 'Non-Life'
	AND d.class_number = n.class_number
WHERE n.row_type = 'class';

SELECT COUNT(*) FROM fact_premiums;