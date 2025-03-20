
                                         --RETAIL ANALYSIS--
								--DATA EXPLORATION AND PREPROCESSING--

create database RETAIL_ANALYSIS


USE RETAIL_ANALYSIS

-- CONVERTED EXCEL FILE TO CSV USING PYTHON AND THEN IMPORTED IT HERE

 


                                       --EXPLORE DATA--
SELECT TOP 15 * FROM DATA_RETAIL ;


                                                                               -- TOTAL NUMBER OF COLUMNS (15)
  select count(*) from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME ='DATA_RETAIL'

                                                                                             -- CHECK DATA TYPE OF EACH COLUMNS 
 SELECT COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DATA_RETAIL'



  /* COLUMNS WE NEED AS PER QUESTION STATEMENT PRODUCTiD,  PRICE, RATING, CATEGORY, PRODUCT_NAME , 
  DISCOUNT , SUPPLIER, RETURN_POLICY, STOCK_QUANTITY, REVIEWS   */

  -- DROPING SUPPLIER_CONTACT AS IT IS USED ONLY FOR COMMUNICATION , NOT RELEVENT

    -- PLACEHOLDER  SEEMS LIKE A DUMMY COLUMN  CAN BE CONSIDERED TO DROP
	
	-- SKU( STOCK KEEPING UNIT)   NOT USED IN ANY PROBLEM STATEMENT , MAINLY USED FORR INTERNAL TRACKING 

	-- WILL KEEP BRAND FOR FURTHUR ANALYSIS TO ANALYSE CUTOMER PREFERENCE ,BRAND PERFORMANCE  

 
 --INiTIATING DATA CLEANING 

   --  CREATING A BACKUP TABLE

   SELECT*INTO RETAILDATA_BACKUP FROM DATA_RETAIL
    SELECT * FROM RETAILDATA_BACKUP

-- DROPING COLUMN                    --holding on sku,warehouse,brand
  ALTER TABLE DATA_RETAIL
  DROP COLUMN Supplier_Contact
  ALTER TABLE DATA_RETAIL
  drop column Placeholder

    select * from DATA_RETAIL

  where Product_Name is null or Product_ID is null or Category is null or Stock_Quantity is null or Supplier is null
  or Discount is null or Rating is null or Reviews is null or SKU is null or Warehouse is null
  or Return_Policy is null or Brand is null or Price is null

 -- VARIFYING ALL NON NULL RECORDS 
   
SELECT COUNT(Product_Name) FROM DATA_RETAIL WHERE Product_Name IS NOT NULL;
SELECT COUNT(Product_ID) FROM DATA_RETAIL WHERE Product_ID IS NOT NULL;
SELECT COUNT(Category) FROM DATA_RETAIL WHERE Category IS NOT NULL;
SELECT COUNT(Stock_Quantity) FROM DATA_RETAIL WHERE Stock_Quantity IS NOT NULL;
SELECT COUNT(Supplier) FROM DATA_RETAIL WHERE Supplier IS NOT NULL;
SELECT COUNT(Discount) FROM DATA_RETAIL WHERE Discount IS NOT NULL;
SELECT COUNT(Rating) FROM DATA_RETAIL WHERE Rating IS NOT NULL;
SELECT COUNT(Reviews) FROM DATA_RETAIL WHERE Reviews IS NOT NULL;
SELECT COUNT(SKU) FROM DATA_RETAIL WHERE SKU IS NOT NULL;
SELECT COUNT(Warehouse) FROM DATA_RETAIL WHERE Warehouse IS NOT NULL;
SELECT COUNT(Return_Policy) FROM DATA_RETAIL WHERE Return_Policy IS NOT NULL;
SELECT COUNT(Brand) FROM DATA_RETAIL WHERE Brand IS NOT NULL;
SELECT COUNT(Price) FROM DATA_RETAIL WHERE Price IS NOT NULL;

-- NO NULL VALUE IN THE DATASET 


-- CHECKING DUPLICATE RECORDS 

