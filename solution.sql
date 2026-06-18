--Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),	
	listed_in VARCHAR(100),
	description VARCHAR(250)
);
select * from netflix;

select 
  count(*) as total_content
from netflix;

select 
  distinct type
from netflix;

--Business Problems--
--1. Count the Number of Movies vs TV Shows
SELECT 
   type,
   count(*) as total_contant
   from netflix
   group by type;

--2. Find the Most Common Rating for Movies and TV Shows
SELECT
   type,
   rating
from   
(SELECT
    type,
    rating,
    COUNT(*),
    RANK() OVER (
        PARTITION BY type
        ORDER BY COUNT(*) DESC
    ) AS ranking
FROM netflix
GROUP BY type, rating) as t1
where
  ranking=1;
--order by 3 desc;

--3. List All Movies Released in a Specific Year (e.g., 2020)
--filter 2020
--movies
SELECT * FROM netflix
where 
   type='Movie'
   and
   release_year=2020;

--4. Find the Top 5 Countries with the Most Content on Netflix
SELECT
   unnest(string_to_array(country,',')) as new_country,
   count(show_id) as total_contenet
FROM netflix
group by 1
order by 2 desc
limit 5;
select
  unnest(string_to_array(country,',')) as new_country
from netflix;

--5. Identify the Longest Movie
SELECT * FROM netflix 
where
   type='Movie'
   and
   duration=(select max(duration) from netflix);

--6. Find Content Added in the Last 5 Years
SELECT 
 *
 FROM netflix 
where
    TO_DATE(date_added,'Month DD,YYYY')>=current_date-interval '5 years'
	
select current_date-interval '5 years';

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT * FROM netflix 
where director ilike '%Rajiv Chilaka%';

--8. List All TV Shows with More Than 5 Seasons
SELECT
*
FROM netflix 
where
   type='TV Show'
   and
   split_part(duration,' ',1)::numeric >5;

--9. Count the Number of Content Items in Each Genre
SELECT
  unnest(string_to_array(listed_in,',')) as genre,
  count(show_id) as total_content
FROM netflix
group by 1;

--10.Find each year and the average numbers of content release in India on netflix.
select
extract(year from to_date(date_added,'Month DD,YYYY')) as year,
count(*) as yearly_content,
round(
count(*)::numeric/(select count(*) from netflix
where country='India')::numeric*100
,2)as avg_content_per_year
from netflix
where country='India'
group by 1 ;

--11. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries%';

--12. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
where casts ilike '%Salman khan%'
and
release_year>extract(year from current_date)-10

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
--show_id,
--casts,
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
FROM netflix
where country ilike 'India'
group by 1
order by 2 desc
limit 10

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
with new_table
as
(select 
*,
  case
  when description ilike '%kill%'  or
  description ilike '%violence%' then 'bad_content'
  else 'good_content'
  end category
from netflix)
select 
 category,
 count(*) as total_content
from new_table
group by 1
 
 

