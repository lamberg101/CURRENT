DECLARE
  LPeriod  sttm_branch.current_period%type  :='M03';
  LCycle   sttm_branch.current_cycle%type    :='FY2022';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');
       DELETE FROM GLTBS_MISMATCH_M03_1;
       DELETE FROM GLTBS_MISMATCH_MOV_M03_1;
       execute immediate 'Truncate table tmp_trackglresbuilt1';
        IF NOT glpks_glrebuild_testing.fn_build_int_gls(LBranch,LPeriod,LCycle,global.lcy)
         THEN
           DBMS_OUTPUT.PUT_LINE('FAILED....LST9630');
           rollback;
         ELSE
           DBMS_OUTPUT.PUT_LINE('DONE....LST9630');
           commit;
         END IF;
END;
/
