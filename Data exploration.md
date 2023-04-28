#### 1. How many suicides happened from 1985 to 2016?
 ``` SQL
 SELECT SUM(suicides_no) AS total_suicides
	FROM suicide_rates; 
  ```
  ![totalsuicides](Queries_results/totalsuicides.jpg)
  
#### 2. How many suicides/ gender?
  
  ```SQL
  SELECT g.gender, 
	SUM(s.suicides_no) AS total_suicides
FROM suicide_rates s
INNER JOIN gender g
	ON s.gender_id = g.gender_id
GROUP BY g.gender
ORDER BY total_suicides DESC;
```

![totalgender](Queries_results/totalgender.jpg)
 
#### 3. How many suicides by age group?
 
```SQL
SELECT  a.age_group, 
	SUM(s.suicides_no) AS total_suicides_age 
FROM suicide_rates s
INNER JOIN age_groups a
	ON s.age_group_id = a.age_group_id
GROUP BY a.age_group
ORDER BY total_suicides_age DESC;
```
![totalsuicidesage](Queries_results/totalsuicidesage.jpg)

#### 4. How many suicides by gender and age group?

 ```SQL
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
```
![totalgenderage](Queries_results/totalgenderage.jpg)

#### 5. Top 10 countries by suicides number
  
```SQL
SELECT country, 
	SUM(suicides_no) AS total_suicides_country 
FROM countries
INNER JOIN suicide_rates
	ON countries.country_id = suicide_rates.country_id
GROUP BY country
ORDER BY total_suicides_country DESC
LIMIT 10;
```
![top10countries](Queries_results/top10countries.jpg)

#### 6. Which country/ies had the fewest suicides?
```SQL
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
```
![fewestcountry](Queries_results/fewestcountry.jpg)

#### 7. On average, how many suicides/100k pop happened during this period?

```SQL
SELECT ROUND(AVG(suicides_per_100k),2) AS avg_suicides_per_100k 
FROM suicide_rates;
```
![totalavg100k](Queries_results/totalavg100k.jpg)

#### 8. On average, how many suicides/100k pop happened during this period for each gender?

```SQL
SELECT g.gender, 
	ROUND(AVG(s.suicides_per_100k),2) AS avg_suicides_per_100k 
FROM suicide_rates s
INNER JOIN gender g
	ON g.gender_id = s.gender_id
GROUP BY g.gender
ORDER BY avg_suicides_per_100k DESC;
```
![avg100kgender](Queries_results/avg100kgender.jpg)

#### 9. On average, which countries had the highest number of suicides/100k pop?

```SQL
SELECT c.country, 
	ROUND(AVG(s.suicides_per_100k),2) AS avg_suicides_per_100k
FROM suicide_rates s
INNER JOIN countries c
	ON s.country_id = c.country_id
GROUP BY c.country
ORDER BY avg_suicides_per_100k DESC
LIMIT 10;
```
![avg100kcountry](Queries_results/avg100kcountry.jpg)

#### 10. Which years had the greatest number of suicides? (top 10)

```SQL
SELECT y.year, 
	SUM(s.suicides_no) AS total_suicides 
FROM suicide_rates s
INNER JOIN years y
	ON s.year_id = y.year_id
GROUP BY y.year
ORDER BY total_suicides DESC
LIMIT 10;
```

![top10years](Queries_results/top10years.jpg)
			    
#### 11. Which year had the fewest suicides?

```SQL
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
					ROM suicide_rates
					GROUP BY year_id
					) AS suicides_total
				);
```
![lowyear](Queries_results/lowyear.jpg)

#### 12. Which country in what year had the greatest number of suicides?

```SQL
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
```
![topcountryyear](Queries_results/topcountryyear.jpg)

 
 #### 13. Who (gender, nationality, age) comitted the highest number of suicides and when?
 ```SQL
SELECT  g.gender, 
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
```
![menagecountryyear](Queries_results/menagecountryyear.jpg)

#### 14. When it comes to women who committed suicide, what was the year, country and age group  for those who comitted the highest number of suicides?
```SQL
SELECT  g.gender, 
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
```
![womenagecountryyear](Queries_results/womenagecountryyear.jpg)
