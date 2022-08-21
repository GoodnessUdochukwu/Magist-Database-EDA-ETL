USE publications;

/* 1. Select everything from the table authors	*/ 
SELECT *
FROM authors;


/* 2. Select the authors first and last name	*/
SELECT au_lname, au_fname
FROM authors;


/* 3. Select the first name and the last name and merge them in one column by using the CONCAT() function	*/
SELECT CONCAT(au_lname, ' ', au_fname) AS full_name
FROM authors;


/* 4. Select the distinct first names in authors	*/
SELECT DISTINCT au_fname
FROM authors;


/* 5. Select first and last name from authors who have the last name "Ringer"	*/
SELECT au_lname, au_fname
FROM authors
WHERE au_lname = 'Ringer';


/* 6. Select first and last name from authors whose last name is "Ringer" and fist name is "Anne"	*/
SELECT au_lname, au_fname
FROM authors
WHERE au_lname = 'Ringer' AND au_fname = 'Anne';


/* 7. Select first name, last name, and city from authors whose city is "Oakland" or "Berkeley", and first name is "Dean"	*/
SELECT au_lname, au_fname, city
FROM authors
WHERE (city = 'Berkeley' OR city = 'Oakland') AND au_fname = 'Dean'; /* WHERE city IN ('Berkeley', 'Oakland') AND au_fname: This syntax can be used */


/* 8. Select first, last name, and city from authors whose city is "Oakland" or "Berkeley", and last name is NOT "Straight"	*/
SELECT au_lname, au_fname, city
FROM authors
WHERE au_lname != 'Straight' AND (city = 'Oakland' OR city = 'Berkeley');


/* 9. Select the title and ytd_sales from the table titles. Order them by the year to date sales in descending order	*/
SELECT title, ytd_sales
FROM titles
ORDER BY ytd_sales DESC;


/* 10. Select the top 5 titles with the most ytd_sales from the table titles	*/
SELECT *
FROM titles
ORDER BY ytd_sales DESC
LIMIT 5;


-- Select the minimum and maximum quantity in table sales.
/* 11.*/
SELECT MAX(qty)
FROM sales;


/* 12.	*/
SELECT MIN(qty)
FROM sales;


-- Select the count, average and sum of quantity in the table sales
/* 13. */
SELECT COUNT(qty)
FROM sales;


/* 14. */
SELECT AVG(qty)
FROM sales;


/* 15. */
SELECT SUM(qty)
FROM sales;


/* 16. Select all books from the table title that contains the word "cooking"	*/
SELECT title
FROM titles
WHERE title LIKE '%cooking%';


/* 17. Select all books that have an "ing" in the title, with at least 4 other characters preceding it
for example 'cooking' has 4 characters before the 'ing', so this should be included
'sewing' has only 3 characters before the 'ing', so this shouldn't be included	*/
SELECT title
FROM titles
WHERE title LIKE '%ing%';


/* 18. Select all the authors from the author table that do not come from the cities Salt Lake City, Ann Arbor, and Oakland.	*/
SELECT *
FROM authors
WHERE city NOT IN ('Salt Lake City', 'Ann Arbor', 'Oakland');


/* 19. Select all the order numbers with a quantity sold between 25 and 45 from the table sales	*/
SELECT ord_num
FROM sales
WHERE qty BETWEEN 25 AND 45;


/* 20. Select all the orders between 1993-03-11 and 1994-09-13	*/
SELECT *
FROM sales
WHERE ord_date BETWEEN '1993-03-11' AND '1994-09-13';


/* 21. Select first 5 orders between 1993-03-11 and 1994-09-13	*/
SELECT *
FROM sales
WHERE ord_date BETWEEN '1993-03-11' AND '1994-09-13'
ORDER BY qty DESC
LIMIT 5;


/* 22. How many authors have an "i" in their first name, and have the state UT, MD, or KS */
SELECT COUNT(*)
FROM authors
WHERE au_fname LIKE '%i%' AND state IN ('UT', 'MD', 'KS');


/* 23. Select the total sum of ytd_sales of the top 5 titles from titles with a lower royalty, between a price of 15 to 25 */
SELECT SUM(ytd_sales)
FROM titles
WHERE price BETWEEN 15 AND 25
ORDER BY royalty DESC
LIMIT 5;


# 24. Select the total count of authors by each state 
SELECT state, COUNT(*)
FROM authors
GROUP BY state;


# 25. Select the total count of authors by each state and order them descinding
SELECT state, COUNT(*)
FROM authors
GROUP BY state
ORDER BY COUNT(*) DESC;


# 26. Select the maximum price for each publisher id in the table titles.
SELECT pub_id, MAX(price)
FROM titles
GROUP BY pub_id;


# 27. Find out top 3 stores with more sales
SELECT sales.stor_id, stores.stor_name, SUM(qty)
FROM sales
JOIN stores
ON sales.stor_id = stores.stor_id
GROUP BY stor_id
ORDER BY SUM(qty) DESC
LIMIT 3;


# 28. Select for each publisher the total number of titles for each book type with an average price higher than 12
SELECT publishers.pub_name, titles.type, COUNT(title), AVG(price)
FROM publishers
JOIN titles
ON titles.pub_id = publishers.pub_id
GROUP BY titles.type, publishers.pub_name
HAVING AVG(price) > 12;


# 29. Select for each publisher the total number of titles for each book type with an average price higher than 12 and order them by the average
SELECT publishers.pub_name, titles.type, COUNT(title)
FROM titles
JOIN publishers
ON titles.pub_id = publishers.pub_id
GROUP BY titles.type, publishers.pub_name
HAVING AVG(price) > 12
ORDER BY AVG(price);


