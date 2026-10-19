/*
===============================================================================
Procedure: bronze.load_bronze
Purpose:
    Load raw data from CRM and ERP CSV files into the Bronze layer.

Process:
    1. Truncate existing data in the Bronze tables.
    2. Load new data from CSV files using BULK INSERT.
    3. Display the loading duration for each table.
    4. Display the total loading duration for the process.
    5. Use TRY...CATCH to catch errors and display error details.

Notes:
    - The first row of each CSV file contains column headers and is skipped.
    - Data is loaded using a comma (,) as the field separator.
    - The procedure reloads all listed tables when executed.

===============================================================================
*/



create or alter procedure bronze.load_bronze as 
begin
	declare @start datetime ,@end datetime , @start_for_all_process datetime , @end_for_all_process datetime
	BEGIN try
		PRINT '================================================';
	    PRINT 'Loading Bronze Layer';
	    PRINT '================================================';
	
		PRINT '------------------------------------------------';
	    PRINT 'Loading CRM Tables';
	    PRINT '------------------------------------------------';
		set @start_for_all_process = getdate();
		set @start = getdate();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		Truncate table bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from '/var/opt/mssql/DataSource/source_crm/cust_info.csv'
		with (
			firstrow = 2 ,
			fieldterminator = ',',
			tablock
		);
		set @end = getdate();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start, @end ) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
--		select * from bronze.crm_cust_info
--		select count(*) from bronze.crm_cust_info
		
		set @start = getdate();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		Truncate table bronze.crm_prd_info;
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from '/var/opt/mssql/DataSource/source_crm/prd_info.csv'
		with (
			firstrow = 2 ,
			fieldterminator = ',',
			tablock
		);
		set @end = getdate();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start, @end ) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
--		select * from bronze.crm_prd_info
--		select count(*) from bronze.crm_prd_info
		
		
		set @start = getdate();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		Truncate table bronze.crm_sales_details;
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from '/var/opt/mssql/DataSource/source_crm/sales_details.csv'
		with (
			firstrow = 2 ,
			fieldterminator = ',',
			tablock
		);
		set @end = getdate();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start, @end ) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
--		select * from bronze.crm_sales_details
--		select count(*) from bronze.crm_sales_details
		
		
		PRINT '------------------------------------------------';
	    PRINT 'Loading ERP Tables';
	    PRINT '------------------------------------------------';
		
		
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		set @start = getdate();
		Truncate table bronze.erp_cust_az12;
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from '/var/opt/mssql/DataSource/source_erp/CUST_AZ12.csv'
		with (
			firstrow = 2 ,
			fieldterminator = ',',
			tablock
		);
		set @end = getdate();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start, @end ) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
--		select * from bronze.erp_cust_az12
--		select count(*) from bronze.erp_cust_az12
		
		
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		set @start = getdate();
		Truncate table bronze.erp_loc_a101;
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from '/var/opt/mssql/DataSource/source_erp/LOC_A101.csv'
		with (
			firstrow = 2 ,
			fieldterminator = ',',
			tablock
		);
		set @end = getdate();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start, @end) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		
--		select * from bronze.erp_loc_a101
--		select count(*) from bronze.erp_loc_a101
		
		
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		set @start = getdate();
		Truncate table bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from '/var/opt/mssql/DataSource/source_erp/PX_CAT_G1V2.csv'
		with (
			firstrow = 2 ,
			fieldterminator = ',',
			tablock
		);
		set @end = getdate();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start, @end ) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		set @end_for_all_process = getdate();
		PRINT '=========================================='
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND,@start_for_all_process , @end_for_all_process ) AS NVARCHAR) + ' seconds';
        PRINT '=========================================='
		
--		select * from bronze.erp_px_cat_g1v2
--		select count(*) from bronze.erp_px_cat_g1v2
		
		PRINT '=========================================='
	    PRINT 'Loading Bronze Layer is Completed';
	    PRINT '=========================================='
	END try
	BEGIN CATCH
		PRINT '=========================================='
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
	END CATCH
	
end

