-- Control check: for each year, sum of classes 1-5 should match KNF's Total row,
-- separately for individual and group premium.
-- Tiny differences (< 0.01 thousand PLN) in 2021-2025 individual premium come from
-- decimal truncation when the CSV was first exported from Excel.
-- Note: works for premium only, NOT for contract counts
-- (one contract can appear in several classes, e.g. Class 5 riders).

SELECT
	report_year,
    SUM(CASE WHEN class_number IS NOT NULL THEN premium_individual ELSE 0 END) AS sum_classes_individual,
	SUM(CASE WHEN class_number IS NULL THEN premium_individual ELSE 0 END) AS total_individual,
	SUM(CASE WHEN class_number IS NOT NULL THEN premium_group ELSE 0 END) AS sum_classes_group,
    SUM(CASE WHEN class_number IS NULL THEN premium_group ELSE 0 END) AS total_group
FROM stg_v1_life_premiums
GROUP BY report_year
ORDER BY report_year;
