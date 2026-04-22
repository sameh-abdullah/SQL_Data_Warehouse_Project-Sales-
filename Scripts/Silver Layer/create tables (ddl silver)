/*
---------------------------------------------------------------------------------------------------------------------
SCRPIT PUROSE: THIS SCRIPT CREATES ALL THE TABLES THAT NEEDED TO TRANSFORMED DATA FROM THE BRONZE LAYER, BEFORE THAT, 
THE CODE IS CHECKING IF THE TABLES ARE EXISTS OR NOT, IF THEY ARE EXISTS IT WILL DROP THEM AND THEN CREATE NEW ONES, 
OTHERWISE IT WILL CREATE NEW ONES.

WARNING: RUNNING THIS SCRIPT WILL DROP ALL THE TABLES IF THEY ARE EXISTS, SO MAKE SURE TO CHECK WHETHER THEY ARE EXISTS 
TO AVOID LOSING ANY DATA, AND MAKE
----------------------------------------------------------------------------------------------------------------------
*/

-- USE THE PROJECT DATABASE TO BE ABLE TO CREATE THE TABLES IN IT
USE db_data_warehouse_project
GO

-- CHCEK WHETHER THE TABLE IS EXISTS OR NOT, IF IT IS EXISTS IT WILL DROP IT AND THEN CREATE A NEW ONE, OTHERWISE IT WILL CREATE A NEW ONE
IF OBJECT_ID ('silver.crm_cust_info','U') IS NOT NULL
DROP TABLE silver.crm_cust_info
GO

-- CREATE THE TABLE CUSTOMERS_INFO IN THE SCHEMA silver TO BE ABLE TO INGEST THE DATA OF THE CUSTOMERS FROM THE CRM SYSTEM
CREATE TABLE silver.crm_cust_info(
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_first_name      NVARCHAR(50),
    cst_last_name       NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,
    dwh_cst_load_date   DATETIME2 DEFAULT GETDATE()   
);
GO

-- CHCEK WHETHER THE TABLE IS EXISTS OR NOT, IF IT IS EXISTS IT WILL DROP IT AND THEN CREATE A NEW ONE, OTHERWISE IT WILL CREATE A NEW ONE
IF OBJECT_ID ('silver.crm_prd_info','U') IS NOT NULL
DROP TABLE silver.crm_prd_info
GO
-- CREATE THE TABLE PRD_INFO IN THE SCHEMA silver TO BE ABLE TO INGEST THE DATA OF THE PRD_INFO FROM THE CRM SYSTEM
CREATE TABLE silver.crm_prd_info(
    prd_id          INT,
    prd_key         NVARCHAR(50),
    cat_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_date  DATE,
    prd_end_date    DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

GO

-- CHCEK WHETHER THE TABLE IS EXISTS OR NOT, IF IT IS EXISTS IT WILL DROP IT AND THEN CREATE A NEW ONE, OTHERWISE IT WILL CREATE A NEW ONE
IF OBJECT_ID ('silver.crm_sales_details','U') IS NOT NULL
DROP TABLE silver.crm_sales_details
GO
-- CREATE THE TABLE SALES_DETAILS IN THE SCHEMA silver TO BE ABLE TO INGEST THE DATA OF THE SALES_DETAILS FROM THE CRM SYSTEM
CREATE TABLE silver.crm_sales_details(
    sls_ord_num         NVARCHAR(50),
    sls_prd_key         NVARCHAR(50),
    sls_cust_id         INT,
    sls_order_date      DATE,
    sls_ship_date       DATE,
    sls_duration_date   DATE,
    sls_sales           INT,
    sls_quantity        INT,
    sls_price           INT,
    dwh_creation_date   DATETIME DEFAULT GETDATE()
);

GO

-- CHCEK WHETHER THE TABLE IS EXISTS OR NOT, IF IT IS EXISTS IT WILL DROP IT AND THEN CREATE A NEW ONE, OTHERWISE IT WILL CREATE A NEW ONE
IF OBJECT_ID ('silver.erp_cust_az12','U') IS NOT NULL
DROP TABLE silver.erp_cust_az12
GO
-- CREATE THE TABLE CUST_AZ12 IN THE SCHEMA silver TO BE ABLE TO INGEST THE DATA OF THE CUST_AZ12 FROM THE ERP SYSTEM
CREATE TABLE silver.erp_cust_az12(
    cid  NVARCHAR(50),
    cst_key NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50),
    dwh_creation_date   DATETIME DEFAULT GETDATE()
);

GO

-- CHCEK WHETHER THE TABLE IS EXISTS OR NOT, IF IT IS EXISTS IT WILL DROP IT AND THEN CREATE A NEW ONE, OTHERWISE IT WILL CREATE A NEW ONE
IF OBJECT_ID ('silver.erp_loc_a101','U') IS NOT NULL
DROP TABLE silver.erp_loc_a101
GO
-- CREATE THE TABLE LOV_101 IN THE SCHEMA silver TO BE ABLE TO INGEST THE DATA OF THE LOC_101 FROM THE ERP SYSTEM
CREATE TABLE silver.erp_loc_a101(
    cid       NVARCHAR(50),
    cntry     NVARCHAR(50),
    dwh_creation_date   DATETIME DEFAULT GETDATE()
);

GO

-- CHCEK WHETHER THE TABLE IS EXISTS OR NOT, IF IT IS EXISTS IT WILL DROP IT AND THEN CREATE A NEW ONE, OTHERWISE IT WILL CREATE A NEW ONE
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

-- CREATE THE TABLE PX_CAT_G1V2 IN THE SCHEMA silver TO BE ABLE TO INGEST THE DATA OF THE PX_CAT_G1V2 FROM THE ERP SYSTEM
CREATE TABLE silver.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50),
    dwh_creation_date   DATETIME DEFAULT GETDATE()
);
GO
