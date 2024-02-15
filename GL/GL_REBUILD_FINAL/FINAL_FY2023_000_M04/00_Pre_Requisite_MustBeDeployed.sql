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


--create table
Create table GLTB_GL_BAL_Bkp as Select * from GLTB_GL_BAL;
!date
exit;
