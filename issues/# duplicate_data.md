```
Disclaimer:
This example includes manual adjustments to key identifiers for demonstration purposes only. 
In real-world data engineering practices, modifying primary identifiers compromises data integrity and violates governance standards.

Any occurrence of duplicate or invalid identifiers must trigger a data quality failure, requiring escalation to the upstream data source. 
Such data must be rejected and prevented from entering the pipeline until resolved at the source.
```

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

---
<br/>

```# duplicate product_ids```

```sql
SELECT customer_name, product_id, 
	ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY customer_name)
FROM public.ecommerce_raw_data
WHERE product_id IN (
	'PROD33618',
	'PROD41517',
	'PROD54028',
	'PROD07623',
	'PROD60486',
	'PROD03799',
	'PROD48674',
	'PROD22061',
	'PROD08395',
	'PROD31540',
	'PROD42677',
	'PROD50698',
	'PROD49761',
	'PROD07722',
	'PROD20247',
	'PROD47691',
	'PROD98725',
	'PROD05904',
	'PROD11190',
	'PROD86547',
	'PROD25885',
	'PROD35378',
	'PROD62605',
	'PROD84894',
	'PROD08549',
	'PROD91018',
	'PROD03362',
	'PROD88867',
	'PROD95313',
	'PROD15852'
)
```
<img width="422" height="315" alt="image" src="https://github.com/user-attachments/assets/9a4cb6f2-5c0e-4899-9cb2-e73611c213f7" />

<br/>
<br/>

```
This is where manual adjustment ends, and this goes to show that resolving duplicates at scale is not feasible—and becomes practically impossible—through SQL updates alone. 
Modifying large volumes of records is not only risky but also unsustainable and unmanageable.

Therefore, the dataset must be rejected and reported to the data source provider for investigation and correction at the source.
```
---

```
Correct Solution:
Remove all the data
```
```sql
TRUNCATE TABLE
	public.ecommerce_raw_data,
	public.fact_campaign_daily,
	public.fact_order_items,
	public.fact_orders,
	public.dim_campaign,
	public.dim_channel,
	public.dim_customer,
	public.dim_date,
	public.dim_product
```







