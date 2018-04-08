use $(new_db_name);

BEGIN
	DECLARE @db_name varchar(50) = '$(new_db_name)';
	DECLARE @schema_name varchar(50) = '$(new_schema_name)';

	--
	---------------------------------------------
	-- Procedure to log event info. It`s not autonomous because mssql is not so good 
	---------------------------------------------
	IF OBJECT_ID(@db_name + '.' +@schema_name +'.log_info', 'P') IS NOT NULL
	BEGIN
		EXEC ('DROP PROCEDURE ' + @schema_name + '.log_info;'); 
	END;
	--	
	EXEC ('CREATE PROCEDURE ' + @schema_name + '.log_info @e_name varchar(100), 
										  @e_level int = 3, 
										  @e_duration int = null, 
										  @e_message varchar(4000) = null, 
										  @e_sql varchar(4000) = null
	AS
	BEGIN
		INSERT INTO ' + @db_name + '.' + @schema_name + '.sys_logs(event_name, 
												 event_level, 
												 event_duration, 
												 event_sql,
												 message) 
										VALUES (@e_name,
												@e_level, 
												@e_duration, 
												@e_sql,
												@e_message);
	END;');
	PRINT('"OK" - Create procedure ''log_info''');
	
	--
	---------------------------------------------
	-- Procedure to execute some script. It`s not autonomous because mssql is not so good 
	---------------------------------------------
	IF OBJECT_ID(@db_name + '.' +@schema_name +'.safe_execute', 'P') IS NOT NULL
	BEGIN
		EXEC ('DROP PROCEDURE ' + @schema_name + '.safe_execute;'); 
	END;
	--
	EXEC ('CREATE PROCEDURE  ' + @schema_name + '.safe_execute @name varchar(100), 
											  @sql_text varchar(4000), 
											  @log_enabled int
	AS
		DECLARE @result_text varchar(1000)
		DECLARE @event int
		--
		DECLARE @start_time datetime
		DECLARE @finish_time datetime
		DECLARE @diff decimal(5,2)
	BEGIN
		SET @start_time = sysdatetime()
		SET @result_text = ''OK''
		
		BEGIN TRY
			EXEC (@sql_text)
			SET @event = 3 -- info
		END TRY
		BEGIN CATCH
			SET @result_text = CONCAT(''Error: '', ERROR_NUMBER(), '' Error message: '', ERROR_MESSAGE())
			SET @event = 1 -- error
		END CATCH
		
		SET @finish_time = sysdatetime()
		SET @diff = DATEDIFF(MILLISECOND, @start_time, @finish_time)
		
		IF @log_enabled != 0
			PRINT (CONCAT (''Event: '', @name, ''. Duration: '', @diff, ''. Result '', @result_text))
			EXEC ' + @schema_name + '.log_info @e_name = @name,
									  @e_level = @event,
									  @e_duration = @diff,
									  @e_sql = @sql_text,
									  @e_message = @result_text
	END');
	PRINT('"OK" - Create procedure ''safe_execute''');

	--
	------------------------------------------------
	-- Create table from sql text
	------------------------------------------------
	IF OBJECT_ID(@db_name + '.' +@schema_name +'.create_table', 'P') IS NOT NULL
	BEGIN
		EXEC ('DROP PROCEDURE ' + @schema_name + '.create_table;'); 
	END;
	--
	EXEC ('CREATE PROCEDURE test_schema.create_table @table_name varchar(100), 
											  @table_text varchar(4000), 
											  @use_log int = 0,
											  @force int = 0 
	AS
		DECLARE @action_name varchar(100)
	BEGIN
		SET @action_name = ''Create table '' + @table_name
		
		IF @force != 0 AND OBJECT_ID(@table_name, ''U'') IS NOT NULL 
			exec (''DROP TABLE '' + @table_name)
		
		exec ' + @schema_name + '.safe_execute @name = action_name, 
									  @sql_text = @table_text, 
									  @log_enabled = @use_log
	END')
	PRINT('"OK" - Create procedure ''create_table''');	
END 
GO 