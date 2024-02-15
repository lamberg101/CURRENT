-- NOTE
-- Run this script using FCC114 user
-- nohup sqlplus FCC114/password @01_Create_Table_Index_actb_history_000IDR.sql > 01_Create_Table_Index_actb_history_000IDR_M04.log &


set time on;
set timing on;

!date
Create table actb_history_000IDR /*+ PARALLEL 16 */ as Select * from actb_history where ac_branch='000' and ac_ccy='IDR';
!date
Create index K001_ACTB_HISTORY_000IDR on actb_history_000IDR (AC_NO, AC_CCY, PERIOD_CODE, FINANCIAL_CYCLE, AC_BRANCH) parallel 24;
alter index K001_actb_history_000IDR noparallel;
!date
exit;



