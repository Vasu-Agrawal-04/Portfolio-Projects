drop table if exists netflix;
create table netflix(
show_id varchar(100),
type varchar(100),
title varchar(300),
director varchar(550),
casts varchar(1000),
country varchar(550),
date_added varchar(550),
release_year int,
rating varchar(550),
duration varchar(550),
listed_in varchar(550),
description varchar(500)
);
select * from netflix;

-- Business Queries----------------------------------------------------------
-- 1. Count the number of Movies vs TV Shows
-- 2. Find the most common rating for movies and TV shows
-- 3. List all movies released in a specific year (e.g., 2020)
-- 4. Find the top 5 countries with the most content on Netflix
-- 5. Identify the longest movie
-- 6. Find content added in the last 5 years
-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
-- 8. List all TV shows with more than 5 seasons
-- 9. Count the number of content items in each genre
-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
-- 11. List all movies that are documentaries
-- 12. Find all content without a director
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.


-- 1. Count the number of Movies vs TV Shows
select type,count(*) as total_count from netflix 
group by type order by total_count desc;

-- 2. Find the most common rating for movies and TV shows
select type,rating as most_comm_rating from (
select type, rating , count(*),
rank() over (partition by type order by count(*) desc) as rnk
from netflix group by type, rating) as t1 where rnk = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
select title from netflix where type = 'Movie' and release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix
select distinct trim(unnest(string_to_array(country,','))) as new_country,
count(show_id) from netflix group by new_country 
order by count(show_id) desc limit 5; 

-- 5. Identify the longest movie
select title, substring(duration,1,position('m' in duration)-1) :: int duration
from netflix where type = 'Movie' and duration is not null
order by 2 desc limit 1;

-- 6. Find content added in the last 5 years
select * from netflix where 
to_date(date_added,'Month DD, YYYY') >= current_date - interval '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
select title from netflix where director ilike '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
select *, split_part(duration,' ',1) as seasons 
from netflix where type = 'TV Show' and 
split_part(duration,' ',1) ::numeric > 5;

-- 9. Count the number of content items in each genre
select distinct trim(unnest(string_to_array(listed_in,','))) as genre, 
count(*) as content_count from netflix group by genre 
order by content_count desc;

-- 10.Find each year and the average numbers of content release 
--in India on netflix & return top 5 year with highest avg content release!
select
extract (year from to_date(date_added,'Month DD, YYYY')) as year,count (*),
round(count(*)::numeric/(select count(*) 
from netflix where country = 'India') * 100 ::numeric,2) as avg_count
from netflix where country = 'India' group by year 
order by avg_count desc limit 5;

-- 11. List all movies that are documentaries
select * from netflix where listed_in ilike '%Documentaries%';

-- 12. Find all content without a director
select count(*) from netflix where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select title,casts,release_year from netflix where casts ilike '%Salman Khan%' 
and type = 'Movie' and release_year>=extract(year from current_date) -10;

-- 14. Find the top 10 actors who have appeared 
-- in the highest number of movies produced in India.
select trim(unnest(string_to_array(casts,','))) as new_cast,
count(*) from netflix where country ilike '%India%' group by new_cast
order by count(*) desc limit 10;


-- 15.
-- Categorize the content based on the presence of the 
-- keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords 
-- as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

select count(*) as content_type_count,case 
when description ilike '%kill%' or description like '%violence%' then 'bad'
else 'good' end as content_type 
from netflix group by content_type order by count(*) desc;