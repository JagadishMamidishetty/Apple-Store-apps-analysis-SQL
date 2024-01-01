create table applestore_description_combined AS 

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4



**EXPLANATORY DATA ANALYSIS** 

--Check the number of unique apps in both tableApplestore

SELECT COUNT(DISTINCT id) AS UniqueAppids
from AppleStore

SELECT COUNT(DISTINCT id) AS uniqueAppids
FROM applestore_description_combined

--Check for missing values in any major fields 

SELECT COUNT (*) as MissingValues
from AppleStore
where track_name is NULL or user_rating IS NULL or prime_genre IS NULL

SELECT COUNT (*) as MissingValues
from applestore_description_combined
where app_desc is NULL


--Find out number of apps by genre 

select prime_genre,count(*) AS numApps
FROM AppleStore
group BY prime_genre
order by numApps DESC

SELECT min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
FROM AppleStore       


**DATA ANALYSIS** 

--Determine wheather paid apps have higher ratings than free apps 

SELECT CASE 
            WHEN price > 0 then 'paid'
            ELSE 'free' 
        end as app_type,
        avg(user_rating) as avg_rating
FROM AppleStore
GROUP BY app_type

--check wheather the apps with more supported languages have higher ratings 

SELECT CASE 
           when lang_num < 10 then '<10 languages'
           when lang_num BETWEEN 10 and 30 then '10-30 languages'
           else '>30 languages'
       END as language_bucket,
       avg(user_rating) as avg_rating
FROM AppleStore
GROUP BY language_bucket
ORDER by avg_rating DESC

--check genres with low ratings

SELECT prime_genre,
       avg(user_rating) as avg_rating
from AppleStore
GROUP by prime_genre
order  by avg_rating ASC
limit 10 

--to check wheather there is a correleation between the the length of app description and the ratings 

SELECT case 
          when length(b.app_desc) < 500 THEN 'short'
          WHEN length(b.app_desc) BETWEEN 500 and 1000 then 'medium'
          else 'long'
       end as desciption_length_bucket,
       avg(a.user_rating) as avg_rating
       
from 
    AppleStore as a 
join 
    applestore_description_combined as b 
on 
  a.id = b.id  
GROUP by  desciption_length_bucket
ORDER by avg_rating DESC
          
--check the top rated apps in the each genre 

SELECT 
     prime_genre,
     track_name,
     user_rating
FROM (
     SELECT
     prime_genre,
     track_name,
     user_rating,
     rank() over(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank 
     FROM 
     AppleStore
  )as a 
where a.rank = 1 