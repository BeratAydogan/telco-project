--1. 1. Tariff-Based Customer Queries
--1.1 List the customers who are subscribed to the 'Kobiye Destek' tariff.
--1.2 Find the newest customer who subscribed to this tariff.

SELECT * FROM CUSTOMERS c
JOIN TARIFFS t ON t.TARIFF_ID =c.TARIFF_ID 
WHERE t.TARIFF_NAME ='Kobiye Destek'
ORDER BY SIGNUP_DATE ASC FETCH FIRST 1 ROWS ONLY ; 

--2. Tariff Distribution
--2.1 Find the distribution of tariffs among the customers.

SELECT TARIFF_NAME, COUNT(*)  AS TARIFF_COUNT FROM CUSTOMERS c
JOIN TARIFFS t ON t.TARIFF_ID =c.TARIFF_ID 
GROUP BY t.TARIFF_NAME ORDER BY TARIFF_COUNT Desc;

--3. Customer Signup Analysis
--3.1 Identify the earliest customers to sign up.
--(Hint: The earliest customers might not necessarily have the lowest IDs.)
--3.2 Find the distribution of these earliest customers across different cities, including the total count for each city.

SELECT CITY , Count(*) AS distribution FROM (
	SELECT * FROM CUSTOMERS 
	ORDER BY SIGNUP_DATE asc 
	FETCH FIRST 200 ROWS ONLY
	)
GROUP BY CITY
ORDER BY distribution;


--4. Missing Monthly Records
--4.1 Every customer has a monthly fee, and the dataset contains this month's usage values. However, an insertion error occurred, and some customers' monthly records are missing. Identify the IDs of these missing customers.

--4.2 Find the distribution of these missing customers across different cities.

SELECT CUSTOMER_ID FROM CUSTOMERS WHERE CUSTOMER_ID  NOT IN (SELECT ID FROM MONTHLY_STATS);

SELECT CITY, Count(*) AS MISSING_COUNT FROM CUSTOMERS c 
WHERE NOT EXISTS (SELECT 1 FROM MONTHLY_STATS m WHERE m.ID = c.CUSTOMER_ID  )
GROUP BY CITY ORDER BY MISSING_COUNT desc;


--5. Usage Analysis
--5.1 Find the customers who have used at least 75% of their data limit.
--5.2 Identify the customers who have completely exhausted all of their package limits (data, minutes, and SMS).

SELECT  c.CUSTOMER_ID, c.CUSTOMER_NAME, m.DATA_USAGE, t.DATA_LIMIT
FROM Customers c
JOIN Monthly_Stats m ON c.CUSTOMER_ID = m.ID
JOIN Tariffs t ON c.TARIFF_ID = t.TARIFF_ID
WHERE (m.DATA_USAGE / NULLIF(t.DATA_LIMIT, 0))>= 0.75;


SELECT c.CUSTOMER_ID, c.CUSTOMER_NAME, t.TARIFF_NAME
FROM Customers c
JOIN Monthly_Stats m ON c.CUSTOMER_ID = m.ID
JOIN Tariffs t ON c.TARIFF_ID = t.TARIFF_ID
WHERE m.DATA_USAGE = t.DATA_LIMIT AND m.MINUTE_USAGE = t.MINUTE_LIMIT AND m.SMS_USAGE = t.SMS_LIMIT;

