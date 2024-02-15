set time on;
set timing on;

DECLARE
  LPeriod  sttm_branch.current_period%type  :='M08';
  LCycle   sttm_branch.current_cycle%type    :='FY2015';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
       Insert into tmp_trackglresbuilt_hist
       Select * from tmp_trackglresbuilt;
       execute immediate 'Truncate table tmp_trackglresbuilt';
       IF NOT glpks_glrebuild_custom.fn_build_int_gls(LBranch,LPeriod,LCycle,global.lcy)
         THEN
           DBMS_OUTPUT.PUT_LINE('FAILED in glpks_glrebuild_testing...');
           rollback;
         ELSE
           DBMS_OUTPUT.PUT_LINE('DONE.');
           commit;
         END IF;
END;
/
!date

DECLARE
  LPeriod  sttm_branch.current_period%type  :='M09';
  LCycle   sttm_branch.current_cycle%type    :='FY2015';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
       Insert into tmp_trackglresbuilt_hist
       Select * from tmp_trackglresbuilt;
       execute immediate 'Truncate table tmp_trackglresbuilt';
       IF NOT glpks_glrebuild_custom.fn_build_int_gls(LBranch,LPeriod,LCycle,global.lcy)
         THEN
           DBMS_OUTPUT.PUT_LINE('FAILED in glpks_glrebuild_testing...');
           rollback;
         ELSE
           DBMS_OUTPUT.PUT_LINE('DONE.');
           commit;
         END IF;
END;
/
!date

DECLARE
  LPeriod  sttm_branch.current_period%type  :='M10';
  LCycle   sttm_branch.current_cycle%type    :='FY2015';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
       Insert into tmp_trackglresbuilt_hist
       Select * from tmp_trackglresbuilt;
       execute immediate 'Truncate table tmp_trackglresbuilt';
       IF NOT glpks_glrebuild_custom.fn_build_int_gls(LBranch,LPeriod,LCycle,global.lcy)
       THEN
         DBMS_OUTPUT.PUT_LINE('FAILED in glpks_glrebuild_testing...');
         rollback;
       ELSE
         DBMS_OUTPUT.PUT_LINE('DONE.');
         commit;
       END IF;
END;
/
!date

DECLARE
  LPeriod  sttm_branch.current_period%type  :='M11';
  LCycle   sttm_branch.current_cycle%type    :='FY2015';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
       Insert into tmp_trackglresbuilt_hist
       Select * from tmp_trackglresbuilt;
       execute immediate 'Truncate table tmp_trackglresbuilt';
       IF NOT glpks_glrebuild_custom.fn_build_int_gls(LBranch,LPeriod,LCycle,global.lcy)
       THEN
         DBMS_OUTPUT.PUT_LINE('FAILED in glpks_glrebuild_testing...');
         rollback;
       ELSE
         DBMS_OUTPUT.PUT_LINE('DONE.');
         commit;
       END IF;
END;
/
!date


Select * from tmp_trackglresbuilt

Select * from sttm_period_codes_all;
select A.*
        from GLTB_GL_BAL_ALL A,
             GLTMS_GLMASTER  B
       where A.BRANCH_CODE = '000'
             and A.PERIOD_CODE = 'M01'
             and A.FIN_YEAR = 'FY2013'
             and A.GL_CODE = B.GL_CODE
            -- and B.GL_CODE = '101001001' --kush added for testing 8 records
             and A.LEAF = 'Y'
             and B.CUSTOMER = 'I';


Create table GLTB_GL_BAL_Bkp as Select * from GLTB_GL_BAL;
Select * from GLTB_GL_BAL_Bkp

Truncate table GLTB_GL_BAL
Insert into GLTB_GL_BAL 
Select * from GLTB_GL_BAL_ALL;
exit;
