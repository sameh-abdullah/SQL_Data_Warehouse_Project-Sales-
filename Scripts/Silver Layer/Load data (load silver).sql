
/*
---------------------------------------------------------------------------------------------------------------------
--------------------------------------------------
STORED PROCEDUER LOAD DATA: bronze -> silver LAYER
--------------------------------------------------

SCRIPT PURPOSE: THIS SCRIPT USE TO TRANSFORM DATA FROM THE BRONZE LAYER TO THE SILVER LAYER USING THE STORE
    PROCEDURE, THE PROCEDURE STARTING TO USE THE DATABASE THEN START TRUNCATE TABLES AND INSERT DATA TO THE TABLES 
    USING THE FULL LOAD FROM THE BRONZE TO SILVER LAYER


WARNING:
    THIS STORE PROCEDURE DOES NOT ACCEPT OR RETURN ANY PARAMETERS AND THE STORE PROCEDURE TRUNCATE ALL THE DATA FROM 
    THE SILVER TABLES SO BE SURE BEFORE EXEC THE SP.

RUN THE PROCEDURE:
    EXEC silver.load_silver;
---------------------------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN
    DECLARE @start_batch DATETIME,@start_time DATETIME,@end_time DATETIME, @end_batch DATETIME;
    BEGIN TRY
        -- Starting loading data from bronze to silver layer
        SET @start_batch =GETDATE();
        PRINT '---------------------------------------------';
        PRINT 'STARTING LOAD SILVER LAYER AT '+ CAST(@start_batch AS NVARCHAR);
        PRINT '---------------------------------------------';

        SET @start_time = GETDATE();
        PRINT 'Starting load silver.crm_cust_info>>>'
        -- TRUNCATE ALL THE DATE STORED IN THE TABLE silver.cust_info TO BE READY FOR THE NEW INSERT
        TRUNCATE TABLE silver.crm_cust_info;
        -- INSERTING THE TRANSFORMATED DATA TO THE TABLE silver.crm_cust_info
        INSERT INTO Silver.crm_cust_info (
                cst_id,
                cst_key,
                cst_first_name,
                cst_last_name,
                cst_marital_status,
                cst_gndr,
                cst_create_date)
        SELECT cst_id
                ,cst_key
                ,TRIM(cst_first_name) AS cst_first_name
                ,TRIM(cst_last_name) AS cst_last_name
                ,CASE UPPER(TRIM(cst_marital_status))
                    WHEN 'S' THEN 'Single'
                    WHEN 'M' THEN 'Married'
                    ELSE 'N/A' END AS cst_marital_status
                ,CASE UPPER(TRIM(cst_gndr))
                    WHEN 'F' THEN 'Female'
                    WHEN 'M' THEN 'Male'
                    ELSE 'N/A' END AS cst_gndr
                ,cst_create_date
        FROM(
            SELECT 
                    *,
                    ROW_NUMBER()  OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
            FROM Bronze.crm_cust_info
            WHERE cst_id IS NOT NULL) T
        WHERE flag=1;

        SET @end_time = GETDATE();
        PRINT 'Finished load silver.crm_cust_info>>>';
        PRINT ' The total duration '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) +' SECOND';


        SET @start_time = GETDATE();
        PRINT 'Starting load Silver.crm_prd_info>>>'
        -- TRUNCATE ALL THE DATE STORED IN THE TABLE silver.crm_prd_info FOR THE NEW INSERT
        TRUNCATE TABLE Silver.crm_prd_info;
        
        -- INSERTING THE TRANSFORMATED DATA TO THE TABLE silver.crm_prd_info
        INSERT INTO Silver.crm_prd_info(
            prd_id,
            prd_key,
            cat_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_date,
            prd_end_date)
        SELECT
            prd_id
            ,REPLACE(SUBSTRING(prd_key,7,LEN(prd_key)),'-','_') AS prd_key -- DATA ENRICHMENT AND REPLACE UNWANTED CHART
            ,REPLACE(LEFT(prd_key,5),'-','_') AS cat_key  
            ,prd_nm          -- DATA ENRICHMENT AND REPLACE UNWANTED CHART
            ,ISNULL(prd_cost,0) AS prd_cost
            ,CASE UPPER(TRIM(prd_line))
                    WHEN 'M' THEN 'Mountain'
                    WHEN 'R' THEN 'Road'
                    WHEN 'S' THEN 'Other Sales'
                    WHEN 'T' THEN 'Touring'
                    ELSE 'N/A' END AS prd_line
            ,prd_start_date
            ,DATEADD(day,-1,LEAD(prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date)) AS prd_end_date
        FROM Bronze.crm_prd_info;
            
        SET @end_time = GETDATE();
        PRINT 'Finished load Silver.crm_prd_info>>>';
        PRINT ' The total duration '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) +' SECOND';

        SET @start_time = GETDATE();
        PRINT 'Starting load Silver.crm_sales_details>>>'
        -- TRUNCATE ALL THE DATE STORED IN THE TABLE silver.crm_sales_details FOR THE NEW INSERT
        TRUNCATE TABLE Silver.crm_sales_details

        -- INSERTING THE TRANSFORMATED DATA TO THE TABLE silver.crm_sales_details
        INSERT INTO Silver.crm_sales_details(
             sls_ord_num
            ,sls_prd_key
            ,sls_cust_id
            ,sls_order_date
            ,sls_ship_date
            ,sls_duration_date
            ,sls_sales
            ,sls_quantity
            ,sls_price
        )
        SELECT 
                 sls_ord_num
                ,REPLACE(sls_prd_key,'-','_')
                ,sls_cust_id
                ,CASE
                    WHEN LEN(sls_order_date) !=8 OR sls_order_date IS NULL THEN NULL
                    ELSE CAST(CAST(sls_order_date AS VARCHAR) AS DATE)
                END AS sls_order_date  
                ,CASE
                    WHEN LEN(sls_ship_date) !=8 OR sls_ship_date IS NULL THEN NULL
                    ELSE CAST(CAST(sls_ship_date AS VARCHAR) AS DATE)
                END AS sls_ship_date
                ,CASE
                    WHEN LEN(sls_duration_date) !=8 OR sls_duration_date IS NULL THEN NULL
                    ELSE CAST(CAST(sls_duration_date AS VARCHAR) AS DATE)
                END AS sls_duration_date
                ,CASE 
                    WHEN sls_sales!=sls_quantity*ABS(sls_price) OR sls_sales <=0 OR sls_sales IS NULL THEN sls_quantity*ABS(sls_price) 
                    ELSE sls_sales 
                END AS sls_sales
                ,sls_quantity
                ,CASE    
                    WHEN sls_price IS NULL OR sls_price<=0 THEN CAST(sls_sales/NULLIF(sls_quantity,0) AS INT)
                ELSE sls_price
                END AS sls_price
           FROM Bronze.crm_sales_details;

        SET @end_time = GETDATE();
        PRINT 'Finished load Silver.crm_sales_details>>>';
        PRINT ' The total duration '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) +' SECOND';

        SET @start_time = GETDATE();
        PRINT 'Starting load Silver.erp_cust_az12>>>'
        -- TRUNCATE ALL THE DATE STORED IN THE TABLE Silver.erp_cust_az12 FOR THE NEW INSERT
        TRUNCATE TABLE Silver.erp_cust_az12;

        -- INSERTING THE TRANSFORMATED DATA TO THE TABLE Silver.erp_cust_az12
        INSERT INTO Silver.erp_cust_az12
        (
             cid
            ,cst_key
            ,bdate
            ,gen
        )
        SELECT 
            cid,
            CASE 
                    WHEN cid LIKE'NASA%' THEN SUBSTRING(cid,4,LEN(cid))
                    ELSE cid
            END AS cst_key,-- derive the cst_key from the cid for join with crm_cust_info
            CASE 
                    WHEN bdate>=GETDATE() THEN NULL
                    ELSE bdate
            END AS bdate,-- SET THE FUTURE BIRTHDATE TO NULL
            CASE 
                    WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
                    WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
                    ELSE 'N/A'
            END AS gen 

        FROM Bronze.erp_cust_az12;

        SET @end_time = GETDATE();
        PRINT 'Finished load Silver.erp_cust_az12>>>';
        PRINT ' The total duration '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) +' SECOND';

        SET @start_time = GETDATE();
        PRINT 'Starting load silver.erp_loc_a101>>>'
        -- TRUNCATE ALL THE DATE STORED IN THE TABLE Silver.erp_loc_a101 FOR THE NEW INSERT
        TRUNCATE TABLE Silver.erp_loc_a101;
        -- INSERTING THE TRANSFORMATED DATA TO THE TABLE Silver.erp_loc_a101
        INSERT INTO Silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT 
                REPLACE(cid,'-','') AS cid,
                CASE
                    WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                    WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                    ELSE TRIM(cntry)
                END AS cntry -- Normalize and Handle missing or blank country codes
            FROM Bronze.erp_loc_a101;

        
        SET @end_time = GETDATE();
        PRINT 'Finished load Silver.erp_loc_a101>>>';
        PRINT ' The total duration '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) +' SECOND';

        SET @start_time = GETDATE();
        PRINT 'Starting load silver.erp_px_cat_g1v2>>>'
        -- TRUNCATE ALL THE DATE STORED IN THE TABLE silver.erp_px_cat_g1v2 FOR THE NEW INSERT
        TRUNCATE TABLE silver.erp_px_cat_g1v2
        -- INSERTING THE TRANSFORMATED DATA TO THE TABLE Silver.erp_loc_a101
        INSERT INTO silver.erp_px_cat_g1v2
        (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM Bronze.erp_px_cat_g1v2;

        SET @end_time = GETDATE();
        PRINT 'Finished load silver.erp_px_cat_g1v2>>>';
        PRINT ' The total duration '+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) +' SECOND';

        -- FINISHED LOAD SILVER
        SET @end_batch = GETDATE();
        PRINT '---------------------------------------------';
        PRINT 'FINISHED LOAD SILVER LAYER AT '+ CAST(@end_batch AS NVARCHAR);
        PRINT ' THE TOTAL TIME '+ CAST(DATEDIFF(SECOND,@start_batch,@end_batch) AS NVARCHAR) +' SECOND';
        PRINT '---------------------------------------------';


    END TRY
    BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
    END CATCH
END
