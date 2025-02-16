USE imdb_ijs;
/*
How many actors are there in the actors table?
How many directors are there in the directors table?
How many movies are there in the movies table?
*/
SELECT count(*) FROM actors;
SELECT count(*) FROM directors;
SELECT count(*) FROM movies;


/*
From what year are the oldest and the newest movies? What are the names of those movies?
*/
SELECT * 
FROM
(SELECT name as oldest, year FROM movies
WHERE year=(SELECT MIN(year) as oldest FROM movies)) as oldes
JOIN
(SELECT name as newest, year FROM movies
WHERE year=(SELECT MAX(year) as newest FROM movies)) as newest;

/*
What movies have the highest and the lowest ranks?
*/

SELECT * 
FROM
(SELECT ROW_NUMBER() OVER() as `index`,name as lowest, `rank` FROM movies
WHERE `rank`=(SELECT MIN(`rank`) as lowest_rank FROM movies)) as oldes
LEFT JOIN
(SELECT ROW_NUMBER() OVER() as `index`, name as highest, `rank` FROM movies
WHERE `rank`=(SELECT MAX(`rank`) as highest_rank FROM movies)) as newest
USING(`index`);

SELECT * 
FROM
(SELECT name, `rank` FROM movies
WHERE `rank`=(SELECT MIN(`rank`) as lowest_rank FROM movies)) as oldes
UNION
SELECT * 
FROM
(SELECT name, `rank` FROM movies
WHERE `rank`=(SELECT MAX(`rank`) as highest_rank FROM movies)) as newest;

/*
What is the most common movie title?
*/

SELECT name AS most_common_title, count(*)  FROM movies GROUP BY name ORDER BY count(*) DESC;

/*
Which genre is the highest-ranked on average?
*/

SELECT genre, AVG(`rank`) FROM movies
JOIN movies_genres
ON movies_genres.movie_id = movies.id
GROUP BY genre
ORDER BY AVG(`rank`) DESC;

SELECT mg.genre, AVG(m.rank) AS avg_rank FROM movies_genres AS mg JOIN movies AS m ON mg.movie_id = m.id GROUP BY mg.genre ORDER BY avg_rank ASC LIMIT 1;

/*
Are there movies with multiple directors?                      
What is the movie with the most directors? Why do you think it has so many?
*/

SELECT movie_id, name, count(director_id) directors FROM movies_directors 
JOIN movies ON movies.id=movie_id
GROUP BY movie_id ORDER BY directors DESC;

/*
On average, how many actors are listed for each movie?
*/
SELECT AVG(actors)
FROM
(SELECT movie_id, count(actor_id) actors from roles GROUP BY movie_id) as actors;

/*SELECT AVG(roles)
FROM
(SELECT actor_id, count(movie_id) roles from roles GROUP BY actor_id) as roles;*/


/*
Are there movies with more than one “genre”?
*/
SELECT movie_id, count(genre) genres from movies_genres group by movie_id ORDER BY genres DESC;

/*
Compute the average, minimum, and maximum rank for movies released each decade.
*/
SELECT FLOOR(year/10)AS decades, AVG(`rank`) , MAX(`rank`), MIN(`rank`) from movies GROUP BY decades ORDER BY decades;

/*
Can you find the movie called “Pulp Fiction”?
Who directed it?
Which actors were cast in it?
*/
SELECT *
FROM
(SELECT * FROM movies WHERE name='Pulp Fiction') as pulp_fiction
JOIN movies_directors ON pulp_fiction.id=movie_id
JOIN directors ON directors.id=director_id;

SELECT first_name, last_name, gender, role FROM actors
JOIN roles ON id=actor_id
JOIN movies ON movie_id=movies.id
WHERE name='Pulp Fiction';
/*
Can you find the movie called “La Dolce Vita”?
Who directed it?
Which actors were cast in it?
*/
SELECT *
FROM
(SELECT * FROM movies WHERE name LIKE 'Dolce vita, La') as dolce_vita
JOIN movies_directors ON dolce_vita.id=movie_id
JOIN directors ON directors.id=director_id;

SELECT first_name, last_name, gender, role FROM actors
JOIN roles ON id=actor_id
JOIN movies ON movie_id=movies.id
WHERE name LIKE 'Dolce vita, La';

