USE BlinkIT;

SELECT * FROM BlinkIT_data;

--DATA CLEANING
UPDATE BlinkIT_data
SET Item_Fat_Content=
CASE
	WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
	WHEN Item_Fat_Content = 'reg' THEN 'Regular'
	ELSE Item_Fat_Content
END;

--CHECK DATA UPDATE OR NOT
SELECT DISTINCT(Item_Fat_Content) FROM BlinkIT_data;

--TOTAL SALES 
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL (10, 2))  AS Total_sales_Millions FROM BlinkIT_data;

--AVG SALES
SELECT CAST(AVG(Total_Sales) AS decimal(10,2)) AS AVG_SALES FROM  BlinkIT_data;

--NUMBER OF ITEMS
SELECT COUNT(*) FROM BlinkIT_data;

--TOTAL SALES BY FAT CONTENT AND WITH OTHER METRICS
SELECT  Item_Fat_Content,
		CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS decimal(10,2)) AS Avg_Sales,
		COUNT(*) AS Number_OF_Items
FROM BlinkIT_data
GROUP BY Item_Fat_Content;

SELECT  Item_Type,
		CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS decimal(10,2)) AS Avg_Sales,
		COUNT(*) AS Number_OF_Items
FROM BlinkIT_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

--TOP 5 ITEMS
SELECT TOP 5  Item_Type,
		CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS decimal(10,2)) AS Avg_Sales,
		COUNT(*) AS Number_OF_Items
FROM BlinkIT_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- Fat Content by Outlet for Total Sales
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

--Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year , CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales
FROM BlinkIT_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ;

-- Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

--SALES BY OUTLET LOCATION
SELECT Outlet_Location_Type ,SUM(Total_Sales)
FROM BlinkIT_data
GROUP BY Outlet_Location_Type;

--ALL METRICS BY OUTLET TYPE
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;






