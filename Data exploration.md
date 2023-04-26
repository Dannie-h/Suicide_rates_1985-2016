#### 1. How many suicides happened from 1985 to 2016?
 ``` SQL
 SELECT SUM(suicides_no) AS total_suicides
	FROM suicide_rates; 
  ```
  ![totalsuicides](totalsuicides.jpg)
  
#### 2. How many suicides/ gender?
  
  ```SQL
  SELECT sex, 
	SUM(suicides_no) AS total_suicides_gender
FROM suicide_rates
GROUP BY sex
ORDER BY total_suicides_gender DESC;
```

![totalsuicidesgender](totalsuicidesgender.jpg)
 
#### 3. How many suicides by age group?
 
 ```SQL
 SELECT age_group, 
	SUM(suicides_no) AS total_suicides_age 
FROM suicide_rates
GROUP BY age_group
ORDER BY total_suicides_age DESC;
```
![totalsuicidesage](totalsuicidesage.jpg)

#### 4. How many suicides by gender and age group?

 ```SQL
 SELECT sex, age_group, 
	SUM(suicides_no) AS total_suicides 
FROM suicide_rates
GROUP BY sex, age_group
ORDER BY total_suicides DESC;
```
![totalsuicidesgenderage](totalsuicidesgenderage.jpg)

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
![top10countries](top10countries.jpg)

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
![fewestcountry](fewestcountry.jpg)

#### 7. On average, how many suicides/100k pop happened during this period?

```SQL
SELECT ROUND(AVG(suicides_per_100k),2) AS avg_suicides_per_100k 
FROM suicide_rates;
```
![totalavg100k](totalavg100k.jpg)

#### 8. On average, how many suicides/100k pop happened during this period for each gender?

```SQL
SELECT sex, 
	ROUND(AVG(suicides_per_100k),2) AS avg_suicides_per_100k 
FROM suicide_rates
GROUP BY sex
ORDER BY avg_suicides_per_100k DESC;
```
![avg100kgender](avg100kgender.jpg)

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
![avg100kcountry](avg100kcountry.jpg)

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

![top10years](top10years.jpg)
			    

