use $(new_db_name);

BEGIN
	DECLARE @db_name varchar(50) = '$(new_db_name)';
	DECLARE @schema_name varchar(50) = '$(new_schema_name)';

	IF schema_id(@schema_name) IS NOT NULL
	BEGIN
		EXEC ('DROP SCHEMA ' + @schema_name);
	END
		
	EXEC ('CREATE SCHEMA ' + @schema_name);
	PRINT ('"OK" - Create schema ''' + @db_name + '.' + @schema_name + '''' );
END
GO