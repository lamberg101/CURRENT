-- NOTE
-- Run this script using FCC114 user
-- nohup sqlplus FCC114/password @01_Pre_Requisite_MustBeDeployed.sql > 01_Pre_Requisite_MustBeDeployed.log &


set time on;
set timing on;

-- Create table
create table TMP_TRACKGLRESBUILT
(
  sr_no     NUMBER,
  datetime  DATE default systimestamp,
  source_nm VARCHAR2(1000),
  message   VARCHAR2(4000)
);
!date
-- Create table
create table TMP_TRACKGLRESBUILT_HIST
(
  sr_no     NUMBER,
  datetime  VARCHAR2(1000),
  source_nm VARCHAR2(1000),
  message   VARCHAR2(3000)
);

!date
Create table GLTB_GL_BAL_Bkp as Select * from GLTB_GL_BAL;
!date
Create table actb_history_000IDR /*+ PARALLEL 16 */ as Select * from actb_history where ac_branch='000' and ac_ccy='IDR';
!date
Create index K001_ACTB_HISTORY_000IDR on actb_history_000IDR (AC_NO, AC_CCY, PERIOD_CODE, FINANCIAL_CYCLE, AC_BRANCH) parallel 24;
alter index K001_actb_history_000IDR noparallel;
!date
exit;

--Note
--Temp index in Original table (actb_history) must be created as well
