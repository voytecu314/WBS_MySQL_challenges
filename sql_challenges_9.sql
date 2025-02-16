/******************************************************************************
*******************************************************************************

SQL CHALLENGES 9

*******************************************************************************
******************************************************************************/


USE publications;


-- 1. Add a column showing how many characters are in each author's last name

SELECT *, LENGTH(au_lname)*100 as surname_length FROM authors;

-- 2. What is the first name of each author in uppercase?

SELECT UPPER(au_fname)as NAME FROM authors;

-- 3. Combine first and last names of authors into a single column.

SELECT UPPER(CONCAT(au_fname,' ',au_lname)) as full_name FROM authors;

-- 4. Show the current date in a column called 'today'.

SELECT DATE_FORMAT(CURRENT_DATE(), 'DAY: %d, MONTH: %m, YEAR: %y') AS today;

-- 5. Calculate the difference in days between a book's publication date and today's date.

SELECT pubdate, CURRENT_DATE(), DATEDIFF(CURRENT_DATE(), pubdate) as days_ago FROM titles;

-- 6. How many years has it been since each title was published?
    
SELECT pubdate, CURRENT_DATE(), TIMESTAMPDIFF(YEAR,pubdate,CURRENT_DATE()) as years_ago FROM titles;
    
-- 7. Find the publication year and month of each title in 'YYYY-MM' format.   

SELECT title, DATE_FORMAT(pubdate,'%Y-%m')
FROM titles
LEFT JOIN publishers
USING(pub_id);

-- 8. Concatenate the publisher's name and city into a single column. Separate them with a comma.

SELECT CONCAT(pub_name,', ',city) as name_and_city FROM publishers;

-- 9. What is the longest title of a book?
SELECT title,LENGTH(title) as letters FROM titles ORDER BY letters DESC LIMIT 1;

-- 10. Display the publication date of each title in 'Day-Month-Year' format. For example, '12-June-1991'.
  
  SELECT title, DATE_FORMAT(pubdate,'%d-%M-%Y') FROM titles;
    
-- 11. List authors whose last name starts with 'C' and show the first 5 characters of their address.
 SELECT au_fname, au_lname, SUBSTRING(address,1,5) from authors WHERE SUBSTRING(au_lname,1,1)='C' ;

-- 12. Return the difference in days between the current date and the publication date of titles where the difference is greater than 1000 days.
SELECT pubdate, CURRENT_DATE(), DATEDIFF(CURRENT_DATE(), pubdate) as days_ago FROM titles WHERE DATEDIFF(CURRENT_DATE(), pubdate)>1000;

-- 13. Find the titles where the length of the title name is greater than the average length of all titles.
WITH average_title_length AS
(SELECT AVG(LENGTH(title)) FROM titles)
SELECT title,LENGTH(title) FROM titles WHERE LENGTH(title)>(SELECT AVG(LENGTH(title)) FROM titles);

-- 14. Get the authors whose first name length is equal to their last name length.
   SELECT au_fname f, au_lname l FROM authors WHERE LENGTH(au_fname) = LENGTH(au_lname);

-- 15. Find the longest city name among the authors' addresses.
SELECT DISTINCT city FROM authors WHERE LENGTH(city)=(SELECT MAX(LENGTH(city)) FROM authors);

-- 16. Display titles and their publication dates formatted as 'Day of the Week, Month Day, Year'. For example, 'Wednesday, June 12, 1991'.
SELECT title, DATE_FORMAT(pubdate,'%W, %d %M, %Y') FROM titles;

-- 17. Calculate the difference in days between the first and last publication date for each author.
WITH from_to AS (SELECT au_lname, MIN(t_a.pubdate) as earliest_publication, MAX(t_a.pubdate) latest_publication
FROM authors
JOIN (SELECT title, pubdate, au_id FROM titleauthor LEFT JOIN titles t USING(title_id)) as t_a USING(au_id)
GROUP BY au_lname)
SELECT au_lname, DATEDIFF(latest_publication, earliest_publication) as days_difference FROM from_to;