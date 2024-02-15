set time on ;
set timing on;
!date

DECLARE
  LPeriod  sttm_branch.current_period%type  :='M08';
  LCycle   sttm_branch.current_cycle%type    :='FY2022';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
       Insert into tmp_trackglresbuilt_hist
       Select * from tmp_trackglresbuilt;
       execute immediate 'Truncate table tmp_trackglresbuilt';
       --DELETE FROM GLTBS_MISMATCH_MOV_TMP;
       --DELETE FROM GLTBS_MISMATCH_TMP;
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
  LCycle   sttm_branch.current_cycle%type    :='FY2022';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
       Insert into tmp_trackglresbuilt_hist
       Select * from tmp_trackglresbuilt;
       execute immediate 'Truncate table tmp_trackglresbuilt';
       --DELETE FROM GLTBS_MISMATCH_MOV_TMP;
       --DELETE FROM GLTBS_MISMATCH_TMP;
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
  LCycle   sttm_branch.current_cycle%type    :='FY2022';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');       
       Insert into tmp_trackglresbuilt_hist
       Select * from tmp_trackglresbuilt;
       execute immediate 'Truncate table tmp_trackglresbuilt';
       --DELETE FROM GLTBS_MISMATCH_MOV_TMP;
       --DELETE FROM GLTBS_MISMATCH_TMP;
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