# Suicide Rates 1985-2016
 
Suicide is a serious public health issue that affects individuals, families, and communities worldwide. According to the World Health Organization (WHO), approximately 700,000 people die by suicide every year, making it the fourth leading cause of death among people aged 15-29 years. Furthermore, for every suicide death, there are many more individuals who attempt suicide but do not succeed.

The impact of suicide is not limited to the individual who dies by suicide, but also affects their loved ones and the wider community. Suicide can have a profound emotional, social, and economic impact on families and communities, and can contribute to feelings of fear, sadness, and hopelessness.

By analyzing suicide rates over time and identifying trends and patterns in the data, we can gain a better understanding of the factors that contribute to suicide and develop targeted prevention strategies to reduce the incidence of suicide. This project aims to contribute to this important goal by exploring suicide rates worldwide from 1985 to 2016. The insights gained from this analysis could inform the development of policies and interventions aimed at reducing the prevalence of suicide and improving mental health outcomes for individuals and communities.

### Dataset: 
 The dataset for this project can be found on [Kaggle](https://www.kaggle.com/datasets/russellyates88/suicide-rates-overview-1985-to-2016). The dataset contains information about suicide rates worldwide from 1985 to 2016. 
 
 The dataset includes the following attributes:
   - year
   - country
   - sex
   - age group
   - suicides number
   - population
   - suicides per 100k
   - country_year
   - hdi for year
   - gdp for year
   - gdp per capita
   - generation
 
 ### Project Overview: 
  In this project, I analyzed suicide rates from 1986 to 2016. The main goal of this project was to identify any patterns or trends in the data that may be useful for understanding the factors that contribute to suicide rates worldwide.
  
  ### Tools:
  PostgreSQL
  
  Power BI
  
  ### Project Steps:
  #### 1. Create a new data base and load the data into PostgreSQL.
  
  #### 2. Data cleaning and preparation
  - ensuring data constistency;
  - hadling NULL values by replacing missing values with zero;
 
 #### 3. Create a relational database
 Having in mind that I will use Power Bi to create a dashboard, I created a relational database:
  - I created new tables:
      - countries (with country_id as a primary key, and country columns)
      - years (with year_id as a primary key, and year columns)
      - age_groups (with age_group_id as primary key, and age_group columns)
      - gender (with gender_id as pimary key, and gender columns)
      - economic_indicators (country_id as foreign key that links to the countries table, year_id as foreign key that links to the years table, hdi, gdp, gdp_per_capita columns)
    
  - Then, I connected the suicide_rates table with the new tables: countries (country_id as foreign key), years (year_id as foreign key), age_groups (age_group_id as foreign key), gender (gender_id as foreign key).
  - Finally, I removed the country, age_group, gender, hdi_for_year, gdp_for_year_gdp_per_capita columns from the suicide_rates table.
  - I also removed the country_year and generation columns from the suicide_rates table as I will not be using them.
  
  #### 4. Data exploration (PostgreSQL)
  - extracting relevant data;
  - performing data analysis to identify trends and patterns in the data
  - I was particularly interested in the highest number of suicides per age group, country, gender and the year they took place. This was a good opportunity to practice JOINS and Subqueries


  #### 5. Data visualization
 
   


https://user-images.githubusercontent.com/99826363/236230629-1136aab0-7a69-47fc-8ac6-3421cb6c5ddb.mp4


 To create the map, I downloaded a world countries map json from [mbstock GitHub repository](https://github.com/topojson/world-atlas) and rendered it using the shape map visual.
   
  #### Key findings: 
  
 -	Men committed three times more suicides than women.
 -	More than one third of deaths reported were people between 35 and 54.
 -	There was an ascending trend in the number of suicides during the 31-year period. This was the case for every age-group.
 -	1999 recorded the highest number of deaths by suicide (256119), of which 78076 were middle aged men.
 -	When taken by region, East European countries appear to have a higher rate of suicide per 100k population. 
 -	The situation changes when we take gender into consideration, men from Lithuania had the highest suicide rate while when it comes to women, Sri Lanka comes in first, followed by South Korea and Hungary.
 -	On the other end of the spectrum, Dominica and Saint Kitts and Nevis reported no suicides during the time period.
 -	Despite having the highest GDP per capita, Luxembourg had a suicide rate that was above the average.
 -	There seems to be a weak positive correlation between GDP per capita and average suicide rates per 100k people. However, it is important to note that this relationship may be influenced by other factors that are not captured by this analysis.
 
 

   #### Next Steps:

This analysis presents an overview of suicide rates between 1985-2016. In future work, I plan to investigate additional factors that could impact suicide rates, such as mental health diagnoses, availability of mental health services, and social support. Additionally, I intend to apply statistical tests to identify any correlations between specific variables and suicide rates.
 


