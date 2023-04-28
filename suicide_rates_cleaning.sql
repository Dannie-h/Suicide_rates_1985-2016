CREATE TABLE suicide_rates (
	country VARCHAR(150),
	year INTEGER,
	sex VARCHAR(50),
	age_group VARCHAR (150),
	suicides_no INTEGER,
	population BIGINT,
	suicides_per_100k NUMERIC,
	country_year VARCHAR(150),
	hdi_for_year NUMERIC,
	gdp_for_year NUMERIC,
	gdp_per_capita NUMERIC,
	generation VARCHAR(100)
	);
	
SELECT * FROM suicide_rates;
-- Data Cleaning
-- Eliminating NULL values

SELECT *
FROM suicide_rates
WHERE COALESCE(year, -1) = -1;

SELECT *
FROM suicide_rates
WHERE COALESCE(suicides_no, -1) = -1;

SELECT *
FROM suicide_rates
WHERE COALESCE(population, -1) = -1;

SELECT *
FROM suicide_rates
WHERE COALESCE(suicides_per_100k, -1) = -1;

SELECT * FROM suicide_rates
WHERE COALESCE(hdi_for_year, -1) = -1;

SELECT * FROM suicide_rates
WHERE COALESCE(hdi_for_year, -1) = -1;
UPDATE suicide_rates
SET hdi_for_year = 0
WHERE hdi_for_year IS NULL;

SELECT *
FROM suicide_rates
WHERE COALESCE(gdp_for_year, -1) = -1;

SELECT *
FROM suicide_rates
WHERE COALESCE(gdp_per_capita, -1) = -1;

SELECT * FROM suicide_rates
WHERE COALESCE(country, '') = '';

SELECT * FROM suicide_rates
WHERE COALESCE(sex, '') = '';

-- Trimming the age_group coulmn
UPDATE suicide_rates
SET age_group = REPLACE(age_group, ' years','');

UPDATE suicide_rates
SET age_group = TRIM(age_group);

-- Removing country_year column
ALTER TABLE suicide_rates
DROP COLUMN country_year;

--Create a relational database
ALTER TABLE suicide_rates
ADD COLUMN suicide_id SERIAL PRIMARY KEY;

SELECT * FROM suicide_rates;

CREATE TABLE countries (
	country_id SERIAL PRIMARY KEY,
	country VARCHAR(100) );
	
INSERT INTO countries (country)
		SELECT DISTINCT(country)
	FROM suicide_rates
	WHERE country = country;
	
SELECT * FROM countries;

ALTER TABLE suicide_rates
ADD COLUMN country_id INTEGER REFERENCES countries(country_id);

UPDATE suicide_rates
SET country_id = countries.country_id
FROM countries
WHERE suicide_rates.country = countries.country;

SELECT * FROM suicide_rates;

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
ADD COLUMN year_id INTEGER REFERENCES years(year_id);

UPDATE suicide_rates
SET year_id = years.year_id
FROM years
WHERE suicide_rates.year = years.year;

CREATE TABLE age_groups (
	age_group_id SERIAL PRIMARY KEY,
	age_group VARCHAR(50)
	);

INSERT INTO age_groups (age_group)
		SELECT DISTINCT age_group
		FROM suicide_rates
		WHERE age_group = age_group 
		ORDER BY age_group
		;
SELECT * FROM age_groups;

ALTER TABLE suicide_rates
ADD COLUMN age_group_id INTEGER REFERENCES age_groups(age_group_id);

UPDATE suicide_rates
SET age_group_id = age_groups.age_group_id
FROM age_groups
WHERE suicide_rates.age_group = age_groups.age_group;

SELECT * FROM suicide_rates;

CREATE TABLE gender (
	gender_id SERIAL PRIMARY KEY,
	gender VARCHAR(50)
	);
	
INSERT INTO gender (gender)
		SELECT DISTINCT sex
		FROM suicide_rates;
		
SELECT * FROM gender;

ALTER TABLE suicide_rates
ADD COLUMN gender_id INTEGER REFERENCES gender(gender_id);

UPDATE suicide_rates
SET gender_id = gender.gender_id
FROM gender
WHERE suicide_rates.sex = gender.gender;

SELECT * FROM suicide_rates;

CREATE TABLE economic_indicators (
	country_id INTEGER REFERENCES countries(country_id),
	year_id INTEGER REFERENCES years(year_id),
	hdi NUMERIC,
	gdp NUMERIC,
	gdp_per_capita NUMERIC
);

INSERT INTO economic_indicators (country_id, year_id, hdi, gdp, gdp_per_capita)
SELECT c.country_id, y.year_id, s.hdi_for_year, s.gdp_for_year, s.gdp_per_capita
FROM suicide_rates s
JOIN countries c ON s.country_id = c.country_id
JOIN years y ON s.year_id = y.year_id;

SELECT * FROM economic_indicators
ORDER BY country_id;

SELECT * FROM suicide_rates;

ALTER TABLE suicide_rates
DROP COLUMN country,
DROP COLUMN year,
DROP COLUMN age_group,
DROP COLUMN generation,
DROP COLUMN sex,
DROP COLUMN hdi_for_year,
DROP COLUMN gdp_for_year,
DROP COLUMN gdp_per_capita;


SELECT * FROM suicide_rates;


	