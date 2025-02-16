/*

*******************************************************************************
*******************************************************************************

SQL CHALLENGES 6

*******************************************************************************
*******************************************************************************

HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + R
* MacOS: Cmd + R

In the exercises below you will need to use the clauses you used in the
previous SQL Challenges, plus the following clauses:
    - AS
	- LEFT JOIN
    - RIGHT JOIN
    - INNER JOIN
*/

USE publications; 
 
/*******************************************************************************
ALIAS (AS) for tables
*******************************************************************************/

/* 1. Select the table sales, assigning the alias "s" to it. 
   Select the column ord_num using the syntax "table_alias.column" */

SELECT s.ord_num, s.qty as quantity
FROM sales AS s;

/*******************************************************************************
JOINS

We will only use LEFT, RIGHT, and INNER joins.
You do not need to worry about the other types for now

- https://www.w3schools.com/sql/sql_join.asp
- https://www.w3schools.com/sql/sql_join_left.asp
- https://www.w3schools.com/sql/sql_join_right.asp
- https://www.w3schools.com/sql/sql_join_inner.asp
*******************************************************************************/

-- 2. Select the title and publisher name of all books

SELECT publishers.pub_name, titles.title
FROM titles
LEFT JOIN publishers 
ON titles.pub_id = publishers.pub_id;

SELECT publishers.pub_name, titles.title
FROM titles
LEFT JOIN publishers 
USING(pub_id);
-- 4. Select the order number, quantity and book title for all sales.

SELECT sales.ord_num, sales.qty, titles.title FROM sales JOIN titles USING(title_id);

/* 5. Select the full name of all employees and the name of the publisher they 
   work for */

SELECT employee.fname, employee.lname, pub_name FROM employee JOIN publishers USING(pub_id);

-- 6. Select the full name and job description of all employees.

SELECT employee.fname, employee.lname, job_desc FROM employee JOIN jobs USING(job_id);

/* 7. Select the full name, job description and publisher name of all employees
   Hint: you will have to perform 2 joins in a single query to merge 3 tables 
         together. */

SELECT employee.fname, employee.lname, job_desc, pub_name
FROM employee 
LEFT JOIN jobs using(job_id) 
LEFT JOIN publishers USING(pub_id);

/* 8. Select the full name, job description and publisher name of employees
   that work for Binnet & Hardley.
   Hint: you can add a WHERE clause after the joins */

SELECT employee.fname, employee.lname, job_desc, pub_name
FROM employee 
LEFT JOIN jobs using(job_id) 
LEFT JOIN publishers USING(pub_id)
WHERE pub_name='Binnet & Hardley';

/* 9. Select the name and PR Info (from the pub_info table) from all publishers
   based in Berkeley, California. */

SELECT pub_name, pr_info, city, state
FROM publishers
LEFT JOIN pub_info
USING(pub_id)
WHERE city='Berkeley' AND state='CA';

/* 10. Select all columns from the discounts table.
   Observe the columns it has and now some of them are filled with NULL values.
*/

SELECT * FROM discounts;

/* 11. Select all store names, their store id and the discounts they offer.

	   - When selecting the store id, select it two times: from the stores table
         and from the discounts table.
         
       - ALL stores should be displayed, even if they don't offer any discount 
         (i.e. have a NULL value on the discount column). */

SELECT
    stor_name, s.stor_id, d.stor_id, discounttype, discount
FROM
    stores AS s
        LEFT JOIN
    discounts AS d
    on (s.stor_id = d.stor_id or d.stor_id is null);

SELECT * FROM discounts;
SELECT * FROM stores;
/* 12. Select all store names and the discounts they offer.

       - This time, we don't want to display stores that don't offer any 
         discount.
         
   Hint: change the join type! */


