-- NOTE
-- Run this script using FCC114 user
-- nohup sqlplus / as sysdba @06_DROP_Temp_Table_Index_actb_history.sql > 06_DROP_Temp_Table_Index_actb_history_01.log &

set time on;
set timing on;

!date
DROP TABLE FCC114.actb_history_000IDR PURGE;
DROP index FCC114.K001_ACTB_HISTORY;
!date
exit;
