rem create (recreate) test_db
rem sqlcmd -s localhost\sqlexpress -i setup.sql -o setup.log
sqlcmd -S localhost\sqlexpress -U test -P 123456 -i setup.sql -o setup.log

rem create tables 
rem sqlcmd -s localhost\sqlexpress -i create_tables.sql -o create_tables.log