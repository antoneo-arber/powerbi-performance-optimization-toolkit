# ⚡ Enterprise Semantic Model Optimization & DAX Tuning Toolkit

![Power BI](https://img.shields.io/badge/Power%20BI-Optimization-yellow)
![DAX Studio](https://img.shields.io/badge/DAX%20Studio-VertiPaq%20Analyzer-blue)
![Tabular Editor](https://img.shields.io/badge/Tabular%20Editor-BIM%20Scripts-green)
![T-SQL](https://img.shields.io/badge/T--SQL-Query%20Folding-lightgrey)

## 📌 Executive Summary
An enterprise performance engineering toolkit developed to resolve severe query latency on a **20M+ row dataset**. By transitioning a flat denormalized reporting table into a pure **Kimball Star Schema**, optimizing DAX evaluation paths, and enforcing upstream database **Query Folding**, report execution times were reduced from **120 seconds to under 4 seconds**.

---

## 🛠️ Performance Optimization Breakdown

| Optimization Phase | Legacy Implementation | Optimized Architecture | Impact / Gain |
| :--- | :--- | :--- | :--- |
| **Data Schema** | Single Flat Table (20M Rows, High Cardinality) | Pure Kimball Star Schema (Fact + Dim) | **65% Memory Reduction** |
| **DAX Logic** | Row-by-Row Iterators (`FILTER`, `SUMX`) | Set-based Vectorized Calculations | **96% Faster Query Render** |
| **Data Transformation** | Power Query In-Memory Aggregations | T-SQL Aggregated Views (Query Folding) | **Zero ETL Bottlenecks** |
| **Calculation Groups** | 30+ Individual Time-Intelligence Measures | Single Dynamic Calculation Group | **Maintainability & Scale** |

---

## 💻 Code & Optimization Snippets

### 1. Vectorized DAX Measure Rewrites
* **Problem:** Using `FILTER()` over the entire 20M-row Fact table caused severe engine context transition overhead.
* **Solution:** Replaced with set-based filter context modifiers (`KEEPFILTERS` / `CALCULATE`).

```dax
// ❌ UNOPTIMIZED (Legacy): 120s Execution Time
High_Margin_Sales_Legacy = 
SUMX(
    FILTER('Fact_Sales', 'Fact_Sales'[Margin_Rate] > 0.35),
    'Fact_Sales'[Sales_Amount]
)
```
// ✅ OPTIMIZED: < 1s Execution Time
High_Margin_Sales_Optimized = 
CALCULATE(
    SUM('Fact_Sales'[Sales_Amount]),
    KEEPFILTERS('Fact_Sales'[Margin_Rate] > 0.35)
)
### 2. Upstream T-SQL Query Folding View
Pushed row-level aggregations directly to the database engine to allow native query execution.

```sql
CREATE VIEW [bi].[vw_Fact_Sales_Optimized] AS
SELECT 
    CAST(TransactionDate AS DATE) AS SalesDate,
    ProductID,
    StoreID,
    COUNT(TransactionID) AS TotalTransactions,
    SUM(SalesAmount) AS TotalRevenue,
    SUM(MarginAmount) AS TotalMargin
FROM [dbo].[Raw_Transactions]
GROUP BY CAST(TransactionDate AS DATE), ProductID, StoreID;
```
---
## 🔬 Benchmark Results (DAX Studio & VertiPaq Analyzer)

* **Initial VertiPaq Memory Usage:** `4.2 GB`
* **Post-Optimization Memory Usage:** `1.4 GB` (**66.6% reduction**)
* **Visual Render Time:** Reduced from **120,000 ms** to **3,800 ms** (**96.8% improvement**)
---
## 📬 Contact & Enquiries
* **Architect:** Antoneo Arber
* **Email:** antoneoarber@gmail.com
