# company sales analysis 
In this portfolio project, I tried to analyze the data of the AtliQ Hardware using SQL and show my SQL skills. 
AtliQ hardwer is a company Which supplies computer hardware and peripharals to thier clients
their head office is in Delhi India and they have a lot of regional offices throughout the india and thier market is growing dynamically and they have some issue in  tracking the sales in diffrent regions and they have this database collectin sales data that im gonna use analayze

### Why did I choose this database ? 

This is real world project with real world database and the owners facsing a real challenge to slove شnd I said that it would be good to use this database that comes from a real environment to show my skills

### Project Overwiew : 

### 1 - Cleaning data :

#### 1 - Drop records with sales amount below 0
#### 2 - Equalization and conversion of currencies
       --  1 ) Unification of currencies by removing spaces and prepositions
      ---  2 ) Covert USD TO INR by Using the average exchange rate of rupees per year (2017,2018,2019,2020)
      ---  3 ) Update currency Into INR Where currency = USD 
      ---  4 ) Create new transaction tabel and insert data into it     
#### 3 - Drop uneeded uncleand_transaction tabel

#### 4 - Rename cleaned transactions table

#### 5 - Update zones outside of india from null to 'Outside India'

### 2 - Analayzing data :

#### 1  -  Describe tabels (null values , foreign key , dtypes ...)
#### 2  -  First 10 rows of tables
#### 3  -  Number of rows in each table 

#### 6 -  All unique Payment currency + count 


#### 10 - Total sales amount and total sales quantity


#### 11 -  Market_codes total sales quantity and total sales amount in total sales amount desc order 


#### 12 -  TotaL sales amount and percentage for each markets_name


#### 13 -  Top 10 customer with sales amount and total sales quantity


#### 14 -  Top 5 product with sales amount and sales quantity


#### 15 -  All unique market zones 


#### 16 -  Update zones outside of india from null to 'Outside India'


#### 17 -  Top market sales in each zone 


#### 18 -  Yearly sales amount,sales quantity


#### 19 -  Last 7 days sales_amount sales_qty 


#### 20 -  Minimum | Avarage | Maximum  sales_amount 


#### 21 -  Apply statistic 
      -  1 - Get Mean of sales_qty and sales_amount 
      -  2 - Get Varince of sales_qty and sales_amount  (Varince = AVG((x1 - x1.mu)**2)))
      -  3 - Get Standard Deviation of sales_qty and sales_amount Sqrt(AVG((x1-x1.mu)**2)) )
      -  4 - Get Covariance between sales_qty and sales_amount  (COV = AVG((x1 - x1.mu)*(x2-x2.mu)))
      -  5 - Get Correlation Coefficient between sales_qty and sales_amount (CORR =  COV(x1,x2) / [std(x1)*std(x2)] )


#### 22 -  Extract customer name by spliting custmer_name column 


#### 23 -  Yealry sales amount diffrance (delta)


#### 24 -  monthley sales amount precnt diffreance (delta)
