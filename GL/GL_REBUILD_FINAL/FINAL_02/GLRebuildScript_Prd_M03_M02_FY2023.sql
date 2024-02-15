
-- Recompile package body first using PLSQL (file name --> 03_GLPKS_GLREBUILD_CUSTOM.sql)
-- Masukan pass dan run (dari nohup -> &)
-- nohup sqlplus FCC114/password @GLRebuildScript_Prd_M03_M02_FY2023.sql > GLRebuildScript_Prd_M03_M02_FY2023.log &

set time on;
set timing on;
!date
DECLARE
  LPeriod  sttm_branch.current_period%type  :='M03';
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

