# Netflix Movies And Tv Shows Analysis using SQL 

![Netflix Logo](netflix.jpg)


## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema



```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```


## SELECTING ALL RECORDS

```sql
SELECT * FROM NETFLIX ;
```

## COUNTING ALL RECORDS


```sql
SELECT COUNT(*) as TOTAL FROM NETFLIX;
```



## MOVIE TYPES 
```sql
SELECT DISTINCT type as MovieType FROM NETFLIX; 
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type,COUNT(type) as Total_Shows  FROM NETFLIX GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type,rating,count(rating) FROM Netflix GROUP by rating,type Order BY type,count(rating) DESC;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * FROM NETFLIX WHERE type = 'Movie' AND release_year = '2020';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT UNNEST(STRING_TO_ARRAY(country,',')) as new_country,count(show_id) as total_content FROM Netflix group by new_country order by total_content desc LIMIT 5;

```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT * FROM Netflix Where type = 'Movie' AND duration = (SELECT MAX(duration) from Netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT * FROM Netflix where TO_Date(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *,SPLIT_PART(duration,' ',1)  FROM Netflix WHERE type = 'TV Show' AND SPLIT_PART(duration,' ',1)::numeric > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) as genere,count(listed_in) FROM Netflix Group By genere;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT * FROM Netflix;
SELECT EXTRACT(YEAR FROM TO_Date(date_added,'Month DD,YYYY')) as year,
COUNT(*) as yearly_content,
ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix Where Country = 'India')::numeric * 100 ,2) as avg_content_per_year
FROM Netflix
WHERE country = 'India'
GROUP BY 1;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT * FROM Netflix WHERE listed_in ilike '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * FROM Netflix WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM Netflix 
WHERE casts ILIKE '%Salman Khan%' AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
with top_actors as (
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) as actor,COUNT(*),type,country FROM Netflix GROUP BY actor,type,country ORDER BY COUNT(*) DESC
)
SELECT actor,count as no_of_movies FROM top_actors WHERE type = 'Movie' AND country = 'India' LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
with cte as (
SELECT *,
CASE WHEN 
   description ILIKE '%kill%' OR
   description ILIKE '%violence%' THEN 'Bad'
   ELSE 'Good'
 END as category
FROM Netflix

)

SELECT count(*) as total_content,category FROM cte GROUP BY category;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Zero Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/ahmeed_jutt_/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/ahmadmehmood1252/)


Thank you for your support, and I look forward to connecting with you!
