SELECT * FROM suicide_rates;

-- Data Cleaning
-- Eliminating NULL values

UPDATE suicide_rates
SET hdi_for_year = 0
WHERE hdi_for_year IS NULL;

-- Trimming the age_group coulmn
UPDATE suicide_rates
SET age_group = REPLACE(age_group, ' years','');

UPDATE suicide_rates
SET age_group = TRIM(age_group);

-- Removing country_year column
ALTER TABLE suicide_rates
DROP COLUMN country_year;

SELECT * FROM suicide_rates;


