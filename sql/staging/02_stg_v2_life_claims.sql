-- Staging table for KNF table V.2 (life insurance) - number of payments and gross claims paid by class
-- Raw data copied 1:1 from the source, before any transformation.
-- Total row is kept as a control row with class_number = NULL.
-- V.2 has no individual/group split; the only split is periodical vs single,
-- so total claims paid = periodical + single (both columns needed).
-- The "of which sickness insurance" row is NOT loaded: it is a subset of Class 5.

DROP TABLE IF EXISTS stg_v2_life_claims;

CREATE TABLE stg_v2_life_claims (
    report_year INT,
    class_number INT,
    payments_count_periodical INT,
    payments_count_single INT,
    claims_paid_periodical NUMERIC(15,6),
    claims_paid_single NUMERIC(15,6)
);

-- Data load: data/processed/v2_life_claims_2020_2025.csv (not in repo, see data/README.md)
-- imported via pgAdmin Import/Export: format CSV, header ON, delimiter ';'
-- Expected result: 36 rows (6 years x Total + Classes 1-5)