 
-- Meysam Raz SQL Portfolio Project --
-- Atliq Hardware sales analysis --
-- Mysql Versoin : 8.0.27 --
-- Tables : customers,markets,products,transactions --

-------------------------  OVERVIEW  --------------------------------

-- 1  -  Describe tabels (null values , foreign key , dtypes ...)


-- 2  -  First 10 rows of tables


-- 3  -  Number of rows in each table 


-- 4  -  Drop records with sales amount below 0


-- 5  -  Drop uneeded uncleand_transaction tabel


-- 6  -  All unique Payment currency + count 


-- 7  -  Equalization and conversion of currencies
      ---  1 ) Unification of currencies by removing spaces and prepositions
      ---  2 ) Covert USD TO INR by Using the average exchange rate of rupees per year (2017,2018,2019,2020)
      ---  3 ) Update currency Into INR Where currency = USD 
      ---  4 ) Create new transaction tabel and insert data into it


-- 8  -  Drop tempary transaction tables


-- 9  - Rename cleaned transactions table


-- 10 - Total sales amount and total sales quantity


-- 11 -  Market_codes total sales quantity and total sales amount in total sales amount desc order 


-- 12 -  TotaL sales amount and percentage for each markets_name


-- 13 -  Top 10 customer with sales amount and total sales quantity


-- 14 -  Top 5 product with sales amount and sales quantity


-- 15 -  All unique market zones 


-- 16 -  Update zones outside of india from null to 'Outside India'


-- 17 -  Top market sales in each zone 


-- 18 -  Yearly sales amount,sales quantity


-- 19 -  Last 7 days sales_amount sales_qty 


-- 20 -  Minimum | Avarage | Maximum  sales_amount 


-- 21 -  Apply statistic 
      ---  1 - Get Mean of sales_qty and sales_amount 
      ---  2 - Get Varince of sales_qty and sales_amount  (Varince = AVG((x1 - x1.mu)**2)))
      ---  3 - Get Standard Deviation of sales_qty and sales_amount Sqrt(AVG((x1-x1.mu)**2)) )
      ---  4 - Get Covariance between sales_qty and sales_amount  (COV = AVG((x1 - x1.mu)*(x2-x2.mu)))
      ---  5 - Get Correlation Coefficient between sales_qty and sales_amount (CORR =  COV(x1,x2) / [std(x1)*std(x2)] )


-- 22 -  Extract customer name by spliting custmer_name column 


-- 23 -  Yealry sales amount diffrance (delta)


-- 24 -  monthley sales amount precnt diffreance (delta)

---------------------------------------------------------


-- 1  -  Describe tabels (null values , foreign key , dtypes ...)


--- Describe customers table
DESC customers;

-- customer_code  -  varchar(45)
----------------------------------
-- custmer_name   -  varchar(45)
----------------------------------
-- customer_type  -  varchar(45)


----------------------------------

--- Describe markets table
DESC markets;

-- customer_code  -  varchar(45)
----------------------------------
-- markets_name   -  varchar(45)
----------------------------------
-- zone           -  varchar(45)


----------------------------------

--- Describe products table
DESC products;

-- product_code   -  varchar(45)
----------------------------------
-- product_type   -  varchar(45)

---------------------------------- 

--- Describe transactions table

DESC transactions;

-- product_code   -  varchar(45)
----------------------------------
-- customer_code  -  varchar(45)
----------------------------------
-- market_code    -  varchar(45)
----------------------------------
-- order_date     -  date
----------------------------------
-- sales_qty      -  int
----------------------------------
-- sales_amount   -  double


----------------------------------

-- 2 - Get first 10 rows of tables
SELECT * 
FROM customers 
LIMIT 10;

SELECT * 
FROM markets 
LIMIT 10;

select * 
FROM products 
LIMIT 10;

SELECT * 
FROM transactions 
LIMIT 10;

----------------------------------

-- 3  -  Number of rows in each table 
SELECT (SELECT COUNT(*) FROM customers) AS customers_row_count,
       (SELECT COUNT(*) FROM markets) AS markets_row_count,
       (SELECT COUNT(*) FROM products) AS products_row_count,
       (SELECT COUNT(*) FROM transactions) AS transactions_row_count;

----------------------------------

-- 4  -  Drop records with sales amount below 0

CREATE TABLE transactions_2 LIKE transactions;

INSERT INTO transactions_2 SELECT * FROM transactions WHERE sales_amount >= 0; 

