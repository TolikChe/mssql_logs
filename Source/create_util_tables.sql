use $(new_db_name);

BEGIN
	DECLARE @db_name varchar(50) = '$(new_db_name)';
	DECLARE @schema_name varchar(50) = '$(new_schema_name)';
	--
	---------------------------------------------------
	-- Create parameters table
	---------------------------------------------------
	IF OBJECT_ID(@db_name + '.' +@schema_name +'.parameters', 'U') IS NOT NULL
		EXEC ('DROP TABLE '+@db_name+'.'+@schema_name+'.parameters;');

	EXEC ('CREATE TABLE '+@db_name+'.'+@schema_name+'.parameters (
	  prmt_id     INT           NOT NULL IDENTITY (1, 1),
	  name        VARCHAR(100)  NOT NULL,
	  value       VARCHAR(100)  NOT NULL,
	  CONSTRAINT  prmt_pk PRIMARY KEY(prmt_id)
	);');
	PRINT('"OK" - Create table ''parameters''');
	--
	---------------------------------------------------
	-- Create table for log
	---------------------------------------------------
	IF OBJECT_ID(@db_name + '.' +@schema_name +'.sys_logs', 'U') IS NOT NULL
		EXEC ('DROP TABLE '+@db_name+'.'+@schema_name+'.sys_logs;');

	EXEC ('CREATE TABLE '+@db_name+'.'+@schema_name+'.sys_logs (
	  slog_id        INT           NOT NULL IDENTITY (1, 1),
	  event_date     DATETIME      NOT NULL DEFAULT sysdatetime(),
	  event_duration INT           NOT NULL,  
	  event_name     VARCHAR(100)  NOT NULL,
	  event_level    INT           NOT NULL DEFAULT 3 CONSTRAINT sys_logs_event_level_check CHECK (event_level in (1,2,3)), -- 1-error, 2-warning, 3-info
	  event_sql      VARCHAR(4000) NULL,
	  message        VARCHAR(4000) NOT NULL,
	  CONSTRAINT slogs_pk PRIMARY KEY(slog_id)
	)');
	PRINT('"OK" - Create table ''sys_logs''');
END	
GO
--