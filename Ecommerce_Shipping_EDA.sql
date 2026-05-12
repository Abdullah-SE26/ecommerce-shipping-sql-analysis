-- Looking at the data and its content
SELECT *
FROM ecommerce_shipping_data
LIMIT 10; 

-- Creating a staging table to work on the data
CREATE TABLE ecommerce_staging
LIKE ecommerce_shipping_data;

SELECT *
FROM ecommerce_staging;

-- Inserting data from the raw data file into the staging table
INSERT ecommerce_staging
SELECT *
FROM ecommerce_shipping_data;

SELECT *
FROM ecommerce_staging;

SELECT *
FROM ecommerce_staging
WHERE Warehouse_block IS NULL;

SELECT *
FROM ecommerce_staging
WHERE Mode_of_Shipment IS NULL;

-- Fixing column  name of ï»¿ID to ID
ALTER TABLE ecommerce_staging
RENAME COLUMN ï»¿ID TO ID;

-- Fixing column name of `Reached.on.Time_Y.N` to Reached_on_Time_Y_N
ALTER TABLE ecommerce_staging
RENAME COLUMN `Reached.on.Time_Y.N` TO Reached_on_Time_Y_N;

-- =========================================
-- EXPLORATORY DATA ANALYSIS
-- =========================================
SELECT *
FROM ecommerce_staging;


-- Warehouse distribution
SELECT Warehouse_block, COUNT(*) AS Warehouse_Count
FROM ecommerce_staging
GROUP BY Warehouse_block
ORDER BY Warehouse_Count DESC;
-- Insight:
-- Warehouse F handles the highest shipment volume, indicating it is a major fulfillment hub.


-- Shipment mode distribution
SELECT Mode_of_Shipment, COUNT(*) AS Shipment_Count
FROM ecommerce_staging
GROUP BY Mode_of_Shipment
ORDER BY Shipment_Count DESC;
-- Insight:
-- Ship is the most commonly used shipment method


-- Customer care calls vs rating
SELECT Customer_care_calls, ROUND(AVG(Customer_rating), 2) AS Avg_Customer_Rating,
COUNT(*) AS Total_Customers
FROM ecommerce_staging
GROUP BY Customer_care_calls
ORDER BY Customer_care_calls;
-- Insight:
-- Despite variations in customer care call frequency, average customer ratings stay close to 3.0, 
-- indicating limited correlation between support call volume and customer satisfaction.


-- Price category vs rating
SELECT
    CASE 
        WHEN Cost_of_the_Product BETWEEN 95 AND 150 THEN 'Low'
        WHEN Cost_of_the_Product BETWEEN 151 AND 250 THEN 'Medium'
        ELSE 'High'
    END AS Price_Category,
    ROUND(AVG(Cost_of_the_Product), 2) AS Avg_Product_Cost,
    ROUND(AVG(Customer_rating), 2) AS Avg_Customer_Rating
FROM ecommerce_staging
GROUP BY Price_Category
ORDER BY Avg_Customer_Rating DESC;
-- Insight:
-- There is no strong relationship between product price and customer rating in this dataset. Customer satisfaction remains relatively stable across all price segments.


-- Gender Count
SELECT Gender, COUNT(*) AS GenderCount
FROM ecommerce_staging
GROUP BY Gender;


-- Delivery status analysis [1 = Delayed | 0 = On Time]
SELECT Reached_on_Time_Y_N, COUNT(*)
FROM ecommerce_staging
GROUP BY Reached_on_Time_Y_N;  

SELECT *
FROM ecommerce_staging
WHERE Reached_on_Time_Y_N = 0;

SELECT ROUND(AVG(Customer_rating),2) AS Avg_rating, Reached_on_Time_Y_N
FROM ecommerce_staging
GROUP BY Reached_on_Time_Y_N;
-- Insights:
-- Customer ratings are almost identical for on-time and delayed shipments, suggesting delivery timing has minimal impact on overall satisfaction in this dataset.


-- AVG discount in relation to delivery status
SELECT Reached_on_Time_Y_N, ROUND(AVG(Discount_offered),2) AS Offered_Discounts
FROM ecommerce_staging
GROUP BY Reached_on_Time_Y_N
ORDER BY Offered_Discounts;
-- Insight:
-- Orders with delayed delivery have significantly higher average discounts compared to on-time deliveries, 
-- suggesting that discounts may be used as compensation or promotional incentives for shipments that are more likely to experience delays.


