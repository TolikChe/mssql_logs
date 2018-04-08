use test_db;
exec test_schema.create_table @table_name = 'test_char', @table_text = 'create table test_schema.test_char(x int)', @use_log = 1, @force = 1
exec test_schema.create_table @table_name = 'student', @table_text = 'create table test_schema.student(id int, student varchar(50), age int)', @use_log = 1, @force = 1
exec test_schema.create_table @table_name = 'student123', @table_text = 'create table test_schema.student123(id int, student varchar(50), age int)', @use_log = 1, @force = 1