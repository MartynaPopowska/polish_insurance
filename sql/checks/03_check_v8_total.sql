
-- Control check: for each year, Classes 1-18 + reinsurance accepted should match
-- KNF's Total row, for premium and claims paid in Poland.
SELECT 
	report_year,
	SUM(CASE WHEN row_type = 'class' THEN premium_poland ELSE 0 END) as sum_classes_premium,
	SUM(CASE WHEN row_type = 'reinsurance_accepted' THEN premium_poland ELSE 0 END) as reinsurance_premium,
	SUM(CASE WHEN row_type = 'total' THEN premium_poland ELSE 0 END) as total_premium,
	SUM(CASE WHEN row_type = 'class' THEN claims_paid_poland ELSE 0 END) as sum_classes_claims,
	SUM(CASE WHEN row_type = 'reinsurance_accepted' THEN claims_paid_poland ELSE 0 END) as reinsurance_claims,
	SUM(CASE WHEN row_type = 'total' THEN claims_paid_poland ELSE 0 END) as total_claims
FROM stg_v8_nonlife
GROUP BY report_year
ORDER BY report_year;
