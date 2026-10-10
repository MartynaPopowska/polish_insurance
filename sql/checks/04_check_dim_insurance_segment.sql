-- Control check: dim_insurance_segment should have 5 Life classes and 18 Non-Life classes.
SELECT
	division,
	COUNT(*) AS number_of_classes

FROM dim_insurance_segment
GROUP BY division;

