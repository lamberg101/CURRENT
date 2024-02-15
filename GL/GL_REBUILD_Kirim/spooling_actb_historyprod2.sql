set numformat 999,999,999,999,999,999,999.999
set linesize 10000
set serveroutput on
set echo on
set colsep ";"
set trimspool on
set pagesize 50000
spool actb_history_fy2022.spl

select * from fcc114.actb_history where period_code='M04' and financial_cycle='FY2022';

set echo off
spool off
exit;