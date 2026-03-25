```sql
SELECT customer_name, customer_id, 
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_name)
FROM public.ecommerce_raw_data
WHERE customer_id IN (
	'CUST46773',
	'CUST60479',
	'CUST87553',
	'CUST61574'
)
```
<img width="347" height="246" alt="image" src="https://github.com/user-attachments/assets/1028b22f-ee2f-43ec-9ed7-d37ed9582b7d" />
