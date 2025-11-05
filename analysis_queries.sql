-- Total Sales
SELECT SUM(TotalAmount) AS Total_Sales FROM #Orders;

-- Total Orders
SELECT COUNT(*) AS Total_Orders FROM #Orders;

-- Total Customers
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers FROM #Customers;

-- Average Order Value
SELECT ROUND(SUM(TotalAmount)*1.0/COUNT(*),2) AS AvgOrderValue FROM #Orders;

-- Repeat Customers
SELECT CustomerID, Total_Orders FROM (
    SELECT CustomerID, COUNT(*) AS Total_Orders FROM #Orders
    GROUP BY CustomerID
) t WHERE Total_Orders > 1;

-- Top 5 Cities by Revenue
SELECT TOP 5 c.City, SUM(o.TotalAmount) AS Total_Revenue
FROM #Customers AS c
LEFT JOIN #Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.City
ORDER BY Total_Revenue DESC;

-- Top 5 Products by Quantity Sold
SELECT TOP 5 p.ProductName, SUM(od.Quantity) AS Total_Quantity
FROM #OrderDetails AS od
LEFT JOIN #Products AS p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Total_Quantity DESC;

-- Year-over-Year Sales Performance
WITH YearSales AS (
    SELECT YEAR(OrderDate) AS Year, SUM(TotalAmount) AS Total_Sales
    FROM #Orders
    GROUP BY YEAR(OrderDate)
)
SELECT Year, Total_Sales,
       LAG(Total_Sales) OVER (ORDER BY Year) AS Previous_Year,
       ROUND((Total_Sales - LAG(Total_Sales) OVER (ORDER BY Year)) * 100.0 /
             NULLIF(LAG(Total_Sales) OVER (ORDER BY Year), 0), 2) AS YoY_Percentage_Change
FROM YearSales;

-- Customer Lifetime Value (CLV)
SELECT c.Name, c.City, o.OrderDate, od.OrderID, od.ProductID, od.Quantity, p.ProductName, p.Category, p.Price
FROM #Customers AS c
LEFT JOIN #Orders AS o ON c.CustomerID = o.CustomerID
LEFT JOIN #OrderDetails AS od ON o.OrderID = od.OrderID
LEFT JOIN #Products AS p ON od.ProductID = p.ProductID;

-- Monthly Active Customers
SELECT YEAR(OrderDate) AS Year, DATENAME(MONTH, OrderDate) AS Month_Name,
       COUNT(DISTINCT CustomerID) AS Active_Customers
FROM #Orders
GROUP BY YEAR(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY Year, Month_Name;

-- RFM (Recency, Frequency, Monetary)
SELECT c.CustomerID, c.Name,
       DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS Recency,
       COUNT(o.OrderID) AS Frequency,
       SUM(o.TotalAmount) AS Monetary
FROM #Customers AS c
LEFT JOIN #Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY Monetary DESC;

-- Pareto 80/20 Rule
WITH CustomerSales AS (
    SELECT c.CustomerID, c.Name, SUM(o.TotalAmount) AS Total_Sales
    FROM #Customers AS c
    LEFT JOIN #Orders AS o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.Name
),
Ranked AS (
    SELECT CustomerID, Name, Total_Sales,
           SUM(Total_Sales) OVER (ORDER BY Total_Sales DESC) * 100.0 /
           SUM(Total_Sales) OVER () AS Percentage
    FROM CustomerSales
)
SELECT * FROM Ranked WHERE Percentage < 80;

-- Customer Segmentation by Order Frequency
SELECT c.Name, c.City,
       COUNT(o.OrderID) AS Total_Orders,
       CASE WHEN COUNT(o.OrderID) > 10 THEN 'Platinum'
            WHEN COUNT(o.OrderID) BETWEEN 5 AND 10 THEN 'Gold'
            ELSE 'Silver' END AS Segment
FROM #Customers AS c
LEFT JOIN #Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.Name, c.City;
