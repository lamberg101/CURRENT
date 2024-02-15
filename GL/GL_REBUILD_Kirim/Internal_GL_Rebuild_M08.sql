set serveroutput on


spool /home/oracle/GL_REBUILD/Intrnl_gl_rebuild_M08.spl


SELECT * FROM gltbs_mismatch
/
SELECT * FROM gltbs_mismatch_mov
/


DECLARE
	LPeriod  sttm_branch.current_period%type	:='M08';
	LCycle   sttm_branch.current_cycle%type		:='FY2022';
	LBranch  sttm_branch.branch_code%type   	:= '000'; 

BEGIN
	GLOBAL.PR_INIT(LBranch,'SYSTEM');

	     DELETE FROM gltbs_mismatch;
 
  	     DELETE FROM gltbs_mismatch_mov;
/*	if not glpks_rebuild.fn_check_int_gls(LBranch,LPeriod,LCycle	,'EUR') then
		DBMS_OUTPUT.PUT_LINE('FAILED....LST9630');
	end if;
	commit;*/

  	    IF NOT glpks_rebuild.fn_build_int_gls(LBranch,LPeriod,LCycle,global.lcy)
  	     THEN
  		     DBMS_OUTPUT.PUT_LINE('FAILED....LST9630');
  		     rollback;
  	     ELSE
  		     DBMS_OUTPUT.PUT_LINE('DONE....LST9630');
  		     commit;
  	     END IF;
END;
/

SELECT * FROM gltbs_mismatch
/
SELECT * FROM gltbs_mismatch_mov

SPOOL OFF;



