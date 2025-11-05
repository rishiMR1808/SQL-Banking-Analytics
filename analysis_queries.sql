-- 1) Top 5 total balance per customer
SELECT TOP 5
    c.CustomerID, c.Name, SUM(a.Balance) AS Total_Balance
FROM #Customers c
LEFT JOIN #Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY Total_Balance DESC;

-- 2) Top 5 most traded stocks (by total value)
SELECT TOP 5
    st.StockSymbol, st.TradeType, SUM(st.TotalValue) AS Total_Sales
FROM #StockTrades st
GROUP BY st.StockSymbol, st.TradeType
ORDER BY Total_Sales DESC;

-- 3) Loan default percentage by loan type
SELECT 
    LoanType,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Status = 'Default' THEN 1 ELSE 0 END) AS Default_Loans,
    CAST(SUM(CASE WHEN Status = 'Default' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Default_Rate_Percent
FROM #Loans
GROUP BY LoanType;

-- 4) Monthly deposit vs withdrawal
SELECT
    YEAR(TransactionDate) AS [Year],
    MONTH(TransactionDate) AS [Month],
    SUM(CASE WHEN Type = 'Deposit'    THEN Amount END) AS Deposit_Amount,
    SUM(CASE WHEN Type = 'Withdrawal' THEN Amount END) AS Withdrawal_Amount
FROM #Transactions
GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)
ORDER BY [Year], [Month];

-- 5) Profit / Loss per stock trade (based on previous trade price)
WITH Cte_Stock AS (
    SELECT *,
           LAG(PricePerShare) OVER (ORDER BY TradeDate) AS Previous_Price
    FROM #StockTrades
)
SELECT
    TradeID, AccountID, StockSymbol, TradeDate, Quantity, PricePerShare,
    CASE WHEN Previous_Price IS NULL THEN 0
         ELSE (PricePerShare - Previous_Price) * Quantity END AS Profit_Loss,
    CASE WHEN (PricePerShare - Previous_Price) * Quantity > 0 THEN 'Profit' ELSE 'Loss' END AS Flag
FROM Cte_Stock;

-- 6) Top 3 customers by total trading volume
WITH Cte_Trade AS (
    SELECT a.CustomerID, SUM(st.TotalValue) AS Total_StockTrade
    FROM #Accounts a
    JOIN #StockTrades st ON a.AccountID = st.AccountID
    GROUP BY a.CustomerID
)
SELECT TOP 3
    c.Name, ct.Total_StockTrade,
    RANK() OVER (ORDER BY ct.Total_StockTrade DESC) AS Rank_of_Customers
FROM Cte_Trade ct
JOIN #Customers c ON ct.CustomerID = c.CustomerID
ORDER BY Rank_of_Customers;

-- 7) Monthly loan disbursement trend
SELECT
    YEAR(StartDate) AS [Year],
    MONTH(StartDate) AS [Month],
    SUM(LoanAmount) AS Loan_Amount,
    DATENAME(MONTH, StartDate) AS Month_Name
FROM #Loans
GROUP BY YEAR(StartDate), MONTH(StartDate), DATENAME(MONTH, StartDate)
ORDER BY [Year], [Month];

-- 8) Average transaction amount by customer
WITH Transaction_Value AS (
    SELECT a.AccountID, a.CustomerID, ROUND(AVG(t.Amount), 2) AS Avg_Amount
    FROM #Transactions t
    JOIN #Accounts a ON t.AccountID = a.AccountID
    GROUP BY a.AccountID, a.CustomerID
)
SELECT tv.AccountID, tv.CustomerID, c.Name, tv.Avg_Amount AS Average_Amount
FROM Transaction_Value tv
JOIN #Customers c ON tv.CustomerID = c.CustomerID
ORDER BY Average_Amount DESC;
