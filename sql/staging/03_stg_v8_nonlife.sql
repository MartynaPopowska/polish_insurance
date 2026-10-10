
-- Staging table for KNF table V.8 (non-life insurance) - gross written premium and
-- gross claims paid by class, split by where the business is written (Poland / abroad).
-- Raw data copied 1:1 from the source, before any transformation.
-- row_type: 'total' (KNF Total row), 'class' (Classes 1-18),
--           'reinsurance_accepted' (no class breakdown; part of KNF Total).
-- Total = Classes 1-18 + reinsurance accepted.
-- Scope note: V.1/V.2 (life) cover Poland + abroad and exclude reinsurance accepted,
-- so for comparable life vs non-life figures use: all 4 regions, row_type = 'class'.

DROP TABLE IF EXISTS stg_v8_nonlife;

CREATE TABLE stg_v8_nonlife (
    report_year INT,
    row_type VARCHAR(30),
    class_number INT,
    premium_poland NUMERIC(15,6),
    premium_eea_establishment NUMERIC(15,6),
    premium_eea_services NUMERIC(15,6),
    premium_other_countries NUMERIC(15,6),
    claims_paid_poland NUMERIC(15,6),
    claims_paid_eea_establishment NUMERIC(15,6),
    claims_paid_eea_services NUMERIC(15,6),
    claims_paid_other_countries NUMERIC(15,6)
);

-- Data load: data/processed/v8_nonlife_2020_2025.csv (not in repo, see data/README.md)
-- imported via pgAdmin Import/Export: format CSV, header ON, delimiter ';'
-- Expected result: 120 rows (6 years x Total + Classes 1-18 + reinsurance accepted)