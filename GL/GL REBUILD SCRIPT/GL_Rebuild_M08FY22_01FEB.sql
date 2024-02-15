set time on;
spool GL_Rebuild_M08FY22_01FEB_1.spl


SELECT * from     ---65446739   -- UAT ---65446739
(
SELECT
--*
BRANCH_CODE
,ROUND(sum(decode(CATEGORY ,'1',1,1) * (DR_BAL_LCY - CR_BAL_LCY)),0)SELISIH
FROM gltbs_gl_bal_tmp a
WHERE FIN_YEAR = 'FY2022'
AND PERIOD_CODE = 'M08'
AND BRANCH_CODE = '000'
AND LEAF = 'Y'
AND CATEGORY IN ('1','2','3','4')
AND NOT (CATEGORY IN ('3','4') AND CCY_CODE !='IDR')
GROUP BY BRANCH_CODE--,CATEGORY
)
WHERE selisih <> 0;


DECLARE
  LPeriod  sttm_branch.current_period%type  :='M08';
  LCycle   sttm_branch.current_cycle%type    :='FY2022';
  LBranch  sttm_branch.branch_code%type     := '000'; 

BEGIN
       GLOBAL.PR_INIT(LBranch,'SYSTEM');
       DELETE FROM gltbs_mismatch;
       DELETE FROM gltbs_mismatch_mov;
       execute immediate 'Truncate table tmp_trackglresbuilt';
        IF NOT glpks_glrebuild_tmp.fn_build_int_gls(LBranch,LPeriod,LCycle,global.lcy)
         THEN
           DBMS_OUTPUT.PUT_LINE('FAILED....LST9630');
           rollback;
         ELSE
           DBMS_OUTPUT.PUT_LINE('DONE....LST9630');
           commit;
         END IF;
END;
/

SELECT * from     ---65446739   -- UAT ---65446739
(
SELECT
--*
BRANCH_CODE
,ROUND(sum(decode(CATEGORY ,'1',1,1) * (DR_BAL_LCY - CR_BAL_LCY)),0)SELISIH
FROM gltbs_gl_bal_tmp a
WHERE FIN_YEAR = 'FY2022'
AND PERIOD_CODE = 'M08'
AND BRANCH_CODE = '000'
AND LEAF = 'Y'
AND CATEGORY IN ('1','2','3','4')
AND NOT (CATEGORY IN ('3','4') AND CCY_CODE !='IDR')
GROUP BY BRANCH_CODE--,CATEGORY
)
WHERE selisih <> 0;

spool off;
exit;