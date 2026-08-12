-- Total movies
select count(type) as movies_count from netflix_data where type="movie";

-- Total TV Shows
select count(type) as no_of_TvShows from netflix_data where type="tv show";

-- Average Release Year
select round(avg(release_year),0) as avg_release_year from netflix_data;

-- Newest Movie
select title, release_year
from netflix_data
where type = 'Movie'
order by release_year DESC
limit 1;

-- Oldest movie
select title, release_year
from netflix_data
where type = 'Movie'
order by release_year asc
limit 1;

-- Top 10 Countries
select country,count(title) as no_of_movies from netflix_data where country is not null 
group by country
order by no_of_movies desc
limit 10;

-- Top Genres
SELECT listed_in,
       COUNT(*) AS total_titles
FROM netflix_data
GROUP BY listed_in
ORDER BY total_titles DESC
LIMIT 10;

-- Average Movie Duration
select round(avg(duration),0) from netflix_data where type="movie";

-- Most Common Rating
select rating,count(rating) from netflix_data group by rating order by count(rating) desc limit 1;

-- movies vs tv shows
select type,
       COUNT(*) AS total_titles
from netflix
group by type;

-- Content Added Per Year
SELECT added_year,
       COUNT(*) AS total_titles
FROM netflix_data
WHERE date_added IS NOT NULL
GROUP BY added_year
ORDER BY added_year;

-- Top movie every year
WITH MovieRank AS(SELECT
release_year,
title,
rating,
ROW_NUMBER() OVER(PARTITION BY release_year
ORDER BY rating DESC) AS rn
FROM netflix_data
WHERE type='Movie')
SELECT release_year,title,rating
FROM MovieRank
WHERE rn=1
ORDER BY release_year;

-- running total
SELECT
release_year,
COUNT(*) AS Total_Content,
SUM(COUNT(*)) OVER
(
ORDER BY release_year
) AS Running_Total
FROM netflix
GROUP BY release_year
ORDER BY release_year;

-- rank countries
WITH CountryCount AS(SELECT country,COUNT(*) AS Total_Content FROM netflix WHERE country IS NOT NULL GROUP BY country)
SELECT *,RANK() OVER(ORDER BY Total_Content DESC) AS Country_Rank FROM CountryCount;

--