-- Delay percentage by warehouse block
SELECT Warehouse_block,
ROUND(SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Delay_Percentage
FROM ecommerce_staging
GROUP BY Warehouse_block
ORDER BY Delay_Percentage DESC;
-- Insight:
-- Warehouse B recorded the highest delivery delay percentage, while Warehouse A demonstrated the lowest delay rate. 
-- However, delay percentages remain relatively similar across all warehouse blocks, 
-- suggesting that shipment delays may stem from broader operational challenges rather than warehouse-specific inefficiencies.


-- Mode of shipment and Delay rates
SELECT Mode_of_Shipment, COUNT(*) AS Total_Shipments,
SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) AS Delayed_Shipments,
ROUND(SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Delay_Percentage
FROM ecommerce_staging
GROUP BY Mode_of_Shipment
ORDER BY Delay_Percentage DESC;
-- Insight:
-- Flight shipments recorded the highest delay percentage, while Road transportation demonstrated the lowest delay rate. 
-- However, the differences between shipment methods are relatively small, 
-- suggesting that delivery delays are influenced by broader operational factors rather than transportation mode alone.


-- Product Importance
SELECT Product_importance, COUNT(*) AS Product_Importance_Count
FROM ecommerce_staging
GROUP BY Product_importance
ORDER BY Product_Importance_Count DESC;


-- AVG customer rating in relation to warehouse block. 
SELECT Warehouse_block, ROUND(AVG(Customer_rating),2) AS AVG_Customer_Rating
FROM ecommerce_staging
GROUP BY Warehouse_block
ORDER BY AVG_Customer_Rating DESC;
-- Insight:
-- Average customer ratings are very consistent across all warehouse blocks, ranging from 2.96 to 3.02. 
-- This suggests that warehouse location has minimal impact on customer satisfaction levels in this dataset


-- Correlation between Customer care calls and delays
SELECT 
CASE
	WHEN Reached_on_Time_Y_N = 1 THEN 'Delayed' ELSE 'On Time'
END AS Delivery_Status,
COUNT(*) AS Total_Orders, 
ROUND(AVG(Customer_care_calls),2) AS AVG_Customer_Calls
FROM ecommerce_staging
GROUP BY Reached_on_Time_Y_N
ORDER BY AVG_Customer_Calls DESC;
-- Insigth:
-- Average customer care calls remain very similar between on-time and delayed deliveries, 
-- indicating that delivery status has minimal influence on customer support interaction frequency.


-- Delay vs Customer Rating (by shipment mode)
SELECT Mode_of_Shipment,
ROUND(SUM(CASE 
	WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0
    END) * 100 / COUNT(*), 2) AS Delayed_Percentage,
ROUND(AVG(Customer_rating),2) AS AVG_Customer_Rating
FROM ecommerce_staging
GROUP BY Mode_of_Shipment
ORDER BY AVG_Customer_Rating;
-- Insight:
-- Operational differences across warehouses and shipment modes have limited influence on customer satisfaction and perceived service quality in this dataset, 
-- suggesting that other unmeasured factors (product expectations, pricing, or customer profile) likely play a larger role.


-- Weight vs shipment mode
SELECT Mode_of_Shipment,
ROUND(SUM(CASE 
	WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0
    END) * 100 / COUNT(*), 2) AS Delay_Percentage,
ROUND(AVG(Weight_in_gms),2) AS AVG_Weight_in_gms
FROM ecommerce_staging
GROUP BY Mode_of_Shipment
ORDER BY AVG_Weight_in_gms DESC;
-- Insight:
-- Average product weight is consistent across all shipment modes, indicating that transport method selection is not strongly influenced by product weight in this dataset. 
-- Additionally, delay percentages remain relatively stable across modes, suggesting that shipment performance is not significantly affected by load weight differences.


-- Delay rate by number of prior purchases
SELECT Prior_purchases,
COUNT(*) AS Total_Orders,
SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) AS Delayed_Deliveries,
ROUND(SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS Delay_Percentage
FROM ecommerce_staging
GROUP BY Prior_purchases
ORDER BY Delay_Percentage;
-- Insigth:
-- Customers with fewer prior purchases tend to experience lower delay rates, while more frequent customers appear to face higher delays.


-- Shipment mode × product importance
SELECT Mode_of_Shipment, Product_importance, COUNT(*) AS Total_Deliveries,
SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) AS Delayed_Deliveries,
ROUND(SUM(CASE WHEN Reached_on_Time_Y_N = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*) , 2) AS Delay_Percentage
FROM ecommerce_staging
GROUP BY Mode_of_Shipment, Product_importance
ORDER BY Delay_Percentage DESC;
-- Insight:
-- High-priority products shipped via Ship and Road exhibit the highest delay rates, while lower importance products generally show lower or more stable delay percentages. 
-- This suggests that shipment performance is influenced by a combination of logistics mode and product priority level rather than either factor alone.


-- Average Discount by Delivery Status
SELECT 
CASE 
	WHEN Reached_on_Time_Y_N = 1 THEN 'Delayed' ELSE 'On Time' 
END AS Delivery_Status,
COUNT(*) AS Total_Orders,
ROUND(AVG(Discount_offered),2) AS AVG_Discount
FROM ecommerce_staging
GROUP BY Reached_on_Time_Y_N;
-- Insight:
-- Delayed shipments are associated with significantly higher average discounts (18.66 vs 5.55),
-- suggesting that discounts may be strategically applied either as compensation for delayed deliveries or as incentives for higher-risk orders.


-- FINAL KEY INSIGHTS
-- Overall delivery delay rate is ~40%, showing consistent operational inefficiency
-- No single factor strongly explains delays in isolation
-- Shipment mode differences are minor and not decisive
-- Warehouse performance is relatively uniform across all blocks
-- Discounts are higher in delayed orders, suggesting compensatory pricing behavior
-- Multi-factor combinations reveal more insight than single-variable analysis

-- BUSINESS TAKEAWAY
-- Delivery delays are likely caused by a combination of operational factors rather than a single bottleneck such as warehouse or shipment mode. 
-- Further investigation into logistics coordination and supply chain timing would be required.