-- NOTE
-- Run this script using FCC114 user
-- nohup sqlplus FCC114/password @GLRebuildScript_Submission_Putty.sql > GLRebuildScript_Submission_Putty.log &
-- Sample Period_Code (M01, M02, M03, M04, M05, M06, M07, M08, M09, M10, M11, M12, FIN) and financial_cycle (FY2022, FY2023) etc.. 
-- Change the Period_Code and financial_cycle (FY2022, FY2023)

set time on;
set timing on;
!date
DECLARE
  LPeriod  sttm_branch.current_period%type  :='M02';
  LCycle   sttm_branch.current_cycle%type    :='FY2023';
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

exit;

