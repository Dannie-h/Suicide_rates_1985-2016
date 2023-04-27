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
SELECT * FROM age_groups

CREATE TABLE gender (
	gender_id SERIAL PRIMARY KEY,
	gender VARCHAR(50)
	);
	
INSERT INTO gender (gender)
		SELECT DISTINCT sex
		FROM suicide_rates;
		
SELECT * FROM gender;

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

ALTER TABLE suicide_rates
ADD COLUMN age_group_id INTEGER REFERENCES age_groups(age_group_id);

UPDATE suicide_rates
SET age_group_id = age_groups.age_group_id
FROM age_groups
WHERE suicide_rates.age_group = age_groups.age_group;

ALTER TABLE suicide_rates
ADD COLUMN gender_id INTEGER REFERENCES gender(gender_id);

UPDATE suicide_rates
SET gender_id = gender.gender_id
FROM gender
WHERE suicide_rates.sex = gender.gender;

SELECT * FROM suicide_rates;

ALTER TABLE suicide_rates
DROP COLUMN country;

ALTER TABLE suicide_rates
DROP COLUMN year;

ALTER TABLE suicide_rates
DROP COLUMN age_group;

ALTER TABLE suicide_rates
DROP COLUMN generation;

ALTER TABLE suicide_rates
DROP COLUMN sex;

ALTER TABLE suicide_rates
DROP COLUMN hdi_for_year,
DROP COLUMN gdp_for_year,
DROP COLUMN gdp_per_capita;


SELECT * FROM suicide_rates;

--Data exploration
-- 1. How many suicides happened from 1985 to 2016?

SELECT SUM(suicides_no) AS total_suicides
	FROM suicide_rates;
	
-- 2. How many suicides/ gender? 

SELECT g.gender, 
	SUM(s.suicides_no) AS total_suicides_gender
FROM suicide_rates s
INNER JOIN gender g
ON s.gender_id = g.gender_id
GROUP BY g.gender
ORDER BY total_suicides_gender DESC;

-- 3. Total suicides by age group

SELECT a.age_group, 
	SUM(s.suicides_no) AS total_suicides_age 
FROM suicide_rates s
INNER JOIN age_groups a
		ON s.age_group_id = a.age_group_id
GROUP BY a.age_group
ORDER BY total_suicides_age DESC;

-- 4. Total suicides by gender and age group

SELECT g.gender, 
	   a.age_group, 
	   SUM(s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN gender g
		ON g.gender_id = s.gender_id
INNER JOIN age_groups a
		ON a.age_group_id = s.age_group_id
GROUP BY g.gender, a.age_group
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

SELECT g.gender, 
	ROUND(AVG(s.suicides_per_100k),2) AS avg_suicides_per_100k 
FROM suicide_rates s
INNER JOIN gender g
		ON g.gender_id = s.gender_id
GROUP BY g.gender
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

-- 11.Which had the fewest?

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

-- 12. which country in what year had the greatest number of suicides?

SELECT c.country, 
		y.year, 
		SUM(s.suicides_no) AS total_suicides 
FROM countries c
INNER JOIN suicide_rates s
		ON c.country_id =  s.country_id
INNER JOIN years y
		ON s.year_id = y.year_id
GROUP BY c.country, 
		 y.year
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
GROUP BY c.country, 
		 y.year
HAVING SUM(s.suicides_no) = (
							SELECT MAX(suicides)
							FROM (
								SELECT SUM(suicides_no) AS suicides
								FROM suicide_rates
								GROUP BY country_id, year_id
							) AS suicide_total
							);
							


-- 13.Men from which country had the highest number of suicides?
SELECT g.gender,
	   c.country, 
	   SUM (s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN countries c
		ON s.country_id = c.country_id
INNER JOIN gender g
		ON s.gender_id = g.gender_id
WHERE g.gender = 'male'
GROUP BY g.gender, 
		 c.country
ORDER BY total_suicides DESC
LIMIT 1;



-- 14.Women from which country had the highest number of suicides?
SELECT g.gender,
	   c.country, 
	   SUM (s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN countries c
		ON s.country_id = c.country_id
INNER JOIN gender g
		ON s.gender_id = g.gender_id
WHERE g.gender = 'female'
GROUP BY g.gender, 
		 c.country
ORDER BY total_suicides DESC
LIMIT 1;


/* 15.When it comes to men who committed suicide, what was the age group and country for those who 
comitted the highest number of suicides? */

SELECT g.gender, 
	   c.country, 
	   a.age_group, 
	   SUM (s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN countries c
		ON s.country_id = c.country_id
INNER JOIN gender g 
	ON s.gender_id = g.gender_id
INNER JOIN age_groups a
	ON a.age_group_id = s.age_group_id
WHERE g.gender = 'male'
GROUP BY g.gender, 
		 c.country, 
		 a.age_group
ORDER BY total_suicides DESC
LIMIT 1;

/* 16.When it comes to women who committed suicide, what was the age group and country for those who 
comitted the highest number of suicides? */

SELECT g.gender, 
	   c.country, 
	   a.age_group, 
	   SUM (s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN countries c
		ON s.country_id = c.country_id
INNER JOIN gender g 
	ON s.gender_id = g.gender_id
INNER JOIN age_groups a
	ON a.age_group_id = s.age_group_id
WHERE g.gender = 'female'
GROUP BY g.gender, 
		 c.country, 
		 a.age_group
ORDER BY total_suicides DESC
LIMIT 1;

-- 17.What gender from what age group from which country in what year comitted the highest number of suicides?

SELECT g.gender, 
	   y.year, 
	   c.country, 
	   a.age_group,  
	   SUM (s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN countries c
		ON s.country_id = c.country_id
INNER JOIN years y
		ON s.year_id = y.year_id
INNER JOIN gender g
		ON g.gender_id = s.gender_id
INNER JOIN age_groups a
		ON a.age_group_id = s.age_group_id
GROUP BY g.gender,
		 y.year, 
		 c.country, 
		 a.age_group 
ORDER BY total_suicides DESC
LIMIT 1;

/* 18.When it comes to women who committed suicide, what was the year, country and age group  for those who 
comitted the highest number of suicides? */ 

SELECT g.gender, 
	   y.year, 
	   c.country, 
	   a.age_group,  
	   SUM (s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN countries c
		ON s.country_id = c.country_id
INNER JOIN years y
		ON s.year_id = y.year_id
INNER JOIN gender g
		ON g.gender_id = s.gender_id
INNER JOIN age_groups a
		ON a.age_group_id = s.age_group_id
WHERE g.gender = 'female'
GROUP BY g.gender,
		 y.year, 
		 c.country, 
		 a.age_group 
ORDER BY total_suicides DESC
LIMIT 1;

	