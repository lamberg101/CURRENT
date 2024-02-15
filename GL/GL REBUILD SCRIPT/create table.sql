Create table ACTB_HISTORY_000IDR as Select * from actb_history where ac_branch='000' and ac_ccy='IDR';

 update GLTB_GL_BAL_ALL -- GLTBS_GL_BAL
         set DR_BAL     = L_DR_BAL,
             CR_BAL     = L_CR_BAL,
             DR_BAL_LCY = L_DR_BAL_LCY,
             CR_BAL_LCY = L_CR_BAL_LCY
       where BRANCH_CODE = EACH_RECORD.BRANCH_CODE
             and GL_CODE = trim(EACH_RECORD.GL_CODE)
             and CCY_CODE = EACH_RECORD.CCY_CODE
             and FIN_YEAR = EACH_RECORD.FIN_YEAR
             and PERIOD_CODE = EACH_RECORD.PERIOD_CODE;
			 
update GLTB_GL_BAL_ALL --GLTBS_GL_BAL
         set DR_MOV_LCY = EACH_RECORD.DR_MOV_LCY_ACT,
             CR_MOV_LCY = EACH_RECORD.CR_MOV_LCY_ACT,
             DR_MOV     = EACH_RECORD.DR_MOV_ACT,
             CR_MOV     = EACH_RECORD.CR_MOV_ACT
       where BRANCH_CODE = EACH_RECORD.BRANCH_CODE
             and GL_CODE = trim(EACH_RECORD.GL_CODE)
             and CCY_CODE = EACH_RECORD.CCY_CODE
             and FIN_YEAR = EACH_RECORD.FIN_YEAR
             and PERIOD_CODE = EACH_RECORD.PERIOD_CODE;			 