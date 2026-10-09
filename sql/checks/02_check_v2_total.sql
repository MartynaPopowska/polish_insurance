-- Control check: for each year, sum of classes 1-5 should match KNF's Total row,
-- separately for periodical and single claims paid.
-- Unlike contract counts in V.1, payment counts ARE additive here
-- (each payment belongs to exactly one class) - verified for 2020-2025.

SELECT
    report_year,
    SUM(CASE WHEN class_number IS NOT NULL THEN claims_paid_periodical ELSE 0 END) AS sum_classes_periodical,
    SUM(CASE WHEN class_number IS NULL THEN claims_paid_periodical ELSE 0 END) AS total_periodical,
    SUM(CASE WHEN class_number IS NOT NULL THEN claims_paid_single ELSE 0 END) AS sum_classes_single,
    SUM(CASE WHEN class_number IS NULL THEN claims_paid_single ELSE 0 END) AS total_single
FROM stg_v2_life_claims
GROUP BY report_year
ORDER BY report_year;