SELECT * FROM transactions_2;

----------------------------------

-- 5  -  Drop uneeded uncleand_transaction tabel
DROP TABLE transactions;

----------------------------------

-- 6  -  Get all unique Payment currency + count 
SELECT currency,COUNT(*) FROM transactions GROUP BY currency;

----------------------------------

-- 7  -  Equalization and conversion of currencies :
      ---  1 ) Unification of currencies by removing spaces and prepositions
      ---  2 ) Covert USD TO INR by Using the average exchange rate of rupees per year (2017,2018,2019,2020)
      ---  3 ) Update currency Into INR Where currency = USD 
      ---  4 ) Create new transaction tabel and insert data into it


--- Unification of currencies by removing spaces and prepositions
CREATE TABLE transactions_3 AS 
WITH cleaned_curr AS (
    SELECT product_code,customer_code,market_code,order_date,sales_qty,sales_amount,CASE 
        WHEN currency LIKE '%USD%' THEN 'USD'
        WHEN currency LIKE '%INR%' THEN 'INR'
        END AS currency
    FROM transactions_2
),
--- Covert USD TO INR by Using the average exchange rate of rupees per year (2017,2018,2019,2020)
xchange_currecy AS (
    SELECT product_code,customer_code,market_code,order_date,sales_qty,currency,CASE 
        WHEN currency = 'USD' AND  YEAR(order_date) = 2017 THEN  ROUND(sales_amount * 65.0966)
        WHEN currency = 'USD' AND  YEAR(order_date) = 2018 THEN  ROUND(sales_amount * 68.4113)
        WHEN currency = 'USD' AND  YEAR(order_date) = 2019 THEN  ROUND(sales_amount * 70.4059)
        WHEN currency = 'USD' AND  YEAR(order_date) = 2020 THEN  ROUND(sales_amount * 74.1322)
        ELSE sales_amount
        END AS sales_amount
    FROM cleaned_curr
)
SELECT * FROM xchange_currecy;

----------------------------------

--- Update currency Into INR Where currency = USD 

UPDATE transactions_3
SET currency='INR' WHERE currency = "USD";


--- Create new transaction tabel and insert data into it
CREATE TABLE transactions_4 AS 
SELECT * FROM transactions_3;

----------------------------------

-- 8  -  Drop tempary transaction tables
DROP TABLE transactions_2;
DROP TABLE transactions_2;
DROP TABLE transactions_3;
----------------------------------


-- 9  -  Rename cleaned transactions table
ALTER TABLE transactions_4
  RENAME TO transactions;
----------------------------------

-- 10  - Total sales amount and total sales quantity
SELECT SUM(sales_qty) AS "total sales quantity" ,SUM(sales_amount) AS "total sales amount" FROM transactions;

----------------------------------

-- 11 -  Market_codes total sales quantity and total sales amount in total sales amount desc order 

SELECT market_code,markets_name,zone,SUM(sales_qty) "total sales quantity",SUM(sales_amount) "total sales amount"
FROM transactions 
JOIN markets
ON market_code = markets_code
GROUP BY market_code
ORDER BY 5 DESC;

----------------------------------

-- 12 -  TotaL sales amount and percentage for each markets_name

SELECT markets_name , SUM(sales_amount) "total sales amount",
SUM(sales_amount) / (SELECT SUM(sales_amount) FROM transactions) * 100 "sales amount percentage"
FROM markets 
JOIN transactions
ON market_code = markets_code
GROUP BY 1
ORDER BY 2 DESC;

----------------------------------

-- 13 -  Top 10 customer with sales amount and total sales quantity

SELECT custmer_name , SUM(sales_amount) "total spent" ,SUM(sales_qty) "number of purchases"
FROM customers 
JOIN transactions 
USING  (customer_code)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

----------------------------------

-- 14 -  Top 5 product with sales amount and sales quantity

SELECT product_code, SUM(sales_amount) "sales amount",SUM(sales_qty) "sales quantity"
FROM transactions 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

----------------------------------

-- 15 -  All unique market zones 

SELECT DISTINCT zone FROM markets;  

----------------------------------

-- 16 -  Update zones outside of india from null to 'Outside India'

UPDATE markets
SET zone = 'Outside India'
WHERE markets_name IN ('New York','Paris');

----------------------------------

-- 17 -  Top market sales in each zone 

