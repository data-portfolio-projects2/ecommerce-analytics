-- Get the order ids associated to multiple customers
-- Must result into a table with columns such as order_id and associated customer names

SELECT order_id, customer_name
FROM ecommerce_raw_data
WHERE order_id IN (
	SELECT order_id
	FROM ecommerce_raw_data
	GROUP BY order_id -- why use group by when we are not aggregating?
	HAVING COUNT(DISTINCT customer_name) > 1 -- why do we filter for customer name?
)

-- =====================================================
-- EXPLAINING GROUP BY + HAVING
-- =====================================================

-- GROUP BY:
-- - Groups rows in a table based on one or more columns.
-- - Each group becomes a single unit for aggregation functions (COUNT, SUM, AVG, etc.).
-- - Syntax: GROUP BY column1, column2
-- - Example: GROUP BY order_id
--     * All rows with the same order_id are grouped together.

-- HAVING:
-- - Filters the groups created by GROUP BY based on aggregate conditions.
-- - Similar to WHERE, but WHERE cannot filter on aggregate functions.
-- - Syntax: HAVING COUNT(DISTINCT customer_name) > 1
--     * Keeps only groups where the number of unique customer_name values > 1.
-- - Key: HAVING always applies **after aggregation**.

-- Combined logic (example):
-- 1. GROUP BY order_id → treat each order as a group.
-- 2. COUNT(DISTINCT customer_name) → count unique customers in that order.
-- 3. HAVING COUNT(DISTINCT customer_name) > 1 → keep orders with multiple customers.
-- 4. Outer query can then fetch all rows for those order_ids.

-- Analogy with Pandas:
-- customer_counts = df.groupby('order_id')['customer_name'].nunique()
-- problem_orders = customer_counts[customer_counts > 1].index
-- df[df['order_id'].isin(problem_orders)]
-- 
-- GROUP BY + HAVING in SQL achieves the same thing:
-- - Identify groups based on a key
-- - Apply aggregate filter
-- - Use the result to select rows or compute summaries



