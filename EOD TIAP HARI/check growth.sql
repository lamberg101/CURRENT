https://oracleagent.wordpress.com/2022/06/28/database-growth/

--TO CHECK THE DATABASE GROWTH

SET LINESIZE 200
SET PAGESIZE 200
COL "Database Size" FORMAT a13
COL "Used Space" FORMAT a11
COL "Used in %" FORMAT a11
COL "Free in %" FORMAT a11
COL "Database Name" FORMAT a13
COL "Free Space" FORMAT a12
COL "Growth DAY" FORMAT a11
COL "Growth WEEK" FORMAT a12
COL "Growth DAY in %" FORMAT a16
COL "Growth WEEK in %" FORMAT a16
SELECT
(select min(creation_time) from v$datafile) "Create Time",
(select name from v$database) "Database Name",
ROUND((SUM(USED.BYTES) / 1024 / 1024 ),2) || ' MB' "Database Size",
ROUND((SUM(USED.BYTES) / 1024 / 1024 ) - ROUND(FREE.P / 1024 / 1024 ),2) || ' MB' "Used Space",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 )) / ROUND(SUM(USED.BYTES) / 1024 / 1024 ,2)*100,2) || '% MB' "Used in %",
ROUND((FREE.P / 1024 / 1024 ),2) || ' MB' "Free Space",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - ((SUM(USED.BYTES) / 1024 / 1024 ) - ROUND(FREE.P / 1024 / 1024 )))/ROUND(SUM(USED.BYTES) / 1024 / 1024,2 )*100,2) || '% MB' "Free in %",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile),2) || ' MB' "Growth DAY",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile)/ROUND((SUM(USED.BYTES) / 1024 / 1024 ),2)*100,3) || '% MB' "Growth DAY in %",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile)*7,2) || ' MB' "Growth WEEK",
ROUND((((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile)/ROUND((SUM(USED.BYTES) / 1024 / 1024 ),2)*100)*7,3) || '% MB' "Growth WEEK in %"
FROM    (SELECT BYTES FROM V$DATAFILE
UNION ALL
SELECT BYTES FROM V$TEMPFILE
UNION ALL
SELECT BYTES FROM V$LOG) USED,
(SELECT SUM(BYTES) AS P FROM DBA_FREE_SPACE) FREE
GROUP BY FREE.P;



select to_char(creation_time, 'RRRR Month') "Month",
sum(bytes)/1024/1024 "Growth in Meg"
from sys.v_$datafile
where creation_time > SYSDATE-365
group by to_char(creation_time, 'RRRR Month');




SELECT TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY') days
, ts.tsname
, max(round((tsu.tablespace_size* dt.block_size )/(1024*1024),2) ) cur_size_MB
, max(round((tsu.tablespace_usedsize* dt.block_size )/(1024*1024),2)) usedsize_MB
FROM DBA_HIST_TBSPC_SPACE_USAGE tsu
, DBA_HIST_TABLESPACE_STAT ts
, DBA_HIST_SNAPSHOT sp
, DBA_TABLESPACES dt
WHERE tsu.tablespace_id= ts.ts#
AND tsu.snap_id = sp.snap_id
AND ts.tsname = dt.tablespace_name
AND ts.tsname NOT IN ('SYSAUX','SYSTEM')
GROUP BY TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), ts.tsname
ORDER BY ts.tsname, days;