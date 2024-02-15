
-- Recompile package body first using PLSQL (file name --> 03_GLPKS_GLREBUILD_CUSTOM.sql)
-- Masukan pass untuk script dibawah ini, dan run via putty (jangan lupa nohup dan & di belakangnya)
-- nohup sqlplus FCC114/password @GLRebuildScript_Prd_M04_FY2023.sql > GLRebuildScript_Prd_M04_FY2023_01.log &

set time on;
set timing on;
!date
DECLARE
  LPeriod  sttm_branch.current_period%type  :='M04';
  LCycle   sttm_branch.current_cycle%type    :='FY2023';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
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

