select timediff(
    (select update_time from information_schema.tables where table_schema='mysql_employees' and table_name='salary'),
    (select create_time from information_schema.tables where table_schema='mysql_employees' and table_name='employee')
) as data_load_time_diff;

