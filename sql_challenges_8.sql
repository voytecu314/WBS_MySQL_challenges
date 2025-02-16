/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 8

*******************************************************************************
*******************************************************************************


In the exercises below you will need to use the clauses you used in the
previous SQL Challenges, plus the following clauses:
    - Subqueries

*/

USE publications;

/*******************************************************************************
Subqueries

https://dev.mysql.com/doc/refman/8.4/en/subqueries.html
*******************************************************************************/


-- 1. Find the name of the publisher with the highest advance.
SELECT pub_name, max_advance_table.max_advance
FROM publishers
JOIN (SELECT pub_id,MAX(advance) as max_advance FROM titles GROUP BY pub_id) as max_advance_table
USING(pub_id);

-- 2. List the titles of books published by publishers based in 'Boston'.

SELECT t.title, p.pub_name, p.city as pub_city
FROM titles AS t
JOIN publishers AS p 
USING(pub_id)
WHERE city='Boston';

SELECT  title, (SELECT pub_name FROM publishers p WHERE p.city = 'Boston' AND p.pub_id = t.pub_id) as boston_publisher 
FROM titles t
ORDER BY boston_publisher;

-- 3. Find the authors who have written more than one book.
SELECT au_fname, au_lname, books.books_amount
FROM authors
JOIN
(SELECT au_id, count(title_id) as books_amount FROM titleauthor GROUP BY au_id HAVING books_amount>1) as books
USING(au_id);

-- 4. List all authors and the number of books they have written.

SELECT au_fname, au_lname, books.books_amount
FROM authors
JOIN (SELECT au_id, count(title_id) as books_amount
FROM titleauthor
GROUP BY au_id) as books
USING(au_id);

-- 5. Find the titles with a price higher than the average price.

SELECT *
FROM titles
WHERE price>(SELECT AVG(price) FROM titles);

-- 6. Find the name of the publisher who has published the most books.

SELECT pub_name, publisher.books
FROM publishers
JOIN (SELECT pub_id as id, count(*) as books FROM titles GROUP BY pub_id) as publisher
ON publishers.pub_id = publisher.id
ORDER BY books DESC
LIMIT 1;

-- 7. List the titles that have never been sold.

SELECT title FROM titles
LEFT JOIN sales
USING(title_id)
WHERE stor_id is null;
-- 8. List all titles along with their publisher's name.

SELECT title, pub_name FROM titles
LEFT JOIN publishers USING(pub_id);



-- 9. List the employees who have the same job as 'Helen Bennett'.

SELECT fname, lname FROM employee
WHERE job_id = (SELECT job_id FROM employee WHERE fname='Helen' AND lname='Bennett');