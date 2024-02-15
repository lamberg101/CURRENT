DECLARE
  LPeriod  sttm_branch.current_period%type  :='M05';
  LCycle   sttm_branch.current_cycle%type    :='FY2013';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');
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
exit;