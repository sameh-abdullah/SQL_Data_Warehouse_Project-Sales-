/*
---------------------------------------------------------------------------------------------------------------------------
Script purpose: 
	This script creates view tables for Gold Layer in the data warehouse
	Gold Layer represnts the fact and dimension tables for data business and data analysis roles (Star Schema)
	
	Each views preforms transformations, combins, and enrich data from Silver Layer to produce a integrated, consistent data
	for business and analysis roles

Usage:
	This views can be queried directly for reporting and analysing
----------------------------------------------------------------------------------------------------------------------------
*/

USE db_data_warehouse_project;
GO
-- Create Gold Layer

-- Check if the view already exist in the gold layer or not, if exist drop it
IF OBJECT_ID('Gold.dim_customers','V') IS NOT NULL
	DROP VIEW Gold.dim_customers;
GO

-- Create dim_customers view
CREATE OR ALTER VIEW Gold.dim_customers AS 
	SELECT 
		ROW_NUMBER() OVER (ORDER BY cst_info.cst_create_date, cst_info.cst_id)	AS customer_key, -- Surrogate key
		cst_info.cst_id															AS customer_id,
		cst_info.cst_key														AS customer_code,
		cst_info.cst_first_name													AS first_name,
		cst_info.cst_last_name													AS last_name,
		CASE 
			WHEN cst_info.cst_gndr !='N/A' THEN cst_info.cst_gndr	-- primary source for gndr is crm_cust_info 
			ELSE ISNULL(cst_extra.gen,'N/A')						-- RETURN erp_gen 
		END																		AS gender,
		cst_info.cst_marital_status												AS martial_status,
		cst_loc.cntry															AS country,
		cst_extra.bdate															AS brith_day

	FROM Silver.crm_cust_info cst_info
	LEFT JOIN Silver.erp_cust_az12 cst_extra
	ON			cst_info.cst_key=cst_extra.cst_key
	LEFT JOIN Silver.erp_loc_a101 cst_loc
	ON			cst_info.cst_key=cst_loc.cid;
GO
-- Chect if the viw table dim_products exists or no, if yes, drop it
IF OBJECT_ID('Gold.dim_products','V') IS NOT NULL
	DROP VIEW Gold.dim_products;
GO

-- Create view table dim_products in the gold layer
CREATE OR ALTER VIEW Gold.dim_products AS
	SELECT
		ROW_NUMBER() OVER (ORDER BY prd_info.prd_start_date, prd_info.prd_id) AS product_key, -- Create surrogate key
		prd_info.prd_id				AS product_id,
		prd_info.prd_key			AS product_number,
		prd_info.prd_nm				AS product_name,
		prd_info.cat_key			AS category_id,
		prd_cat.cat					AS category_name,
		prd_Cat.subcat				AS subcategory,
		prd_info.prd_line			AS product_line,
		prd_info.prd_cost			AS product_cost,
		prd_cat.maintenance			AS mintenance,
		prd_info.prd_start_date		AS start_date		

	FROM Silver.crm_prd_info prd_info
	LEFT JOIN Silver.erp_px_cat_g1v2 prd_cat
	ON prd_info.cat_key=prd_cat.id
	WHERE prd_info.prd_end_date IS NULL -- Filtering the current data and ignoring the historical data
GO

-- Check if the view fact_sales exists in Gold layer or not, if yes, drop it
IF OBJECT_ID('Gold.fact_sales','V') IS NOT NULL
	DROP VIEW Gold.fact_sales
GO

-- Create the view fact_sales in the gold layer
CREATE OR ALTER VIEW Gold.fact_sales AS
	SELECT 
		ROW_NUMBER() OVER (ORDER BY sales.sls_order_date) AS order_key, -- Surrogate key
		sales.sls_ord_num		AS order_number,
		cust.customer_key		AS customer_key,
		prd.product_key			AS product_key,
		sales.sls_order_date	AS order_date,
		sales.sls_ship_date		AS ship_date,
		sales.sls_duration_date	AS duration_date,
		sales.sls_sales			AS sales,
		sales.sls_quantity		AS quantity,
		sales.sls_price			AS price

	FROM Silver.crm_sales_details sales
	LEFT JOIN Gold.dim_customers cust
	ON sales.sls_cust_id=cust.customer_id
	LEFT JOIN Gold.dim_products prd
	ON sales.sls_prd_key=prd.product_number
