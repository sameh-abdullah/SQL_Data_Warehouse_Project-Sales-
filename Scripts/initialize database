/*
-------------------------------------------------------------------------------------------------------------------------------------------
SCRIPTS PURPOSE:
This script is used to check if the database is exists or not, if it is exists it will create a backup for it and then will drop it,
and then will create a new database with the same name. moreover, it will create the medallion schema (Bronze, Silver, Gold) in the new database.

WARNING:
Run this script will totally drop the database if it exists, so make sure to check whether it exists to avoid losing any data, and make 
sure to have a backup for the database if it exists before running this script.
------------------------------------------------------------------------------------------------------------------------------------------
*/

-- CONNTECT WITH THE SYSTEM DATABASE master  TO BE ABILE TO CREATE PROJECT DATABASE
USE master
GO

-- CREATE THE PROJECT DATABASE
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'db_data_warehouse_project')
BEGIN
    -- CREATE A BACKUP FOR THE EXISTING DATABASE
    BACKUP DATABASE db_data_warehouse_project TO DISK = 'D:\Data Warehouse project\Backup\Backup\db_data_warehouse_project.bak'
    
    -- DROP THE EXISTING DATABASE
    DROP DATABASE db_data_warehouse_project
END

-- CREATE THE NEW PROJECT DATABASE
CREATE DATABASE db_data_warehouse_project
GO

-- USE THE NEW CREATED DATABASE TO BE ABLE TO CREATE THE MEDALLION SCHEMA
USE db_data_warehouse_project
GO

--CREATE THE BRONZE, SILVER, AND GOLD SCHEMAS IN THE NEW DATABASE
CREATE SCHEMA Bronze
GO
CREATE SCHEMA Silver
GO
CREATE SCHEMA Gold
GO
