-- Fact table: gross claims paid by year and insurance segment.
-- Life (Classes 1-5) from KNF V.2: periodical + single claims paid.
-- Non-Life (Classes 1-18) from KNF V.8: claims paid in Poland + all forms of activity abroad.
-- Scope matches fact_premiums: domestic insurers, Poland + abroad,
-- excluding reinsurance accepted, so loss ratio = claims / premium compares like with like.
-- Total rows are not loaded (sums are calculated).
DROP TABLE IF EXISTS fact_claims;

CREATE TABLE fact_claims (
    year_key INT REFERENCES dim_year(year_key),
    segment_key INT REFERENCES dim_insurance_segment(segment_key),
    gross_claims_paid NUMERIC(15,6),
    source_table VARCHAR(10),
    PRIMARY KEY (year_key, segment_key)
);

INSERT INTO fact_claims (year_key, segment_key, gross_claims_paid, source_table)
SELECT 
	c.report_year as year_key,
	d.segment_key,
	c.claims_paid_periodical + c.claims_paid_single as gross_claims_paid,
	'V.2' AS source_table
FROM stg_v2_life_claims c
JOIN dim_insurance_segment d
	ON d.division = 'Life'
	AND d.class_number = c.class_number
UNION ALL
SELECT 
	n.report_year as year_key,
	d.segment_key,
	n.claims_paid_poland + n.claims_paid_eea_establishment + n.claims_paid_eea_services + n.claims_paid_other_countries as gross_claims_paid,
	'V.8' AS source_table
FROM stg_v8_nonlife as n
JOIN dim_insurance_segment d
	ON d.division = 'Non-Life'
	AND d.class_number = n.class_number
WHERE n.row_type = 'class';

SELECT *  FROM fact_claims
WHERE year_key =2020
AND seg;