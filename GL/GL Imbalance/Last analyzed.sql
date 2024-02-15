Check last analyzed dates for the object in Oracle

Check the whole schema stats max or min date for objects:


select owner,min(last_Analyzed), max(last_analyzed) from dba_tables group by owner order by 1;
Check the last analyzed date for table

col table_name for a15
select table_name, to_char(last_analyzed,'DD-MON-YYYY HH24:MI:SS') from dba_tables where owner='HR' AND TABLE_NAME = 'EMPLOYEES';
Check last analyzed date for partition of the table


col table_name for a15
col partition_name for a15
SELECT table_name, partition_name,to_char(last_analyzed,'DD-MON-YYYY HH24:MI:SS') "LASTANALYZED" FROM DBA_TAB_PARTITIONS 
WHERE table_name='TRAN' AND partition_name like 'TRAN2021%' order by partition_name;
Checl last analyzed for the column of the table


-- Check stats of column in table
Col table_name for a15
col column_name for a15
col lastanalyzed for a22
SELECT table_name,column_name,to_char(last_analyzed,'DD-MON-YYYY HH24:MI:SS') "LASTANALYZED" from DBA_TAB_COL_STATISTICS;
Check last analyzed for the index of a table

SELECT table_name, index_name, to_char(last_analyzed,'DD-MON-YYYY HH24:MI:SS') "LASTANALYZED" FROM DBA_INDEXES;