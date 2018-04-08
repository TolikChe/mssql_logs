use $(new_db_name);
SET NOCOUNT ON;
GO
BEGIN
	DECLARE @db_name varchar(50) = '$(new_db_name)';
	DECLARE @schema_name varchar(50) = '$(new_schema_name)';
	--
	DECLARE @table_name varchar(50);
	DECLARE @table_request varchar(2000);
	
	-- Declare table with table info
	DECLARE @table_info TABLE ( table_name varchar(50), table_request varchar(2000) );
	insert into @table_info(table_name, table_request) values ('test_char', 'create table ' + @schema_name+ '.test_char(x int)');
	insert into @table_info(table_name, table_request) values ('student1', 'create table ' + @schema_name+ '.student1(x int)');
	insert into @table_info(table_name, table_request) values ('student2', 'create table ' + @schema_name+ '.student2(x int)');
	insert into @table_info(table_name, table_request) values ('student3', 'create table ' + @schema_name+ '.student3(x int)');
	--
	--
	--
	-- Create tables
	WHILE EXISTS(SELECT * FROM @table_info)
	BEGIN
		select top 1 @table_name = table_name, @table_request = table_request from @table_info;
		exec (@db_name + '.' + @schema_name + '.create_table @table_name = '''+ @table_name +''', @table_text = ''' +  @table_request + ''', @use_log = 1, @force = 1')
		delete from @table_info where table_name = @table_name;
	END
END
GO
SET NOCOUNT OFF;
GO