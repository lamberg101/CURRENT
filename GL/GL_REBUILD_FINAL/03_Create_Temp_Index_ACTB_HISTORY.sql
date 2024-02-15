--First create the tablespace.
--Make sure the owner has privilege/quota to that tablespace
--Make sure all privileges are fine

--run this script
--nohup sqlplus fccc114/password @03_Create_Temp_Index_ACTB_HISTORY.sql > 03_Create_Temp_Index_ACTB_HISTORY.log &

set time on;
set timing on;
!date
Create index K001_ACTB_HISTORY on ACTB_HISTORY (AC_NO, AC_CCY, PERIOD_CODE, FINANCIAL_CYCLE, AC_BRANCH) TABLESPACE PRD_TMP_TBS parallel 24;
alter index K001_ACTB_HISTORY noparallel;
/
!date
exit;