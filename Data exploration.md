  #### 1. How many suicides happened from 1985 to 2016?
 ``` SQL
 SELECT SUM(suicides_no) AS total_suicides
	FROM suicide_rates; 
  ```
  ![total suicides](total suicides.png)
  
  #### 2. How many suicides/ gender?
  
  ```SQL
  SELECT sex, 
	SUM(suicides_no) AS total_suicides_gender
FROM suicide_rates
GROUP BY sex
ORDER BY total_suicides_gender DESC;
```

![total suicides gender](total suicides gender.png)
  
  
