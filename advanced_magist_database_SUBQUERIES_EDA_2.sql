USE imdb_ijs;

-- The big picture
-- 1. How many actors are there in the actors table?
select count(*)
from actors;


-- 2. How many directors are there in the directors table?
select count(*)
from directors;


-- 3. How many movies are there in the movies table?
select count(*)
from movies;


-- Exploring movies
-- 4. From what year are the oldest and the newest movies? What are the names of those movies?
select max(year)
from movies;


select *
from movies
where year = 2008;


select min(year)
from movies;

select *
from movies
where year = 1888;


-- 5. What movies have the highest and the lowest ranks?
select * from movies where movies.rank = (select min(movies.rank) from movies) order by year;

select * from movies where movies.rank = (select max(movies.rank) from movies) order by year;


-- 6. What is the most common movie title?
select name, count(name) as name_count
from movies
group by name
order by name_count desc;


-- Understanding the database
-- 7. Are there movies with multiple directors?
select movie_id, count(director_id) num from movies_directors group by movie_id order by num desc;


-- 8. What is the movie with the most directors? Why do you think it has so many?
with result as (select movie_id, count(director_id) num from movies_directors group by movie_id)
select * from result where num = (select max(num) from result);

select * from movies where id = 382052;


-- 9. On average, how many actors are listed by movie?
select movie_id, count(actor_id) num from roles group by movie_id order by num desc;


-- 10. Are there movies with more than one “genre”?
select movie_id, count(genre) num from movies_genres group by movie_id order by num desc;


-- Looking for specific movies
-- 11. Can you find the movie called “Pulp Fiction”?
select * from movies where name like 'Pulp Fiction';

-- Who directed it?
select * 
from movies_directors m_d
left join directors d
on m_d.director_id = d.id
where m_d.movie_id = 267038;

-- Which actors were casted on it?
select *
from roles
left join actors
on roles.actor_id = actors.id
where movie_id = 267038;


-- 12. Can you find the movie called “La Dolce Vita”?
select * from movies where name like 'Dolce Vita, La';

-- Who directed it?
select * 
from movies_directors m_d
left join directors d
on m_d.director_id = d.id
where m_d.movie_id = 89572;

-- Which actors where casted on it?
select *
from roles
left join actors
on roles.actor_id = actors.id
where movie_id = 89572;


-- 13. When was the movie “Titanic” by James Cameron released?
select * 
from movies m
left join movies_directors m_d
on m.id = m_d.movie_id
left join directors d
on d.id = m_d.director_id
where m.name like 'Titanic' and d.last_name like 'Cameron';


-- Actors and Directors
-- 14. Who is the actor that acted more times as “Himself”?
with result as (select actor_id, count(role) num from roles where role like 'Himsel%' group by actor_id order by num desc)
select * from result r left join actors a on a.id = r.actor_id;


-- 15. What is the most common name for actors? And for directors?
select first_name, last_name, count(*) num from actors group by first_name, last_name order by num desc;

select first_name, last_name, count(*) num from directors group by first_name, last_name order by num desc;


-- Analyzing Genders
-- 16. How many actors are male and how many are female?
select count(*) from actors where gender like 'M';
select count(*) from actors where gender like 'F';


-- 17. What percentage of actors are female, and what percentage are male?
select (select count(*) from actors where gender like 'M') / (select count(*) from actors);
select (select count(*) from actors where gender like 'F') / (select count(*) from actors);


-- Movies across time
-- 18. How many of the movies were released after the year 2000?
select count(*) from movies where year > 2000;


-- 19. How many of the movies where released between the years 1990 and 2000?
select count(*) from movies where year between 1990 and 2000;


-- 20. Which are the 3 years with the most movies? How many movies were produced on those years?
select year, count(id) num from movies group by year order by num desc;


-- 21. What are the top 5 movie genres?
select genre, count(movie_id) num from movies_genres group by genre order by num desc;


-- 22. What are the top 5 movie genres before 1920?
select genre, count(movie_id) num 
from movies_genres m_g
left join movies m
on m.id = m_g.movie_id
where year < 1920 
group by genre 
order by num desc;


-- 23. What is the evolution of the top movie genres across all the decades of the 20th century?
select genre, count(movie_id) num 
from movies_genres m_g
left join movies m
on m.id = m_g.movie_id
where year between 1900 and 1999
group by genre 
order by num desc;


-- Putting it all together: genders and time 

-- with result as (select movie_id, gender, count(*) 
-- from roles r 
-- left join actors a 
-- on r.actor_id = a.id
-- group by movie_id, gender)
-- select *
-- from result r1
-- inner join (select * from result r2 where gender like 'M') r2
-- on r1.movie_id = r2.movie_id
-- where r1.gender like 'F';

-- 24. How many movies had a majority of females among their cast?
with result1 as (select movie_id, gender, count(*) `count`
				 from roles r1 
				 left join actors a1 
				 on r1.actor_id = a1.id
				 where gender like 'F' 
				 group by movie_id, gender
				 having count(*) > (select count(*) `count`
									from roles r2 
									left join actors a2 
									on r2.actor_id = a2.id
									where gender like 'M' and r2.movie_id = r1.movie_id
									group by movie_id, gender)),
result2 as (select movie_id, gender, count(*) 
			from roles r 
			left join actors a 
			on r.actor_id = a.id
			where gender = 'M'
			group by movie_id, gender)
select *
from result1 res1
left join result2 res2
on res1.movie_id = res2.movie_id;


-- 25. What percentage of the total movies had a majority female cast?
with result1 as (select movie_id, gender, count(*) `count`
				 from roles r1 
				 left join actors a1 
				 on r1.actor_id = a1.id
				 where gender like 'F' 
				 group by movie_id, gender
				 having count(*) > (select count(*) `count`
									from roles r2 
									left join actors a2 
									on r2.actor_id = a2.id
									where gender like 'M' and r2.movie_id = r1.movie_id
									group by movie_id, gender))
select (select count(*) from result1)/(select count(*) from movies) frac;