/* 30. Select all the states and cities that contains more than 1 contract */
SELECT state, city, SUM(contract)
FROM authors
GROUP BY state, city
HAVING SUM(contract) > 1 
ORDER BY city;


# 31. Create a new column called "sales_category" with case conditions to categorise qty in sales table
/*ALTER TABLE sales
DROP COLUMN sales_category;*/
SELECT *,
CASE
    WHEN qty >= 50 THEN 'high sales'
    WHEN qty >= 20 AND qty < 50 THEN 'medium sales'
    WHEN qty < 20 THEN 'low sales'
END AS sales_category
FROM sales;


# 32. Find out the total amount of books sold (qty) by each sale category created with CASE
SELECT SUM(qty),
CASE
    WHEN qty >= 50 THEN 'high sales'
    WHEN qty >= 20 AND qty < 50 THEN 'medium sales'
    WHEN qty < 20 THEN 'low sales'
END AS sales_category
FROM sales
GROUP BY sales_category
HAVING SUM(qty) > 100
ORDER BY SUM(qty);


# 33. In California, how many authors are there in cities containing an "o" in the name?
# Show only results for cities with more than 1 author.
# Sort the cities ascendingly by author count.
SELECT state, city, COUNT(*)
FROM authors
WHERE state = 'CA' AND city LIKE '%o%'
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY COUNT(*);


# 34. 
SELECT publishers.pub_name, titles.type, COUNT(*), AVG(price),
CASE
    WHEN price > 15 THEN 'high'
    WHEN price > 10 AND price <= 15 THEN 'medium'
    WHEN price > 5 AND price <= 10 THEN 'low'
    WHEN price <= 5 THEN 'super low'
END AS price_category
FROM publishers
JOIN titles
ON titles.pub_id = publishers.pub_id
WHERE type IN ('business', 'trad_cook', 'psychology')
GROUP BY publishers.pub_id, titles.type, price_category
ORDER BY publishers.pub_name;


# 35. Find out the average price for each publisher and price category for the following book types: 
# * business, traditional cook and psychology
# * price categories: <= 5 super low, <= 10 low, <= 15 medium, > 15 high
SELECT pub_id, type,
    CASE
        WHEN price <= 5 THEN "super low"
        WHEN price <= 10 THEN "low"
        WHEN price <= 15 THEN "medium"
        ELSE "high"
    END AS price_cat,
    AVG(price)
FROM titles
WHERE type IN ("business",  "trad_cook", "psychology")
GROUP BY pub_id, price_cat, type;


# 36. Change the column name qty to Quantity into the sales table
SELECT *, qty AS 'Quantity'
FROM sales;

# 37. Assign a new name into the table sales, and call the column order number using the table alias
SELECT *, s.ord_num
FROM sales AS s;

SELECT * 
FROM stores s 
LEFT JOIN discounts d ON d.stor_id = s.stor_id;

SELECT * 
FROM stores s 
RIGHT JOIN discounts d ON d.stor_id = s.stor_id;

-- INNER JOIN
SELECT * 
FROM stores s 
INNER JOIN discounts d ON d.stor_id = s.stor_id;


# 38. In which cities has "Is Anger the Enemy?" been sold?
SELECT *
FROM titles t
LEFT JOIN sales s ON t.title_id = s.title_id
RIGHT JOIN stores st ON s.stor_id = st.stor_id
WHERE title LIKE '%Is Anger the Enemy?%';


# 39. Select all the books (and show their title) where the employee Howard Snyder had work.
SELECT *
FROM employee e
JOIN publishers p
ON e.pub_id = p.pub_id
WHERE e.fname = 'Howard' AND e.lname = 'Snyder';


# 40. 
SELECT publishers.pub_name, titles.type, COUNT(*), AVG(price),
CASE
        WHEN price <= 5 THEN "super low"
        WHEN price <= 10 THEN "low"
        WHEN price <= 15 THEN "medium"
        ELSE "high"
END AS price_category
FROM publishers
JOIN titles
ON titles.pub_id = publishers.pub_id
WHERE type IN ('business', 'trad_cook', 'psychology')
GROUP BY publishers.pub_id, titles.type, price_category
ORDER BY publishers.pub_name;

# Select all the authors that have work (directly or indirectly)
# with the employee Howard Snyder
SELECT a.au_lname, a.au_fname, e.fname, e.lname
FROM authors a
INNER JOIN titleauthor ta ON a.au_id = ta.au_id
INNER JOIN titles t ON ta.title_id = t.title_id
INNER JOIN publishers p ON t.pub_id = p.pub_id
INNER JOIN employee e ON p.pub_id = e.pub_id
WHERE e.fname = "Howard" AND e.lname = "Snyder";
# Select the book title with higher number of sales (qty)
SELECT s.title_id, t.title, SUM(s.qty) AS qty
FROM sales AS s
RIGHT JOIN titles AS t ON s.title_id = t.title_id
GROUP BY s.title_id, t.title
ORDER BY SUM(s.qty) DESC
LIMIT 1;

WITH res AS (SELECT pub_id, hire_date FROM employee e WHERE e.fname = 'Howard' AND e.lname = 'Snyder')
	SELECT t.title, t.pubdate, t.pub_id, t.type
    FROM titles t
    RIGHT JOIN res
    ON res.pub_id = t.pub_id;
    

















