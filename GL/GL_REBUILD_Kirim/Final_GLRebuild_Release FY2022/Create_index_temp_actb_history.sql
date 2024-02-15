
set time on;
set timing on;
!date
--Create index FCC114.K001_ACTB_HISTORY on FCC114.ACTB_HISTORY (AC_NO, AC_CCY, PERIOD_CODE, FINANCIAL_CYCLE, AC_BRANCH) parallel 24;
--alter index FCC114.K001_ACTB_HISTORY noparallel;
/
!date
exit;
