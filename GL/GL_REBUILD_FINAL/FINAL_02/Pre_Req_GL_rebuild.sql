-- NOTE
-- Run this script using FCC114 user
-- nohup sqlplus / as sysdba @Pre_Req_GL_rebuild.sql > Pre_Req_GL_rebuild.log &

set time on;
set timing on;

!date
Create index FCC114.K002_ACTB_HISTORY on FCC114.actb_history (AC_BRANCH,AC_CCY,cust_gl) parallel 24;
alter index FCC114.K002_ACTB_HISTORY noparallel;
!date
Create table FCC114.actb_history_000IDR /*+ PARALLEL 16 */ as Select * from FCC114.actb_history where ac_branch='000' and ac_ccy='IDR' and cust_gl='G';
!date
Create index FCC114.K001_ACTB_HISTORY_000IDR on FCC114.actb_history_000IDR (AC_NO, AC_CCY, PERIOD_CODE, FINANCIAL_CYCLE, AC_BRANCH) parallel 24;
alter index FCC114.K001_actb_history_000IDR noparallel;
!date
exit;



