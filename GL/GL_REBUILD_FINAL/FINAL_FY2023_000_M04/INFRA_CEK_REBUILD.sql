--Check Tablespace
Select   ddf.TABLESPACE_NAME "TABLESPACE", ddf.BYTES "bytes (MB)", ddf.MAXBYTES "MAXSIZE (MB)", (ddf.BYTES - dfs.bytes) "USED (MB)", ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",  round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,  round(sum(BYTES)/1024/1024,2) bytes,  round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes from   dba_data_files group  by TABLESPACE_NAME) ddf,  (select TABLESPACE_NAME,  round(sum(BYTES)/1024/1024,2) bytes  from   dba_free_space group  by TABLESPACE_NAME) dfs where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME order by (((ddf.BYTES - dfs.BYTES))/ddf.MAXBYTES) desc, (ddf.MAXBYTES-(ddf.BYTES - dfs.bytes));

----------------------------------------------------------------------------------------------------------------

--ASM
SELECT b.group_number disk_group_number,  b.name  disk_file_name,   b.total_mb  total_mb,  b.free_mb free_mb,  (b.total_mb - b.free_mb) used_mb,decode(b.total_mb,0,0,(ROUND((1- (b.free_mb / b.total_mb))*100, 2)))   pct_used, 
(100- decode(b.total_mb,0,0,(ROUND((1- (b.free_mb / b.total_mb))*100, 2)))) pct_free FROM v$asm_diskgroup b ORDER BY b.group_number;

----------------------------------------------------------------------------------------------------------------

--REDOLOG/SWITCH
select to_char(first_time,'DD-MON-RR') day, to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'00',1,0)),'999') "00",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'01',1,0)),'999') "01",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'02',1,0)),'999') "02",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'03',1,0)),'999') "03", to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'04',1,0)),'999') "04",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'05',1,0)),'999') "05",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'06',1,0)),'999') "06",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'07',1,0)),'999') "07", to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'08',1,0)),'999') "08",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'09',1,0)),'999') "09",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'10',1,0)),'999') "10",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'11',1,0)),'999') "11",
to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'12',1,0)),'999') "12",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'13',1,0)),'999') "13",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'14',1,0)),'999') "14",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'15',1,0)),'999') "15", to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'16',1,0)),'999') "16",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'17',1,0)),'999') "17",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'18',1,0)),'999') "18",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'19',1,0)),'999') "19",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'20',1,0)),'999') "20",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'21',1,0)),'999') "21",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'22',1,0)),'999') "22",to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'23',1,0)),'999') "23", sum(1) "TOTAL_IN_DAY" from v$log_history group by to_char(first_time,'DD-MON-RR') order by to_date(day) desc;


----------------------------------------------------------------------------------------------------------------

--FRA
SELECT name recovery_file_dest, space_limit / 1024 / 1024 / 1024 space_limit_GB, space_used / 1024 / 1024 / 1024 space_used_GB, ROUND((space_used / space_limit)*100, 2) space_used_pct, 
space_reclaimable space_reclaimable, ROUND((space_reclaimable / space_limit)*100, 2) pct_reclaimable, number_of_files number_of_files FROM v$recovery_file_dest;


----------------------------------------------------------------------------------------------------------------

--SESSION
select a.INST_ID,a.machine, 
--a.PROGRAM, 
a.status, a.osuser,a.username,a.sid,a.serial#,a.SQL_ID,a.EVENT, (case when trunc(last_call_et)<60 then to_char(trunc(last_call_et))||' Sec(s)' when trunc(last_call_et/60)<60 then to_char(trunc(last_call_et/60))||' Min(s)' when trunc(last_call_et/60/60)<24 then to_char(trunc(last_call_et/60/60))||' Hour(s)' when trunc(last_call_et/60/60/24)>=1  then to_char(trunc(last_call_et/60/60/24))||' Day(s)'
end) as time,sql_fulltext from gv$session a,gv$sqlarea b where a.sql_address=b.address and a.sql_hash_value=b.hash_value and a.username is not null
--and a.status='INACTIVE' --and a.username not in ('SYS','FCCDEV')
and users_executing>0 order by time desc;


----------------------------------------------------------------------------------------------------------------

--LONGOPS
SELECT s.sid, s.serial#, s.machine, sl.message,ROUND(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed,ROUND(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remaining,ROUND(sl.sofar/sl.totalwork*100, 2) progress_pct
FROM   gv$session s, gv$session_longops sl WHERE  s.sid     = sl.sid AND    s.serial# = sl.serial# and sl.totalwork>sl.sofar;


----------------------------------------------------------------------------------------------------------------

-- UTIL DB DENGAN %
select inst_id,resource_name,current_utilization,max_utilization,INITIAL_ALLOCATION,LIMIT_VALUE,round(((current_utilization*100)/(INITIAL_ALLOCATION)),2) as "Process limit %"
from gv$resource_limit where resource_name in ('sessions', 'processes');

----------------------------------------------------------------------------------------------------------------

-- BACKUP
SELECT end_time, status, session_key, session_recid, session_stamp, command_id, start_time, time_taken_display duration, input_type, output_device_type device, input_bytes_display, output_bytes_display, output_bytes_per_sec_display per_sec
FROM (SELECT end_time, status, session_key, session_recid, session_stamp, command_id, to_char(start_time,'dd/mm/yyyy hh24:mi') start_time, time_taken_display, input_type, output_device_type, input_bytes_display, output_bytes_display, output_bytes_per_sec_display FROM v$rman_backup_job_details ORDER BY end_time desc);


--backup error
select output from GV$RMAN_OUTPUT where session_recid = &SESSION_RECID and session_stamp = &SESSION_STAMP order by recid;

----------------------------------------------------------------------------------------------------------------

--CHECK TEMP TABLESPACE
select status, file_name, tablespace_name from dba_temp_files where tablespace_name='TEMP';
select b.Total_MB,  b.Total_MB - round(a.used_blocks*8/1024) Current_Free_MB, round(used_blocks*8/1024) Current_Used_MB, round(max_used_blocks*8/1024) Max_used_MB
from v$sort_segment a, (select round(sum(bytes)/1024/1024) Total_MB from dba_temp_files ) b;	

--Check TEMP
SELECT d.tablespace_name "Name", d.contents "Type", TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'99,999,990.900') "Size (M)", TO_CHAR(NVL(t.bytes,0)/1024/1024,'99999,999.999') ||'/'||TO_CHAR(NVL(a.bytes/1024/1024, 0),'99999,999.999') "Used (M)",
TO_CHAR(NVL(t.bytes / a.bytes * 100, 0), '990.00') "Used %" FROM sys.dba_tablespaces d, (select tablespace_name, sum(bytes) bytes from dba_temp_files group by tablespace_name) a, (select tablespace_name, sum(bytes_cached) bytes from v$temp_extent_pool group by tablespace_name) t WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = t.tablespace_name(+) AND d.extent_management like 'LOCAL' AND d.contents like 'TEMPORARY';


