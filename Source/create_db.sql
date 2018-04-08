BEGIN
	DECLARE @db_name varchar(50) = '$(new_db_name)';

	IF EXISTS(select 1 from sys.databases where name = @db_name)
	BEGIN
		EXEC ('ALTER DATABASE ' + @db_name + ' SET AUTO_CLOSE OFF');
		EXEC ('DROP DATABASE ' + @db_name);
	END

	EXEC ('CREATE DATABASE ' + @db_name);
	PRINT ('"OK" - Create database ''' + @db_name + '''' );	
END
GO