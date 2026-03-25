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

Solution:
- Delete the order_ids from dim table firts

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
