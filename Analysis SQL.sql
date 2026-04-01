drop table if exists customers;
create table customers (
CustomerID varchar(50) primary key,
SignupDate date NOT NULL,
MonthlyRevenue numeric(20,2) NOT NULL,
IsChurned varchar(50),
ChurnDate date not null 
);

				
drop table if exists supporttickets;
create table supporttickets (
TicketID varchar(50) primary key  ,
CustomerID varchar(50) ,
TicketDate date NOT NULL,
SentimentScore numeric,
IssueCategory varchar(50) not null 
);


-- Create a customer summary view
drop view if exists v_customer_summary;
CREATE OR REPLACE VIEW v_customer_summary AS
SELECT 
    c.CustomerID,
    c.SignupDate,
    c.MonthlyRevenue,
    c.IsChurned,
    c.ChurnDate,
    COUNT(t.TicketID) AS TotalTickets,
    ROUND(AVG(t.SentimentScore), 2) AS AvgSentimentScore,
    CASE 
        WHEN AVG(t.SentimentScore) >= 4 THEN 'Positive'
        WHEN AVG(t.SentimentScore) >= 2.5 THEN 'Neutral'
        ELSE 'Negative'
    END AS SentimentBucket
FROM 
    Customers c
LEFT JOIN 
    SupportTickets t ON c.CustomerID = t.CustomerID
GROUP BY 
    1, 2, 3, 4, 5;


-- Analyze churn rate and lost revenue by sentiment bucket
drop view if exists v_churn_revenue_analysis;
CREATE OR REPLACE VIEW v_churn_revenue_analysis AS
WITH SentimentMetrics AS (
    SELECT 
        SentimentBucket,
        COUNT(CustomerID) AS TotalCustomers,
        SUM(CASE WHEN IsChurned = '1' THEN 1 ELSE 0 END) AS ChurnedCustomers,
        SUM(CASE WHEN IsChurned = '1' THEN MonthlyRevenue ELSE 0 END) AS RevenueLost
    FROM 
        v_customer_summary
    WHERE 
        SentimentBucket IS NOT NULL
    GROUP BY 
        SentimentBucket
)
SELECT 
    SentimentBucket,
    TotalCustomers,
    ChurnedCustomers,
    ROUND((ChurnedCustomers * 100.0) / TotalCustomers, 2) AS ChurnRatePct,
    RevenueLost
FROM 
    SentimentMetrics
ORDER BY 
    ChurnRatePct DESC;

-- Calculate monthly average sentiment for churned vs retained customers
drop view if exists v_sentiment_trend;
CREATE OR REPLACE VIEW v_sentiment_trend AS
SELECT 
    DATE_TRUNC('month', t.TicketDate) AS MonthDesc,
    c.IsChurned,
    ROUND(AVG(t.SentimentScore), 2) AS MonthlyAvgSentiment,
    COUNT(t.TicketID) AS TicketVolume
FROM 
    SupportTickets t
JOIN 
    Customers c ON t.CustomerID = c.CustomerID
GROUP BY 
    1, 2
ORDER BY 
    1 ASC, 2;	


