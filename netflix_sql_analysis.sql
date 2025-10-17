

-- Creating a Netflix Table 



-- DROP TABLE IF EXISTS NETFLIX;


-- CREATE TABLE netflix (
--    show_id VARCHAR(6),
--    type VARCHAR(10),
--    title VARCHAR(150),
--    director VARCHAR(208),
--    casts VARCHAR(1000),
--    country VARCHAR(150),
--    date_added VARCHAR(50),
--    release_year INT,
--    rating VARCHAR(10),
--    duration VARCHAR(15),
--    listed_in VARCHAR(100),
--    description VARCHAR(250)
-- );

-- SELECTING ALL RECORDS

SELECT * FROM NETFLIX ;


-- COUNTING ALL RECORDS

SELECT COUNT(*) as TOTAL FROM NETFLIX;


-- MOVIE TYPES 

SELECT DISTINCT type as MovieType FROM NETFLIX; 


-- Q No 1 : Count The Number Of Movies Vs TV SHOWS 

SELECT type,COUNT(type) as Total_Shows  FROM NETFLIX GROUP BY type;


-- Q No 2 : Find The Most Common Rating For Movies And Tv Shows 

SELECT type,rating,count(rating) FROM Netflix GROUP by rating,type Order BY type,count(rating) DESC;

-- Q No 3 List All Movies Released In A specific Year 2020

SELECT * FROM NETFLIX WHERE type = 'Movie' AND release_year = '2020';


-- Converting the String to Array 


SELECT UNNEST(STRING_TO_ARRAY(country,',')) as new_country FROM Netflix;


-- Q no 4 Find The Top 5 Countries With The Most Content On Internet 

SELECT UNNEST(STRING_TO_ARRAY(country,',')) as new_country,count(show_id) as total_content FROM Netflix group by new_country order by total_content desc LIMIT 5;


-- Q no 5 Identify The Longest Movie

SELECT * FROM Netflix Where type = 'Movie' AND duration = (SELECT MAX(duration) from Netflix);


-- Q no 6 Find The Content Added In The Last Five Years 

SELECT * FROM Netflix where TO_Date(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- Q no 7 : Find All The Movies / Tv Shows by director 'Rajiv Chalaka'!

SELECT * FROM NETFLIX WHERE director ILIKE '%Rajiv Chilaka%';


-- Q no 8 : List All Tv Shows With More Than 5 seasons

SELECT *,SPLIT_PART(duration,' ',1)  FROM Netflix WHERE type = 'TV Show' AND SPLIT_PART(duration,' ',1)::numeric > 5;


-- Q no 9 Count the No Of Content Items in each genere

SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) as genere,count(listed_in) FROM Netflix Group By genere;

-- Q no 10 Find Each Year And Average No Of Content release by India on Netflix . return top 5 years with the
   -- highest avg content release 

SELECT * FROM Netflix;
SELECT EXTRACT(YEAR FROM TO_Date(date_added,'Month DD,YYYY')) as year,
COUNT(*) as yearly_content,
ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix Where Country = 'India')::numeric * 100 ,2) as avg_content_per_year
FROM Netflix
WHERE country = 'India'
GROUP BY 1;



-- Q no 11 - List All Movies That Are Documentaries 

SELECT * FROM Netflix WHERE listed_in ilike '%Documentaries%';



-- Q no 12 : Find All Content without a director 

SELECT * FROM Netflix WHERE director IS NULL;



-- Q no 13 : Find How Many Movies Actor Salman Khan Appeared In Last 10 years 

SELECT * 
FROM Netflix 
WHERE casts ILIKE '%Salman Khan%' AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- Q no 14 : Find The Top 10 Actors Who Appeared In the Highest number of movies produced in India 
with top_actors as (
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) as actor,COUNT(*),type,country FROM Netflix GROUP BY actor,type,country ORDER BY COUNT(*) DESC
)
SELECT actor,count as no_of_movies FROM top_actors WHERE type = 'Movie' AND country = 'India' LIMIT 10;



-- Q no 15 : Categorizing The Content Based On presence of their keywords 'kill' and  'violence' in the description field .label content containing these keywords 
-- as 'Bad' and 'All' Other content as 'Good' .Count how many items fall into each category . 

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