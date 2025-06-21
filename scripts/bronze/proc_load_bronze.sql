/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @global_start_time DATETIME, @global_end_time DATETIME;
    BEGIN TRY
        SET @global_start_time = GETDATE();
        PRINT '=========================';
        PRINT 'Loading the bronze layer';
        PRINT '=========================';

        PRINT '-------------------------';
        PRINT 'Loading CRM tables';
        PRINT '-------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Loadig bronze.crm_cust_info'
        BULK INSERT bronze.crm_cust_info
        FROM '/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Loadig bronze.crm_prd_info'
        BULK INSERT bronze.crm_prd_info
        FROM '/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Loadig bronze.crm_sales_details'
        BULK INSERT bronze.crm_sales_details
        FROM '/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------';

        PRINT '-------------------------';
        PRINT 'Loading ERP tables';
        PRINT '-------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Loadig bronze.erp_cust_az12'
        BULK INSERT bronze.erp_cust_az12
        FROM '/source_erp/CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Loadig bronze.erp_loc_a101'
        BULK INSERT bronze.erp_loc_a101
        FROM '/source_erp/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Loadig bronze.erp_px_cat_g1v2'
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------';
        SET @global_end_time = GETDATE();
        PRINT '=========================';
        PRINT 'Bronze Layer Load is Finished'
        PRINT '>>> Total Load Duration: ' + CAST(DATEDIFF(second, @global_start_time, @global_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=========================';

    END TRY
    BEGIN CATCH
        PRINT '=========================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT '=========================';
    END CATCH
END
