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

--Data Normalization

CREATE TABLE countries (
country_id SERIAL PRIMARY KEY,
country VARCHAR(100) );

SELECT * FROM countries;

INSERT INTO countries (country)
SELECT DISTINCT(country)
FROM suicide_rates
WHERE country = country;


CREATE TABLE years (
year_id SERIAL PRIMARY KEY,
year INTEGER );

INSERT INTO years (year)
SELECT DISTINCT(year)
FROM suicide_rates
WHERE year = year
ORDER BY year;

SELECT * FROM years;

ALTER TABLE suicide_rates
ADD COLUMN suicide_id SERIAL PRIMARY KEY;

ALTER TABLE suicide_rates
ADD COLUMN country_id INTEGER REFERENCES countries(country_id);

UPDATE suicide_rates
SET country_id = countries.country_id
FROM countries
WHERE suicide_rates.country = countries.country

ALTER TABLE suicide_rates
ADD COLUMN year_id INTEGER REFERENCES years(year_id);

UPDATE suicide_rates
SET year_id = years.year_id
FROM years
WHERE suicide_rates.year = years.year;


SELECT * FROM suicide_rates

ALTER TABLE suicide_rates
DROP COLUMN country;

ALTER TABLE suicide_rates
DROP COLUMN year;



