Disclaimer:
This example includes manual adjustments to key identifiers for demonstration purposes only. 
In real-world data engineering practices, modifying primary identifiers compromises data integrity and violates governance standards.

Any occurrence of duplicate or invalid identifiers must trigger a data quality failure, requiring escalation to the upstream data source. 
Such data must be rejected and prevented from entering the pipeline until resolved at the source.

---

```# duplicate order_ids```

[Documentation](https://docs.google.com/spreadsheets/d/1usE6K1QZ8LC31iKjGDv3JenrbP2B1voX-foIb8rPyxg/edit?gid=0#gid=0)

```sql
SELECT order_id, customer_name
FROM public.ecommerce_raw_data
WHERE order_id IN (
	'ORDR03238',
	'ORDR03238',	
	'ORDR19629',	
	'ORDR68798',	
	'ORDR47322',	
	'ORDR19629',	
	'ORDR47322',	
	'ORDR68798'	
)
```
<img width="269" height="247" alt="image" src="https://github.com/user-attachments/assets/8b60f248-4863-468d-bd0d-66bae832be58" />

<br/>
<br/>

**Solution:**
- Delete the order_ids from dim table first

```sql
DELETE FROM public.fact_orders
WHERE order_id IN (
	'ORDR03238',
	'ORDR03238',	
	'ORDR19629',	
	'ORDR68798',	
	'ORDR47322',	
	'ORDR19629',	
	'ORDR47322',	
	'ORDR68798'	
)
```

<br/>

**Create a new order_id for the duplicates. Make sure to check the new values don't have any match to the existing ids**

```sql
UPDATE public.ecommerce_raw_data
SET order_id = CASE customer_name
	WHEN 'Rita Gray' THEN 'ORDR03237'
	WHEN 'Melissa Clark' THEN 'ORDR19620'
	WHEN 'Christopher Peterson' THEN 'ORDR68799'
	WHEN 'Corey Santos' THEN 'ORDR47323'
	ELSE order_id
END 
WHERE customer_name IN ('Rita Gray', 'Melissa Clark', 'Christopher Peterson', 'Corey Santos');
```

<br/>

**Verify if duplicates still exist**

```sql
SELECT order_id, COUNT(order_id) count
FROM public.ecommerce_raw_data
GROUP BY order_id
HAVING COUNT(order_id) > 1;
```
<img width="346" height="154" alt="image" src="https://github.com/user-attachments/assets/33d644af-ff19-44c5-8a76-4d66dd877d32" />

---
<br/>

```# duplicate customer_ids```

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
<img width="347" height="246" alt="image" src="https://github.com/user-attachments/assets/2851999b-a369-44c7-bf74-d292b182e571" />