SELECT Product_ID,Product_Name,count(*)  from DATA_RETAIL group by Product_ID,Product_Name
having count(*)>1

--APPROACH 2
   
WITH DUPLICATE_CTE AS
(SELECT *, ROW_NUMBER() OVER(PARTITION BY Product_Name, Product_ID, Category, Stock_Quantity, Supplier, Discount, Rating, Reviews,
SKU, Warehouse, Return_Policy, Brand, Price ORDER BY (SELECT NULL)) as ROW_NUM
                   FROM DATA_RETAIL)
SELECT * FROM DUPLICATE_CTE WHERE ROW_NUM > 1

---- NO DUPLICATE RECORDS 

SELECT * FROM DATA_RETAIL

-- CHECKING FOR INCORRECT OR INCONSISTENT DATA ENTRIES

-- PRODUCT NAME
select distinct(Product_Name) from DATA_RETAIL
 select Product_Name, count(*)as Countt from DATA_RETAIL group by Product_Name
  
  -- CATEGORY 
  SELECT DISTINCT(Category) FROM DATA_RETAIL
  SELECT Category,COUNT(*) AS COUNTT FROM DATA_RETAIL GROUP BY Category

  -- SUPPLIER
    SELECT DISTINCT(Supplier) FROM DATA_RETAIL
  SELECT Supplier,COUNT(*) AS COUNTT FROM DATA_RETAIL GROUP BY Supplier

  --WAREHOUSE
  SELECT DISTINCT(Warehouse) FROM DATA_RETAIL
  SELECT Warehouse,COUNT(*) AS COUNTT FROM DATA_RETAIL GROUP BY Warehouse

 --OTHER
 SELECT DISTINCT(SKU) FROM DATA_RETAIL
 SELECT DISTINCT(BRAND) FROM DATA_RETAIL
 SELECT DISTINCT(Return_Policy) FROM DATA_RETAIL

 SELECT Discount FROM DATA_RETAIL WHERE Discount <0 -- NO NEGATIVE VALUE 
 
 SELECT Price FROM DATA_RETAIL WHERE Price <0 
 SELECT Reviews FROM DATA_RETAIL WHERE Reviews <0

 SELECT Rating FROM DATA_RETAIL WHERE Rating <0 OR RATING >5 

 -- NO SIGNS OF INCORRECT OR INCONSISTENT DATA 


--  MODIFYING DATA TYPES 
SELECT MAX(Price) FROM DATA_RETAIL
SELECT MAX(Discount) FROM DATA_RETAIL

ALTER TABLE DATA_RETAIL
ALTER COLUMN Price DECIMAL(10,2)
ALTER TABLE DATA_RETAIL
ALTER COLUMN Discount DECIMAL(10,2)
ALTER TABLE DATA_RETAIL
ALTER COLUMN Stock_Quantity INT
ALTER TABLE DATA_RETAIL
ALTER COLUMN Rating DECIMAL(3 ,2)


SELECT* FROM DATA_RETAIL

SELECT COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME ='DATA_RETAIL'

-- FINDING outliers 

select * from DATA_RETAIL

select max(Stock_Quantity),min (Stock_Quantity),avg(Stock_Quantity) from DATA_RETAIL
select  from DATA_RETAIL
select max(Reviews),min (Reviews),avg(Reviews) from DATA_RETAIL
select max(Rating),min (Rating),avg(Rating) from DATA_RETAIL

select max(Price),min (Price),avg(Price) from DATA_RETAIL



select avg(Discount) + 2*STDEV(Discount) from DATA_RETAIL

select * from DATA_RETAIL
where Discount > (select avg(Discount) + 2*STDEV(Discount) from DATA_RETAIL)
or  Discount < (select avg(Discount) - 2*STDEV(Discount) from DATA_RETAIL)

-- not detected 
                     -- using iqr method 
