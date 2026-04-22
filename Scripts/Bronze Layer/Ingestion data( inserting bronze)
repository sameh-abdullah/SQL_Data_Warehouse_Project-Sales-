/*
-----------------------------------------------------------------------------------------------------------------
--------------------------------------------------
STORED PROCEDUER LOAD DATA: SOURCE -> BRONZE LAYER
--------------------------------------------------

SCRIPT PURPOSE: THIS SCRIPT USE TO LOAD DATA FROM THE DATA SOURCE 'CSV FILE' TO THE BRONZE LAYER USING THE STORE
    PROCEDURE, THE PROCEDURE STARTING TO USE THE DATABASE THEN START TRUNCATE TABLES AND INSERT DATA TO THE TABLES 
    USING THE BULK INSERT FROM THE CSV FILES TO THE BRONZE LAYER


WARNING:
    THIS STORE PROCEDURE DOES NOT ACCEPT OR RETURN ANY PARAMETERS AND THE STORE PROCEDURE TRUNCATE ALL THE DATA FROM 
    THE BRONZE TABLES SO BE SURE BEFORE EXEC THE SP.

RUN THE PROCEDURE:
    EXEC bronze.load_bronze;
-----------------------------------------------------------------------------------------------------------------
*/

-- USE DATABASE DB.DATA_WAREHOUSE_PROJECT
USE db_data_warehouse_project
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze  AS

BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch DATETIME, @end_batch DATETIME;
    SET @start_batch = GETDATE();
    BEGIN TRY
        PRINT '-----------------------------------------------------';
        PRINT 'STARTING BATCH INSERT TO THE BRONZE LAYER AT '+ CAST(@start_batch as NVARCHAR);

        SET @start_time = GETDATE();
        PRINT '-----------------------------------------------------';
        PRINT 'STARTING LOAD CRM.CUST_INFO TABLE AT '+ CAST(@start_time as NVARCHAR);
        
        -- TRUNCATE ALL THE DATA FROM THE TABLE CUST_INFO FOR INGESTING DATA AS FULL LOAD METHOD
        TRUNCATE TABLE bronze.crm_cust_info
        -- INSERTING ALL THE DATA FROM THE FILE TO THE TABLE CUST_INFO AS A FULL LOAD
        BULK INSERT bronze.crm_cust_info
        FROM 'D:\Data Warehouse project\Datasets\source_crm\cust_info.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR =',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'END LOAD CRM.CUST_INFO TABLE AT '+ CAST(@end_time as NVARCHAR);
        PRINT 'TOTAL EXECUTE TIME: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR) + ' SECOND';
        PRINT '-----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '-----------------------------------------------------';
        PRINT 'STARTING LOAD CRM.PRD_INFO TABLE AT '+ CAST(@start_time as NVARCHAR);
        -- TRUNCATE ALL THE DATA FROM THE TABLE PRD_INFO FOR INGESTING DATA AS FULL LOAD METHOD
        TRUNCATE TABLE bronze.crm_prd_info
        -- INSERTING ALL THE DATA FROM THE FILE TO THE TABLE PRD_INFO AS A FULL LOAD
        BULK INSERT bronze.crm_prd_info
        FROM 'D:\Data Warehouse project\Datasets\source_crm\prd_info.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR =',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'END LOAD CRM.PRD_INFO TABLE AT '+ CAST(@end_time as NVARCHAR);
        PRINT 'TOTAL EXECUTE TIME: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR) + ' SECOND';
        PRINT '-----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '-----------------------------------------------------';
        PRINT 'STARTING LOAD CRM.SALES_DETAILS TABLE AT '+ CAST(@start_time as NVARCHAR);
        -- TRUNCATE ALL THE DATA FROM THE TABLE SALES_DETAILS FOR INGESTING DATA AS FULL LOAD METHOD
        TRUNCATE TABLE bronze.crm_sales_details
        -- INSERTING ALL THE DATA FROM THE FILE TO THE TABLE SALES_DETAILS AS A FULL LOAD
        BULK INSERT bronze.crm_sales_details
        FROM 'D:\Data Warehouse project\Datasets\source_crm\sales_details.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR =',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'END LOAD CRM.SALES_DETAILS TABLE AT '+ CAST(@end_time as NVARCHAR);
        PRINT 'TOTAL EXECUTE TIME: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR) + ' SECOND';
        PRINT '-----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '-----------------------------------------------------';
        PRINT 'STARTING LOAD erp_cust_az12 TABLE AT '+ CAST(@start_time as NVARCHAR);
        -- TRUNCATE ALL THE DATA FROM THE TABLE CUST_AZ12 FOR INGESTING DATA AS FULL LOAD METHOD
        TRUNCATE TABLE bronze.erp_cust_az12
        -- INSERTING ALL THE DATA FROM THE FILE TO THE TABLE CUST_AZ12 AS A FULL LOAD
        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\Data Warehouse project\Datasets\source_erp\cust_az12.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR =',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'END LOAD erp_cust_az12 TABLE AT '+ CAST(@end_time as NVARCHAR);
        PRINT 'TOTAL EXECUTE TIME: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR) + ' SECOND';
        PRINT '-----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '-----------------------------------------------------';
        PRINT 'STARTING LOAD erp_loc_a101 TABLE AT '+ CAST(@start_time as NVARCHAR);
        -- TRUNCATE ALL THE DATA FROM THE TABLE LOC_A101 FOR INGESTING DATA AS FULL LOAD METHOD
        TRUNCATE TABLE bronze.erp_loc_a101
        -- INSERTING ALL THE DATA FROM THE FILE TO THE TABLE LOC_A101 AS A FULL LOAD
        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\Data Warehouse project\Datasets\source_erp\loc_a101.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR =',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'END LOAD erp_loc_a101 TABLE AT '+ CAST(@end_time as NVARCHAR);
        PRINT 'TOTAL EXECUTE TIME: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR) + ' SECOND';
        PRINT '-----------------------------------------------------';
        
        SET @start_time = GETDATE();
        PRINT '-----------------------------------------------------';
        PRINT 'STARTING LOAD erp_px_cat_g1v2 TABLE AT '+ CAST(@start_time as NVARCHAR);
        -- TRUNCATE ALL THE DATA FROM THE TABLE PX_CAT_G1V2 FOR INGESTING DATA AS FULL LOAD METHOD
        TRUNCATE TABLE bronze.erp_px_cat_g1v2
        -- INSERTING ALL THE DATA FROM THE FILE TO THE TABLE PX_CAT_G1V2 AS A FULL LOAD
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\Data Warehouse project\Datasets\source_erp\px_cat_g1v2.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR =',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'END LOAD erp_px_cat_g1v2 TABLE AT '+ CAST(@end_time as NVARCHAR);
        PRINT 'TOTAL EXECUTE TIME: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) as NVARCHAR) + ' SECOND';
        PRINT '-----------------------------------------------------';

        SET @end_batch = GETDATE();
        PRINT 'FINISHED LOADING BRONZE LAYER '+ CAST(@end_batch as NVARCHAR);
        PRINT 'TOTAL EXECUTE TIME: ' + CAST(DATEDIFF(SECOND,@start_batch,@end_batch) as NVARCHAR) + ' SECOND';
        PRINT '-----------------------------------------------------';
    END TRY
    BEGIN CATCH
        PRINT '-------------------------------------------------------';
        PRINT 'ERROR OCCURE IN PROCEDURE OF LOADING BRONZE LAYER';
        PRINT 'ERROR CODE: '  + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER: '+ CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '--------------------------------------------------------';
    END CATCH
END;
