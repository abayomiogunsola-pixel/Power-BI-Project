| customer-sentiment-churn/
|
| Project Objective: To determine how customer sentiment in support interactions affects the likelihood of churn, and to calculate the actual Monthly Recurring |Revenue (MRR) lost due to churn driven by poor sentiment. Tools Used: SQL (for data processing and analysis), Mockaroo/Python (for data generation), Power BI (for | visualization).
|---data/
|   |--customers.csv        # Mock customer demographic and subscription data
|      supporttickets.csv   # Mock support interaction and sentiment data
|
|---sql/
|   analysis.sql            # Analytical viewpoints and aggregations
|
|--dashboard image          # Screenshots of Power BI Dashboard for ReadME
|
| README.md                 # Project Description, data dictionary
│
|
| Data Dictionary: 
|
| Table 1: Customers
| Column Name     |	Data Type |	Description
| CustomerID	    | INT	      |  Unique identifier for the customer.
| SignupDate	    | DATE	    |  Date the customer joined.
| MonthlyRevenue  |	DECIMAL	  |  The Monthly Recurring Revenue (MRR) of the customer.
| IsChurned	      |BOOLEAN 	  |  True (1) if the customer canceled, False (0) otherwise.
| ChurnDate	      |DATE	      |  The date of cancellation (NULL if not churned).

| Table 2: SupportTickets
| Column Name     | Data Type |	Description
| TicketID	      |  INT	    |  Unique identifier for the support ticket.
| CustomerID	    |  INT	    |  Foreign key linking to the Customers table.
| TicketDate	    |  DATE	    |  Date the ticket was created.
| SentimentScore  |	 INT	    |  Score from 1 (Very Negative) to 5 (Very Positive).
| IssueCategory	  |  VARCHAR	|  e.g., 'Billing', 'Technical', 'Usability'.

