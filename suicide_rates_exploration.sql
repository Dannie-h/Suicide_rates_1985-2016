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
							


-- 13.Who (gender, nationality, age) comitted the highest number of suicides and when?

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

/* 14.When it comes to women who committed suicide, what was the year, country and age group  for those who 
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