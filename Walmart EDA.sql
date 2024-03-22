SELECT * FROM Retail.`walmartsales.csv`;



-- ---------------------------------------------------------------------------------------------
-- ------------------------------- Featured Engineering ----------------------------------------
-- ------time_of_day

SELECT time,
( CASE
WHEN  time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN  time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END
) AS time_of_day
FROM retail.
`walmartsales.csv`;

ALTER TABLE Retail.`walmartsales.csv` ADD COLUMN time_of_day VARCHAR(20);

UPDATE Retail.`walmartsales.csv` 
SET time_of_day = (
CASE
     WHEN  time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
     WHEN  time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
     ELSE "Evening"
END
);

-- Create a temporary table to store the updated data ----------------------------------------------------------------------
CREATE TEMPORARY TABLE Retail.`walmartsales.csv` AS
SELECT *,
       (CASE
           WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
           WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
           ELSE 'Evening'
       END ) AS updated_time_of_day
FROM retail.`walmartsales.csv`;

-- Drop the original table
DROP TABLE retail.`walmartsales.csv`;

-- Rename the temporary table to the original table name
ALTER TABLE retail.`walmartsales.csv` RENAME TO retail.`walmartsales.csv`;

-- -----------------------( used the below code when it is getting error 1175 - using the safe update method ----------------
SET SQL_SAFE_UPDATES = 0;

UPDATE Retail.`walmartsales.csv`
SET time_of_day = (
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
)
WHERE time_of_day IS NULL; 
-- --------------------------------------------------------------------------------------------------------------------------------
-- day_name
SELECT date,
       DAYNAME(date) as day_name
FROM Retail.`walmartsales.csv`;

ALTER TABLE Retail.`walmartsales.csv` ADD COLUMN day_name VARCHAR(10);

UPDATE Retail.`walmartsales.csv`
SET day_name = DAYNAME(date);

-- month_name ----
SELECT date,
    MONTHNAME(date) AS month_name
FROM Retail.`walmartsales.csv`;

ALTER TABLE Retail.`walmartsales.csv` ADD COLUMN month_name VARCHAR(10);

UPDATE Retail.`walmartsales.csv`
SET month_name = MONTHNAME(DATE);

-- -----------------------------------------------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------GENERIC QUESTIONS -------------------------------------------------------------------------

-- 1. How many unique cities does the data have?
SELECT DISTINCT city 
FROM Retail.`walmartsales.csv`;
 
 -- 2. In which city is each branch?
  SELECT DISTINCT city, branch
FROM Retail.`walmartsales.csv`;

-- -------------------------------------------------------------------------------------------------------------
-- -------------------------------------Product questions-------------------------------------------------------

-- 1.How many unique product_lines does the data have?
SELECT DISTINCT `product line`
FROM Retail.`walmartsales.csv`;

-- 2. What is the most common payment method?
SELECT payment, COUNT(payment) AS payment_count
FROM Retail.`walmartsales.csv`
GROUP BY payment
ORDER BY payment_count DESC
LIMIT 1;

-- 3. What is the most selling product line?
SELECT `product line`, SUM(quantity) AS total_quantity_sold
FROM Retail.`walmartsales.csv`
GROUP BY `product line`
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- 4. What is the total revenue by month?
SELECT month_name AS month, 
       SUM(Total) AS total_revenue
FROM Retail.`walmartsales.csv`
GROUP BY month_name;

-- 5. What month had the largest COGS?
SELECT month_name AS month, 
       SUM(cogs) AS cogs
FROM Retail.`walmartsales.csv`
GROUP BY month_name
ORDER BY cogs;

-- 6. What product line had the largest revenue?
SELECT `product line`,
SUM(total) AS total_revenue 
FROM Retail.`walmartsales.csv`
GROUP BY `product line`
ORDER BY total_revenue DESC;

-- 7. What is the city with the largest revenue?
SELECT 
    branch,
    city,
    SUM(total) AS total_revenue
FROM Retail.`walmartsales.csv`
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- 8. What product line had the largest VAT?
SELECT `product line`,
       AVG(`tax 5%`) AS avg_tax
FROM Retail.`walmartsales.csv`
GROUP BY `product line`
ORDER BY avg_tax;

-- 9.Which branch sold more products than average product sold?
SELECT branch,
       SUM(quantity) AS qty
FROM Retail.`walmartsales.csv`
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Retail.`walmartsales.csv`);

-- 10. What is the most common product line by gender?
SELECT gender, `Product Line`, COUNT(*) AS frequency
FROM Retail.`walmartsales.csv`
GROUP BY gender, `Product Line`
ORDER BY frequency DESC;

-- 11. What is the average rating of each product line?
SELECT `Product Line`, AVG(rating) AS average_rating
FROM Retail.`walmartsales.csv`
GROUP BY `Product Line`;

-- ---------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------Sales-------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday?
SELECT time_of_day,
   COUNT(*) AS total_sales
FROM Retail.`walmartsales.csv`
WHERE day_name = "sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;


-- 2. Which of the customer types brings the most revenue?
SELECT `customer type`,
  SUM(total) AS total_rev
FROM Retail.`walmartsales.csv`
GROUP BY `customer type`
ORDER BY total_rev DESC;


-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT city, 
  AVG (`tax 5%`) AS VAT
FROM Retail.`walmartsales.csv`
GROUP BY city
ORDER BY VAT;


-- 4. Which customer type pays the most in VAT?
SELECT  `customer type`,
  AVG (`tax 5%`) AS VAT
FROM Retail.`walmartsales.csv`
GROUP BY `customer type`
ORDER BY VAT;
-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------- Customer------------------------------------------

-- 1. How many unique customer types does the data have?
SELECT DISTINCT `customer type`
FROM Retail.`walmartsales.csv`;

-- 2. How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM Retail.`walmartsales.csv`;

-- 3. What is the most common customer type?

-- 4. Which customer type buys the most?
SELECT  `customer type`,
     COUNT(*) AS cstm_cnt
FROM Retail.`walmartsales.csv`
GROUP BY `customer type`;

-- 5. What is the gender of most of the customers?
SELECT gender,
    COUNT(*) AS gender_type
FROM Retail.`walmartsales.csv`
GROUP BY gender;

-- 6. What is the gender distribution per branch?
SELECT gender,
    COUNT(*) AS gender_type
FROM Retail.`walmartsales.csv`
WHERE branch = "C"
GROUP BY gender;

-- 7. Which time of the day do customers give most ratings?
SELECT time_of_day,
   AVG(rating) AS avg_rating
FROM Retail.`walmartsales.csv`
GROUP BY time_of_day
ORDER BY avg_rating;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT time_of_day,
   AVG(rating) AS avg_rating
FROM Retail.`walmartsales.csv`
WHERE branch = "a"
GROUP BY time_of_day
ORDER BY avg_rating.DESC;

-- 9. Which day of the week has the best avg ratings?
SELECT day_name,
  AVG(rating) AS avg_rating
FROM Retail.`walmartsales.csv`
GROUP BY day_name
ORDER BY  avg_rating DESC ;

-- 10. Which day of the week has the best average ratings per branch?
SELECT day_name,
  AVG(rating) AS avg_rating
FROM Retail.`walmartsales.csv`
WHERE branch = "c"
GROUP BY day_name
ORDER BY  avg_rating DESC ;





       
       
       







-- ------------------------------------------------------------------------------------------------