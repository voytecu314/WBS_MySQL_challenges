/******************************************************************************
*******************************************************************************

SQL CHALLENGES 10

*******************************************************************************
******************************************************************************/


USE publications;


-- 1. What's the difference between highest and lowest price of titles
SELECT MAX(price)-MIN(price) as price_diff FROM titles;

-- 2. Find titles where the total number of books sold is an even number.
WITH titles_id_sold_even AS (SELECT title_id, SUM(qty) as amount FROM sales
GROUP BY title_id
HAVING amount%2 = 0)
SELECT title, titles_id_sold_even.amount FROM titles_id_sold_even
JOIN titles USING(title_id);

-- 3. Calculate the total revenue by multiplying the quantity sold by the price for each title.

WITH prices_table AS (WITH title_id_qty_sold AS (SELECT title_id, SUM(qty) as qty FROM sales
GROUP BY title_id)
SELECT title, price, title_id_qty_sold.qty, ROUND(price * title_id_qty_sold.qty,2) as total_price
FROM title_id_qty_sold
JOIN titles USING(title_id))
SELECT sum(total_price) FROM prices_table;

-- 4. Cheryl Carson and Charlene Locksley got married, what is their collective revenue?
WITH married_prices AS (SELECT au_lname, au_fname, price FROM authors
JOIN titleauthor USING(au_id)
JOIN titles USING(title_id)
WHERE (au_fname='Cheryl' AND au_lname='Carson') OR (au_fname='Charlene' AND au_lname='Locksley'))
SELECT SUM(price) as collective_revenue FROM married_prices;

SELECT price FROM titles;
SELECT * FROM roysched;

SELECT au_fname, au_lname, title, price, titles.royalty, roysched.royalty, qty FROM sales
JOIN titles USING(title_id)
JOIN roysched USING(title_id)
JOIN titleauthor USING(title_id)
JOIN authors USING(au_id)
WHERE (au_fname='Cheryl' AND au_lname='Carson') OR (au_fname='Charlene' AND au_lname='Locksley');
    
-- 5. Calculate the total number of books published by the publishers '0736' and '0877':
SELECT count(*) as published FROM titles WHERE pub_id = '0736' OR pub_id='0877';

-- 6. Find all of the books that are more than 10% above the average price of a book in the dataset

SELECT title, ROUND(price,2) as price FROM titles
WHERE price> 0.1*(SELECT AVG(price) FROM titles)+(SELECT AVG(price) FROM titles);