WITH rank_markets AS (
    SELECT markets_name,zone,SUM(sales_amount) total_sales_amount,
    ROW_NUMBER() OVER (PARTITION BY zone) sales_rank
    FROM markets
    JOIN transactions
    ON market_code = markets_code
    GROUP BY markets_name
)
SELECT markets_name,zone,total_sales_amount FROM rank_markets 
WHERE sales_rank = 1;

----------------------------------

 -- 17 - Get yearly sales_amount,total_sales_qty

SELECT YEAR(order_date),CONCAT(SUM(sales_amount)," INR") AS "total sales amount",SUM(sales_qty) AS "total sales quantity" 
FROM transactions
GROUP BY 1
ORDER BY 1 DESC;

----------------------------------

-- 19 -  Last 7 days sales_amount sales_qty 

SELECT SUM(sales_qty) 7_days_qny,SUM(sales_amount) 7_days_rev FROM transactions
WHERE order_date 
BETWEEN (SELECT DATE_SUB(MAX(order_date), INTERVAL 7 DAY) FROM transactions)
AND (SELECT MAX(order_date) FROM transactions);

----------------------------------

-- 20 -  Minimum | Avarage | Maximum  sales_amount 

SELECT MIN(sales_amount),ROUND(AVG(sales_amount)),MAX(sales_amount) FROM transactions;

----------------------------------

-- 21 -  Apply statistic 

---  1 - Get Mean of sales_qty and sales_amount 
---  2 - Get Varince of sales_qty and sales_amount  (Varince = AVG((x1 - x1.mu)**2)))
---  3 - Get Standard Deviation of sales_qty and sales_amount Sqrt(AVG((x1-x1.mu)**2)) )
---  4 - Get Covariance between sales_qty and sales_amount  (COV = AVG((x1 - x1.mu)*(x2-x2.mu)))
---  5 - Get Correlation Coefficient between sales_qty and sales_amount (CORR =  COV(x1,x2) / [std(x1)*std(x2)] )


--- Get Mean of sales_qty and sales_amount 
WITH Mean AS (
    SELECT 
      sales_qty,
      sales_amount,
      AVG(sales_qty) OVER() AS mean_x1,
      AVG(sales_amount) OVER() AS mean_x2
    FROM transactions
),
--- Get Varince of sales_qty and sales_amount  (Varince = AVG((x1 - x1.mu)**2)))
Variance AS (
    SELECT 
      AVG(POWER(sales_qty - mean_x1,2)) AS var_x1,
      AVG(POWER(sales_amount - mean_x2,2)) AS var_x2
    FROM Mean
),
--- Get Standard Deviation of sales_qty and sales_amount Sqrt(AVG((x1-x1.mu)**2)) )
StdDev AS (
    SELECT 
      POWER(var_x1,0.5) AS std_x1,
      POWER(var_x2,0.5) AS std_x2
    FROM Variance
),
--- Get Covariance between sales_qty and sales_amount  (COV = AVG((x1 - x1.mu)*(x2-x2.mu)))
Covariance AS (
    SELECT 
      AVG((sales_qty-mean_x1)*(sales_amount-mean_x2)) AS cov_x1_x2
    FROM Mean
)
--- Get Correlation Coefficient between sales_qty and sales_amount (CORR =  COV(x1,x2) / [std(x1)*std(x2)] )
SELECT cov_x1_x2 / (std_x1 * std_x2) AS corr_x1_x2
FROM Covariance, StdDev;

----------------------------------

-- 22 -  Extract customer name by spliting custmer_name column 
SELECT SUBSTRING_INDEX(custmer_name,' ',1) FROM customers;

----------------------------------

-- 23 -  Yealry sales amount diffrance (delta)
with TotalSales AS (
  SELECT year(order_date) year_sal,sum(sales_amount) rev 
  FROM transactions
  GROUP BY year(order_date)
)
SELECT year_sal "year",rev - LAG(rev) 
OVER (ORDER BY year_sal) "sales amount delta"
FROM TotalSales;

----------------------------------

-- 24 -  monthley sales amount precnt diffreance (delta)
WITH t1 AS (
  SELECT DATE_FORMAT(order_date,'%Y-%m') YM,SUM(sales_amount) total_rev
  FROM transactions
  GROUP BY YM
),
T2 AS (
  SELECT * , LAG(total_rev) OVER() AS Prevs
  FROM t1
)
SELECT YM "Year-Month",ROUND((total_rev-Prevs)/Prevs*100,2) "sales amount precnt"  FROM T2;

----------------------------------