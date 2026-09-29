🛍️ Customer Shopping Behavior 

An end-to-end data analytics project that takes a raw dataset from cleaning and exploration all the way to a business-ready Power BI dashboard, a written report, and a stakeholder presentation.

## 📌 Overview

This project analyzes customer shopping behavior to uncover patterns in spending, demographics, and subscription/shipping preferences. It demonstrates a complete analytics workflow — from raw data to decision-ready insights — using Python, SQL, Power BI, and Gamma.

The goal: identify who the customers are, what drives their purchases, and how the business can act on it.

## 🗂️ Dataset

- **Source:** **
- **Format:** CSV
- **Size:** *(3900 x 18)*
- **Key fields:** `customer_id`, `age_group`, `gender`, `category`, `item_purchased`, `purchase_amount`, `discount_applied`, `previous_purchases`, `subscription_status`, `shipping_type`, `review_rating`

## 🛠️ Tools & Technologies

| Category | Tools |
|---|---|
| Data Loading & EDA | Python (Panda) |
| Data Cleaning | Python (Pandas) |
| Querying | SQL —  MySQL|
| Visualization | Power BI |


## 🔄 Project Workflow

1. **Data Loading** — Imported the raw dataset into Python using Pandas for initial inspection.
2. **Exploratory Data Analysis (EDA)** — Examined distributions, missing values, outliers, and relationships between variables using summary statistics and visualizations.
3. **Data Cleaning** — Handled missing values, fixed data types, removed duplicates, and standardized categorical fields.
4. **SQL Analysis** — Loaded the cleaned data into PostgreSQL/MySQL/SQL Server and wrote queries to answer specific business questions (top categories, spending by segment, customer retention indicators, etc.).
5. **Dashboard Development** — Built an interactive Power BI dashboard with KPIs, slicers, and charts for stakeholders to explore the data visually.

## 🧾 SQL Analysis

Cleaned data was loaded into a relational database and queried to answer specific business questions. All queries are available in [`sql/analysis_queries.sql`](sql/analysis_queries.sql).

**Revenue by gender**
```sql
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer_shopping_behavior
GROUP BY gender;
```

**High-value discounted purchases** — customers who used a discount and still spent above the average purchase amount
```sql
SELECT customer_id, purchase_amount
FROM customer_shopping_behavior
WHERE discount_applied = 'yes'
  AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer_shopping_behavior);
```

**Top 5 highest-rated items**
```sql
SELECT item_purchased, AVG(review_rating)
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
```

**Average purchase amount by shipping type**
```sql
SELECT shipping_type, AVG(purchase_amount)
FROM customer_shopping_behavior
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;
```

**Revenue and customer count by subscription status**
```sql
SELECT subscription_status,
       AVG(purchase_amount),
       SUM(purchase_amount) AS total_revenue,
       COUNT(customer_id)
FROM customer_shopping_behavior
GROUP BY subscription_status
ORDER BY total_revenue DESC;
```

**Top 5 items by discount rate**
```sql
SELECT item_purchased,
       100 * SUM(CASE WHEN discount_applied = 'yes' THEN 1 ELSE 0 END) / COUNT(*) AS discount_rate
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;
```

**Customer segmentation** (New / Returning / Loyal) based on purchase history
```sql
WITH customer_type AS (
  SELECT customer_id, previous_purchases,
         CASE
           WHEN previous_purchases = 1 THEN 'New'
           WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
           ELSE 'Loyal'
         END AS customer_segment
  FROM customer_shopping_behavior
)
SELECT customer_segment, COUNT(*) AS No_of_customer
FROM customer_type
GROUP BY customer_segment;
```

**Top 3 best-selling items per category**
```sql
WITH item_count AS (
  SELECT category,
         item_purchased,
         COUNT(customer_id) AS total_orders,
         ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
  FROM customer_shopping_behavior
  GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_count
WHERE item_rank <= 3;
```

**Repeat buyers by subscription status** (customers with more than 5 previous purchases)
```sql
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer_shopping_behavior
WHERE previous_purchases > 5
GROUP BY subscription_status;
```

**Revenue by age group**
```sql
SELECT age_group, SUM(purchase_amount) AS revenue
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY revenue DESC;
```

## 📊 Dashboard

The Power BI dashboard includes:

- **KPI cards:** Average Purchase Amount, Average Review Rating, Number of Customers
- **Category breakdown:** Purchase amount by product category
- **Demographic breakdown:** Purchase amount by age group and gender
- **Subscription analysis:** Subscribed vs. non-subscribed customer share
- **Interactive slicers:** Category, gender, shipping type, subscription status

📷 Dashboard Image :

<img width="894" height="495" alt="Screenshot 2026-09-29 111814" src="https://github.com/user-attachments/assets/d8d62619-386c-481f-bab4-6ccf57414c9b" />


## 📈 Results & Key Insights

>
- Customers Young Adult account for the largest share of total revenue.
- Category Clothing has the highest average purchase amount.
- Express Shipping and Free Shipping is associated with higher customer satisfaction.
```
## ▶️ How to Run

   ```
1. ** Clone the Repository **
  

3. **Set up the Python environment**
   ```bash
   pip install pandas numpy matplotlib seaborn sqlalchemy
   ```

4. **Run the EDA & cleaning notebook**
   ```bash
   jupyter notebook notebooks/eda_and_cleaning.ipynb
   ```

5. **Run SQL queries**
   - Load `cleaned_data.csv` into your MySQL Server instance
   - Execute the queries in `sql/analysis_queries.sql`

6. **View the dashboard**
   - Open `dashboard/Customer_Shopping_Behavior.pbix` in Power BI Desktop


## 📬 Contact
Sapana Sonawane | sapanapune0@gmail.com

*(Your name | LinkedIn | Email | Portfolio)*
