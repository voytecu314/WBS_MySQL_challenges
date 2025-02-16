/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 7

*******************************************************************************
*******************************************************************************


In the exercises below you will need to use the clauses you used in the
previous SQL Challenges, plus the following clauses:
    - CASE
*/

/*******************************************************************************
CASE

https://www.w3schools.com/sql/sql_case.asp
*******************************************************************************/

/* 1. Select everything from the sales table and create a new column called 
   "sales_category" with case conditions to categorise qty:
   
		qty >= 50 high sales
		20 <= qty < 50 medium sales
		qty < 20 low sales
*/

SELECT *,
CASE
	WHEN qty >= 50 THEN 'high sales'
    WHEN qty BETWEEN 20 AND 50 THEN 'medium sales'
    ElSE 'low sales'
END AS sales_category
FROM sales;

SELECT ord_num, sum(qty) as sale_amount,
CASE
	WHEN sum(qty) >= 50 THEN 'high sales'
    WHEN sum(qty) BETWEEN 20 AND 50 THEN 'medium sales'
    ElSE 'low sales'
END AS sales_category
FROM sales
GROUP BY ord_num;
/* 2. Given your three sales categories (high, medium, and low), 
   calculate the total number of books sold in each category. 
*/

SELECT 
CASE
	WHEN qty >= 50 THEN 'high sales'
    WHEN qty BETWEEN 20 AND 50 THEN 'medium sales'
    ElSE 'low sales'
END AS sales_category, SUM(qty)
FROM sales
GROUP BY sales_category;

/* 3. Adding to your answer from the previous questions: output only those 
   sales categories that have a SUM(qty) greater than 100, and order them in 
   descending order */

SELECT 
CASE
	WHEN qty >= 50 THEN 'high sales'
    WHEN qty BETWEEN 20 AND 50 THEN 'medium sales'
END AS sales_category, SUM(qty) AS sum
FROM sales
GROUP BY sales_category
ORDER BY sales_category DESC;

/* 4. Find out the average book price, per publisher, for the following book 
    types and price categories:
		book types: business, traditional cook and psychology
		price categories: <= 5 super low, <= 10 low, <= 15 medium, > 15 high
        
    - When displaying the average prices, use ROUND() to hide decimals. */

SELECT p.pub_name, ROUND(AVG(t.price),2) as avg_price,
	CASE
		WHEN ROUND(AVG(t.price),2) <= 5 THEN 'super low'
        WHEN ROUND(AVG(t.price),2) <= 10 THEN 'low'
        WHEN ROUND(AVG(t.price),2) <= 15 THEN 'medium'
        WHEN ROUND(AVG(t.price),2) > 15 THEN 'high'
    END AS price_category
FROM publishers AS p
LEFT JOIN titles AS t
USING(pub_id)
GROUP BY p.pub_name;