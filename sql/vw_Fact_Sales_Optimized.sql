-- Upstream View to Enforce Query Folding and Pre-Aggregate Transaction Data
CREATE VIEW [bi].[vw_Fact_Sales_Optimized] AS
SELECT 
    CAST(s.TransactionDate AS DATE) AS SalesDate,
    s.ProductID,
    s.StoreID,
    COUNT(s.TransactionID) AS TotalTransactions,
    SUM(s.SalesAmount) AS TotalRevenue,
    SUM(s.MarginAmount) AS TotalMargin
FROM [dbo].[Raw_Transactions] s
GROUP BY 
    CAST(s.TransactionDate AS DATE), 
    s.ProductID, 
    s.StoreID;
