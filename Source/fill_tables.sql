use $(new_db_name);
SET NOCOUNT ON;
GO
BEGIN
	DECLARE @db_name varchar(50) = '$(new_db_name)';
	DECLARE @schema_name varchar(50) = '$(new_schema_name)';
	--
	DECLARE @request varchar(2000);
	DECLARE @request_name varchar(2000);
	
	-- Declare table with table info
	DECLARE @table_request TABLE (request_name varchar(100), request varchar(4000) );
	insert into @table_request(request_name, request) values (
'fill student 1',
'declare @id int 
select @id = 1
while @id >=1 and @id <= 1000
begin
    insert into '+@schema_name+'.student1 values(@id)
    select @id = @id + 1
end');

	insert into @table_request(request_name, request) values (
'fill student 2',
'declare @id int 
select @id = 1
while @id >=1 and @id <= 2000
begin
    insert into '+@schema_name+'.student2 values(@id)
    select @id = @id + 1
end');

	insert into @table_request(request_name, request) values (
'fill student 3',	
'declare @id int 
select @id = 1
while @id >=1 and @id <= 3000
begin
    insert into '+@schema_name+'.student3 values(@id)
    select @id = @id + 1
end');
	--
	--
	--
	-- Execute requests
	WHILE EXISTS(SELECT * FROM @table_request)
	BEGIN
		select top 1 @request = request, @request_name = request_name from @table_request;
		exec (@db_name + '.' + @schema_name + '.safe_execute @name = '''+ @request_name +''', @sql_text = ''' +  @request + ''', @log_enabled = 1')
		delete from @table_request where request_name = @request_name;
	END
END
GO
SET NOCOUNT OFF;
GO

