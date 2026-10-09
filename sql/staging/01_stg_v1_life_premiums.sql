-- Staging table for KNF table V.1 (life insurance) - contracts and gross written premium by class
-- Raw data copied 1:1 from the source, before any transformation.
-- Total row is kept as a control row with class_number = NULL.
-- Individual and group business are stored in separate columns (source columns B and C);
-- full life market = individual + group.
-- Periodical/single columns (D, E) are not loaded: they split the same premium a different way.

DROP TABLE IF EXISTS stg_v1_life_premiums;

CREATE TABLE stg_v1_life_premiums (
    report_year INT,
    class_number INT,
    contracts_individual INT,
    contracts_group INT,
    premium_individual NUMERIC(15,6),
    premium_group NUMERIC(15,6)
);

-- Data load: data/processed/v1_life_premiums_2020_2025.csv (not in repo, see data/README.md)
-- imported via pgAdmin Import/Export: format CSV, header ON, delimiter ';'
-- Expected result: 36 rows (6 years x Total + Classes 1-5)