/*
When was the movie “Titanic” by James Cameron released?
Hint: there are many movies named “Titanic”. We want the one directed by James Cameron.
Hint 2: the name “James Cameron” is stored with a weird character on it.
*/

SELECT CONCAT(first_name,' ',last_name) as `name`,`name` AS `title`, `year`, `rank` 
FROM directors 
JOIN movies_directors ON directors.id=director_id
JOIN movies ON movies.id=movie_id
WHERE 
first_name LIKE '%JAMES%' AND last_name='Cameron' and movies.name='Titanic';

/*
What are the genres of movies directed by James Cameron who directed Titanic?
*/
Select `genre` as`James Cameroon genres` FROM directors
JOIN movies_directors ON directors.id=director_id
JOIN movies_genres USING(movie_id)
WHERE first_name LIKE '%JAMES%' AND last_name='Cameron'
GROUP BY `genre`;


/*
What is the probability of James Cameron working on a Horror movie?
*/

SELECT CONCAT(first_name,' ',last_name) as `name`, genre, prob as probability FROM directors_genres
JOIN directors ON directors.id=director_id
WHERE first_name LIKE '%JAMES%' AND last_name='Cameron' AND genre='Horror';

/*
What’s the average rank of a movie by James Cameron?
*/
SELECT AVG(`rank`)as `James Cameroon movies avg rank` FROM directors
JOIN movies_directors ON directors.id=director_id
JOIN movies ON movies.id=movie_id
WHERE first_name LIKE '%JAMES%' AND last_name='Cameron';

/*
Who is the actor that acted more times as “Himself”?
*/

SELECT CONCAT(first_name,' ',last_name) as `name`, count(role) as `Himself role` from roles
JOIN actors ON actors.id=actor_id
WHERE role='Himself'
GROUP BY actor_id
ORDER BY `Himself role` DESC;

/*
What is the most common name for actors? And for directors?
*/
/*ACTORS*/
-- first names
Select first_name, count(*) names_amount FROM actors GROUP BY first_name ORDER BY names_amount DESC;
-- last names
Select last_name, count(*) names_amount FROM actors GROUP BY last_name ORDER BY names_amount DESC;
-- full names
Select CONCAT(first_name,' ',last_name) as `full name`, count(*) names_amount 
FROM actors
GROUP BY `full name`
HAVING names_amount>1
 ORDER BY names_amount DESC;
/*DIRECTORS*/
-- first names
Select first_name, count(*) names_amount FROM directors GROUP BY first_name ORDER BY names_amount DESC;
-- last names
Select last_name, count(*) names_amount FROM directors GROUP BY last_name ORDER BY names_amount DESC;
-- full names
Select CONCAT(first_name,' ',last_name) as `full name`, count(*) names_amount 
FROM directors
GROUP BY `full name`
HAVING names_amount>1
 ORDER BY names_amount DESC;
 
 /*
 Which directors have Samuel L. Jackson worked with?
 */
 
 SELECT 
 CONCAT(directors.first_name,' ',directors.last_name) as director, count(*) as films_with_S_L_Jackson
 from 
 actors
 JOIN roles ON actors.id=actor_id
 JOIN movies ON movies.id=movie_id
 JOIN movies_directors ON movies.id=director_id
 JOIN directors ON directors.id=director_id
 WHERE actors.first_name='Samuel L.' AND actors.last_name='Jackson'
 GROUP BY director ORDER BY films_with_S_L_Jackson DESC;
 
 SELECT *
 from 
 actors
 JOIN roles ON actors.id=roles.actor_id
 JOIN movies ON movies.id=roles.movie_id
 JOIN movies_directors ON movies.id=movies_directors.movie_id
 JOIN directors ON directors.id=movies_directors.director_id
 WHERE movies.name LIKE '%Pulp%';
 -- WHERE actors.first_name='Samuel L.' AND actors.last_name='Jackson';
 
 SELECT * 
 FROM movies 
 JOIN roles ON movie_id=movies.id 
 JOIN actors ON actor_id=actors.id
 WHERE name LIKE 'Pulp Fiction';