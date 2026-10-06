-- Control check: sum of classes 1-5 should match KNF's Total row
-- (small difference of 1-2 is expected due to KNF rounding to thousands PLN)
-- Note: works for premium only, NOT for number_of_contracts
-- (Class 5 contracts are mostly riders attached to other classes)

SELECT
    SUM(CASE WHEN class_number IS NOT NULL THEN gross_written_premium ELSE 0 END) AS sum_of_classes,
    SUM(CASE WHEN class_number IS NULL THEN gross_written_premium ELSE 0 END) AS total_from_knf
FROM stg_v1_life_premiums;