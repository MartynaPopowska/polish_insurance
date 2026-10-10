-- Insurance segment dimension: one row per class within each division.
-- Source: Act of 11 September 2015 on insurance and reinsurance activity
-- (Ustawa o dzialalnosci ubezpieczeniowej i reasekuracyjnej), annex:
-- classes of insurance by division. English names follow Solvency II class names.
-- KNF tables use class numbers only, so names are added here as reference data.
-- class_number alone is NOT unique (e.g. Class 1 exists in Life and Non-Life);
-- the pair (division, class_number) is unique, so a surrogate key is used.

DROP TABLE IF EXISTS dim_insurance_segment;

CREATE TABLE dim_insurance_segment(
	segment_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	division VARCHAR(40),
	class_number INT,
	class_name VARCHAR(40)
);

INSERT INTO dim_insurance_segment (division, class_number, class_name)
VALUES
    ('Life', 1, 'Life insurance'),
    ('Life', 2, 'Marriage and birth assurance'),
    ('Life', 3, 'Unit-linked life insurance'),
    ('Life', 4, 'Annuity insurance'),
    ('Life', 5, 'Accident and sickness (supplementary)'),
    ('Non-Life', 1, 'Accident'),
    ('Non-Life', 2, 'Sickness'),
    ('Non-Life', 3, 'Land vehicles (motor own damage)'),
    ('Non-Life', 4, 'Railway rolling stock'),
    ('Non-Life', 5, 'Aircraft'),
    ('Non-Life', 6, 'Ships'),
    ('Non-Life', 7, 'Goods in transit'),
    ('Non-Life', 8, 'Fire and natural forces'),
    ('Non-Life', 9, 'Other damage to property'),
    ('Non-Life', 10, 'Motor vehicle liability (MTPL)'),
    ('Non-Life', 11, 'Aircraft liability'),
    ('Non-Life', 12, 'Liability for ships'),
    ('Non-Life', 13, 'General liability'),
    ('Non-Life', 14, 'Credit'),
    ('Non-Life', 15, 'Suretyship'),
    ('Non-Life', 16, 'Miscellaneous financial loss'),
    ('Non-Life', 17, 'Legal expenses'),
    ('Non-Life', 18, 'Assistance');

SELECT * FROM dim_insurance_segment;