--1
-- Tüm müşterileri tarifelerle beraber listeledim. tarife adı kobiye destek olanları listeledim. kayıt tarihini yükselen olarak ayarlayım en düşük olanları en üste getirip 1 tanesini seçtim.
SELECT * FROM CUSTOMERS c
JOIN TARIFFS t ON t.TARIFF_ID =c.TARIFF_ID 
WHERE t.TARIFF_NAME ='Kobiye Destek'
ORDER BY SIGNUP_DATE ASC FETCH FIRST 1 ROWS ONLY ; 

--2
--tarife ismi ve sayılarını göstermek için değerleri girdim. tarife isimlerini almak için joinle tabloları bağladım. azalana göre sıraladım. 
SELECT TARIFF_NAME, COUNT(*)  AS TARIFF_COUNT FROM CUSTOMERS c
JOIN TARIFFS t ON t.TARIFF_ID =c.TARIFF_ID 
GROUP BY t.TARIFF_NAME ORDER BY TARIFF_COUNT Desc;

--3
--ilk müşteriler olarak ilk 200 tanesini varsaydım. bunu da artan(asc) ile signup_date verisi ile çektim. daha sonra şehir ve dağılım sayısını ekrana göstermek için şehre göre gruplayıp dağılıma göre sıraya dizdim.
SELECT CITY , Count(*) AS distribution FROM (
	SELECT * FROM CUSTOMERS 
	ORDER BY SIGNUP_DATE asc 
	FETCH FIRST 200 ROWS ONLY
	)
GROUP BY CITY
ORDER BY distribution;

--4
--monthly stats tablosundaki idler ile müşteri idleri aynı. buna göre monthly_stats tablosunda olmayan müşteri idlerini çektim. ve ortaya çıkan sonucu şehirlere göre grupladım.
SELECT CUSTOMER_ID FROM CUSTOMERS WHERE CUSTOMER_ID  NOT IN (SELECT ID FROM MONTHLY_STATS);

SELECT CITY, Count(*) AS MISSING_COUNT FROM CUSTOMERS c 
WHERE NOT EXISTS (SELECT * FROM MONTHLY_STATS m WHERE m.ID = c.CUSTOMER_ID  )
GROUP BY CITY ORDER BY MISSING_COUNT desc;


--5
-- yapay zekaya yaptırdım.
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

