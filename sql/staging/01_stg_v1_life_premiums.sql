-- Staging table for KNF table V.1 (life insurance, gross written premium by class)
-- Raw data copied 1:1 from the source file, before any transformation.
-- Total row is kept as a control row with class_number = NULL.

DROP TABLE IF EXISTS stg_v1_life_premiums;

CREATE TABLE stg_v1_life_premiums (
    report_year INT,
    class_number INT,
    number_of_contracts INT,
    gross_written_premium NUMERIC(15,2)
);

-- Source: V_Sprawozdanie_statystyczne_2020.xlsx, sheet Tabl.V.1
INSERT INTO stg_v1_life_premiums (report_year, class_number, number_of_contracts, gross_written_premium)
VALUES
    (2020, NULL, 11275535, 12202892),
    (2020, 1, 9465254, 4506422),
    (2020, 2, 82184, 109829),
    (2020, 3, 1681615, 5034637),
    (2020, 4, 46482, 142909),
    (2020, 5, 17861565, 2409094);