WITH Percentiles AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Discount) 
            OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Discount) 
            OVER () AS Q3
    FROM DATA_RETAIL
)
SELECT * 
FROM DATA_RETAIL
WHERE Discount < (SELECT DISTINCT Q1 - 1.5 * (Q3 - Q1) FROM Percentiles) 
   OR Discount > (SELECT DISTINCT Q3 + 1.5 * (Q3 - Q1) FROM Percentiles);
  
   -- No outlier detected


                                                                           
																		   -- ANALYSIS


--Q > Identify products with prices higher than the average price within their category.


 select*from DATA_RETAIL

  SELECT Category,AVG(price) FROM DATA_RETAIL group by Category
  
SELECT category, product_name,  price
FROM DATA_RETAIL AS dr
WHERE price > (
    SELECT AVG(price) 
    FROM DATA_RETAIL 
    WHERE DATA_RETAIL.category = dr.category)
	
	  -- This following query returns products with prices higher than the average price within their category.



--Q > Finding Categories with Highest Average Rating Across Products. 

select * from DATA_RETAIL

SELECT  category, AVG(rating) AS avg_rating
FROM DATA_RETAIL
GROUP BY category
ORDER BY avg_rating DESC;         --  RATING AVERAGE overall category 


/*     -- category with product 
select top 3 Category, product_name,avg(rating) as Average_rating 
from DATA_RETAIL group by Category,Product_Name order by Average_rating desc  
*/


--Q > Find the most reviewed product in each warehouse

select * from DATA_RETAIL

SELECT Warehouse, Product_ID, Product_Name, Reviews
FROM (
    SELECT Warehouse, Product_ID, Product_Name, Reviews,
           RANK() OVER (PARTITION BY Warehouse ORDER BY Reviews DESC) AS rnk
    FROM Data_retail
) ranked
WHERE rnk = 1;




  -- Q Finding Products with Higher-Than-Average Prices Within Their Category, Along With Their Discount and Supplier


select * from DATA_RETAIL
  

  select Category, Product_Name,  Supplier,Discount,Price from DATA_RETAIL 
  where Price > (select avg(Price) from DATA_RETAIL d2 where DATA_RETAIL.Category=d2.Category )
  order by Price


 --varify lowest avg value    select avg(Price) from DATA_RETAIL WHERE Category='Clothing' 



 -- Q  > Query to find the top 2 products with the highest average rating in each category

 select * from DATA_RETAIL
 

 with Rankedproduct_cte as ( 

  select  Product_Name, Category, aVg(Rating) as AVG_RATING , row_number() over (partition by category order by avg(Rating) desc) as Rnk
  from DATA_RETAIL
  group by Category,Product_name
  )
  select Category,Product_Name, AVG_RATING from Rankedproduct_cte where Rnk <= 2
  order by Category desc, AVG_RATING desc



  --Q Analysis Across All Return Policy Categories (Count, Avgstock, total stock, weighted_avg rating, etc)



  select * from DATA_RETAIL

  SELECT Return_Policy, 
       COUNT(Product_ID) AS Product_Count, 
       AVG(Stock_Quantity) AS Avg_Stock, 
       SUM(Stock_Quantity) AS Total_Stock,
       SUM(Rating * Stock_Quantity) / NULLIF(SUM(Stock_Quantity), 0) AS Weighted_Avg_Rating,
       MIN(Price) AS Min_Price,
       MAX(Price) AS Max_Price,
       AVG(Price) AS Avg_Price,
       avg(Discount) AS Avg_Discount
FROM Data_retail
GROUP BY Return_Policy;

   select * from DATA_RETAIL

      
	  --------------------------------------------------------------------------------------------------------------------------------




	   



  /* Accurate interpretation of data:
By combining data analysis with domain expertise, analysts can provide actionable recommendations that directly address challenges faced
by the retail business. 
Examples of how domain knowledge is applied in retail analysis:
Customer segmentation:
Identifying different customer segments based on demographics and purchase behavior to create targeted marketing campaigns. 
Predictive modeling:
Forecasting future sales trends based on historical data and current market conditions 
Price optimization:
Analyzing sales data to determine the optimal pricing strategy for different products 
Promotional effectiveness analysis:
Evaluating the impact of marketing promotions on sales and customer engagement */