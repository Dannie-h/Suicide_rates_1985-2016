CREATE TABLE suicide_rates (
	country VARCHAR(150),
	year INTEGER,
	sex VARCHAR(50),
	age_group VARCHAR(100),
	suicides_no BIGINT,
	population BIGINT,
	suicides_per_100k NUMERIC,
	hdi_for_year NUMERIC,
	gdp_for_year NUMERIC,
	generation VARCHAR(100)
	);

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

--Data exploration
-- 1. How many suicides happened from 1985 to 2016?

SELECT SUM(suicides_no) AS total_suicides
	FROM suicide_rates;
	
-- 2. How many suicides/ gender?

SELECT sex, 
	SUM(suicides_no) AS total_suicides_gender
FROM suicide_rates
GROUP BY sex
ORDER BY total_suicides_gender DESC;

-- 3. Total suicides by age group

SELECT age_group, 
	SUM(suicides_no) AS total_suicides_age 
FROM suicide_rates
GROUP BY age_group
ORDER BY total_suicides_age DESC;

-- 4. Total suicides by gender and age group

SELECT sex, age_group, 
	SUM(suicides_no) AS total_suicides 
FROM suicide_rates
GROUP BY sex, age_group
ORDER BY total_suicides DESC;

-- 5. Top 10 countries by suicides number

SELECT country, 
	SUM(suicides_no) AS total_suicides_country 
FROM countries
INNER JOIN suicide_rates
	ON countries.country_id = suicide_rates.country_id
GROUP BY country
ORDER BY total_suicides_country DESC
LIMIT 10;

-- 6.What country/ies had the fewest suicides?	
	
SELECT c.country, 
	SUM(s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN countries c
	ON s.country_id = c.country_id
GROUP BY c.country
HAVING SUM(s.suicides_no) = (
							SELECT MIN(total_suicide) 
							 FROM (
								SELECT SUM(suicides_no) AS total_suicide
								FROM suicide_rates
								GROUP BY country_id
							 ) AS suicide_totals
							);
							
-- 7.On average, how many suicides/100k pop happened during this period?

SELECT ROUND(AVG(suicides_per_100k),2) AS avg_suicides_per_100k 
FROM suicide_rates;

-- 8.On average, how many suicides/100k pop happened during this period for each gender?

SELECT sex, 
	ROUND(AVG(suicides_per_100k),2) AS avg_suicides_per_100k 
FROM suicide_rates
GROUP BY sex
ORDER BY avg_suicides_per_100k DESC;

-- 	9.On average, which countries had the highest number of suicides/100k pop?

SELECT c.country, 
		ROUND(AVG(s.suicides_per_100k),2) AS avg_suicides_per_100k
FROM suicide_rates s
INNER JOIN countries c
		ON s.country_id = c.country_id
GROUP BY c.country
ORDER BY avg_suicides_per_100k DESC
LIMIT 10;

-- 10.Which years had the greatest number of suicides? top 10
SELECT y.year, 
		SUM(s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN years y
		ON s.year_id = y.year_id
GROUP BY y.year
ORDER BY total_suicides DESC
LIMIT 10;

-- Which had the fewest?

SELECT y.year, 
		SUM(s.suicides_no) AS min_total_suicides 
FROM suicide_rates s
INNER JOIN years y
		ON s.year_id = y.year_id
GROUP BY y.year
HAVING SUM(s.suicides_no) = (
							SELECT MIN(suicides) 
							FROM (
								SELECT SUM (suicides_no) AS suicides 
								FROM suicide_rates
							GROUP BY year_id
							) AS suicides_total
							); 

-- which country in what year had the greatest number of suicides?

SELECT c.country, 
		y.year, 
		SUM(s.suicides_no) AS total_suicides 
FROM countries c
INNER JOIN suicide_rates s
		ON c.country_id =  s.country_id
INNER JOIN years y
		ON s.year_id = y.year_id
GROUP BY c.country, y.year
ORDER BY total_suicides DESC
LIMIT 1;

SELECT c.country, 
		y.year, 
		SUM(s.suicides_no) AS total_suicides 
FROM countries c
INNER JOIN suicide_rates s
		ON c.country_id =  s.country_id
INNER JOIN years y
		ON s.year_id = y.year_id
GROUP BY c.country, y.year
HAVING SUM(s.suicides_no) = (
							SELECT MAX(suicides)
							FROM (
								SELECT SUM(suicides_no) AS suicides
								FROM suicide_rates
								GROUP BY country_id, year_id
							) AS suicide_total
							);


--Men from which country had the highest number of suicides?
SELECT s.sex, c.country, SUM (s.suicides_no) AS total_suicides FROM suicide_rates s
INNER JOIN countries c
ON s.country_id = c.country_id
WHERE s.sex = 'male'
GROUP BY s.sex, c.country, s.age_group
ORDER BY total_suicides DESC
LIMIT 1;


--Women from which country had the highest number of suicides?
SELECT s.sex, c.country, SUM (s.suicides_no) AS total_suicides FROM suicide_rates s
INNER JOIN countries c
ON s.country_id = c.country_id
WHERE s.sex = 'female'
GROUP BY s.sex, c.country, s.age_group
ORDER BY total_suicides DESC
LIMIT 1;


/*When it comes to men who committed suicide, what was the age group and country for those who 
comitted the highest number of suicides? */

SELECT s.sex, c.country, s.age_group, SUM (s.suicides_no) AS total_suicides FROM suicide_rates s
INNER JOIN countries c
ON s.country_id = c.country_id
WHERE s.sex = 'male'
GROUP BY s.sex, c.country, s.age_group
ORDER BY total_suicides DESC
LIMIT 1;

/*When it comes to women who committed suicide, what was the age group and country for those who 
comitted the highest number of suicides? */

SELECT s.sex, c.country, s.age_group, SUM (s.suicides_no) AS total_suicides FROM suicide_rates s
INNER JOIN countries c
ON s.country_id = c.country_id
WHERE s.sex = 'female'
GROUP BY s.sex, c.country, s.age_group
ORDER BY total_suicides DESC
LIMIT 1;

----what gender from what age group from which country in what year

SELECT s.sex, c.country, s.age_group, y.year, SUM (s.suicides_no) AS total_suicides FROM suicide_rates s
INNER JOIN countries c
ON s.country_id = c.country_id
INNER JOIN years y
ON s.year_id = y.year_id
GROUP BY s.sex, c.country, s.age_group, y.year
ORDER BY total_suicides DESC
LIMIT 1;

/*When it comes to women who committed suicide, what was the year, country and age group  for those who 
comitted the highest number of suicides? */ 

SELECT s.sex, y.year, c.country, s.age_group,  SUM (s.suicides_no) AS total_suicides FROM suicide_rates s
INNER JOIN countries c
ON s.country_id = c.country_id
INNER JOIN years y
ON s.year_id = y.year_id
WHERE s.sex = 'female'
GROUP BY s.sex, y.year, c.country, s.age_group 
ORDER BY total_suicides DESC
LIMIT 1;



