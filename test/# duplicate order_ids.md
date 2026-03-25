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

Solution:
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
<br/>

Create a new order_id for the duplicates. Make sure to check the new values don't have any match to the existing ids

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
