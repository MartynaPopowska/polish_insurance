Data model (star schema)
Grain
One row in a fact table = one combination of year + insurance segment (e.g. "2022, Life - Class 3"). Source data from KNF is annual, so the model does not go below the year level.

Design notes
DimYear is simplified (no daily calendar) because source data is annual; GUS inflation data is aggregated to yearly before joining.
Premiums and claims are kept as two separate fact tables (not one merged table with a "type" column) so loss ratio = simple join, not a pivot.
Tables
DimYear
Column	Type	Notes
YearKey	int (PK)	e.g. 2022
Year	int	same value as YearKey, kept for clarity in reports
DimInsuranceSegment
Column	Type	Notes
SegmentKey	int (PK)	surrogate key, not tied to KNF's own numbering
Division	text	"Life" or "Non-Life"
ClassNumber	int	1-5 for Life, 1-18 for Non-Life
ClassName	text	descriptive name of the class - to be filled in Stage 3 from KNF table V.1/V.7 row labels

Division and ClassNumber are separate columns so reports can filter/group by either independently.

FactPremiums
Column	Type	Notes
YearKey	int (FK -> DimYear)	
SegmentKey	int (FK -> DimInsuranceSegment)	
GrossWrittenPremium	decimal	in thousand PLN, matches KNF's unit
SourceTable	text	e.g. "V.1", "V.7" - which KNF table this row came from

Primary key: (YearKey, SegmentKey)

FactClaims
Column	Type	Notes
YearKey	int (FK -> DimYear)	
SegmentKey	int (FK -> DimInsuranceSegment)	
GrossClaimsPaid	decimal	in thousand PLN
SourceTable	text	e.g. "V.2"

Primary key: (YearKey, SegmentKey)

Diagram

DimYear (YearKey, Year)
connects to -> FactPremiums, FactClaims (via YearKey)

DimInsuranceSegment (SegmentKey, Division, ClassNumber, ClassName)
connects to -> FactPremiums, FactClaims (via SegmentKey)

FactPremiums (YearKey, SegmentKey, GrossWrittenPremium, SourceTable)

FactClaims (YearKey, SegmentKey, GrossClaimsPaid, SourceTable)

Joining premiums and claims
Use a LEFT JOIN from FactPremiums to FactClaims on (YearKey, SegmentKey), not an INNER JOIN, so missing claims data stays visible as NULL instead of silently dropping the row.

Known open item
The non-life claims-by-class table (equivalent of V.2 for life insurance) has not been located/confirmed yet - to be resolved in Stage 3.