Declare
L_BAL         number := 0;
L_BAL_LCY     number := 0;
L_DT          STTMS_DATES.TODAY%type;
P_PER Varchar2 (100):='M04';
P_FIN Varchar2 (100):='FY2022';
cursor CR_GL is
  select A.*
    from gltbs_gl_bal_tmp A,
         GLTMS_GLMASTER    B
   where A.BRANCH_CODE = '000'
         and A.PERIOD_CODE = P_PER
         and A.FIN_YEAR = P_FIN
         and A.GL_CODE = B.GL_CODE
         and B.GL_CODE in  ('205017005','485007019') --kush added for testing 
         and A.LEAF = 'Y'
         and B.CUSTOMER = 'I';
Begin
  global.pr_init('000', 'AFAISAL');
  Debug.pr_debug('GL',TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') ||'>>M04>>Inside Kush script query checking.....');
  select PC_END_DATE
      into L_DT
      from STTMS_PERIOD_CODES
     where PERIOD_CODE = P_PER
           and FIN_CYCLE = P_FIN;
  Debug.pr_debug('GL',TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') ||'>>M04>>L_DT: '||L_DT);
           
  For c1 in CR_GL  Loop
  Debug.pr_debug('GL',TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') ||'>>M04>>Started For GL_CODE: '||c1.GL_CODE||' with L_BAL: '||L_BAL||' #L_BAL_LCY: '||L_BAL_LCY); 
  if c1.CCY_CODE = 'IDR'  then
    Debug.pr_debug('GL',TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') ||'>>M04>>Here1 in LCY Case..');
    select nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(FCY_AMOUNT, 0)), 0) FSUM,
           nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(LCY_AMOUNT, 0)), 0) LSUM
      into L_BAL,
           L_BAL_LCY
      from ACTB_HISTORY_000IDR A, 
           STTMS_PERIOD_CODES  B
     where A.AC_NO = trim(c1.GL_CODE)
           and A.AC_CCY = c1.CCY_CODE
           and A.PERIOD_CODE = B.PERIOD_CODE
           and A.FINANCIAL_CYCLE = B.FIN_CYCLE
           and A.AC_BRANCH = c1.BRANCH_CODE
           and ((P_PER = 'FIN' and B.PC_START_DATE <= L_DT) or (P_PER <> 'FIN' and B.PC_START_DATE < L_DT));
    Debug.pr_debug('GL',TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') ||'>>M04>>LCY1-Fetched For  GL_CODE: '||c1.GL_CODE||' with L_BAL: '||L_BAL||' #L_BAL_LCY: '||L_BAL_LCY); 
            
  else
    Debug.pr_debug('GL',TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') ||'>>M04>>Here1 in FCY Case..');
    select nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(FCY_AMOUNT, 0)), 0) FSUM,
           nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(LCY_AMOUNT, 0)), 0) LSUM
      into L_BAL,
           L_BAL_LCY
      from ACTB_HISTORY       A,
           STTMS_PERIOD_CODES B
     where A.AC_NO = trim(c1.GL_CODE)
           and A.AC_CCY = c1.CCY_CODE
           and A.PERIOD_CODE = B.PERIOD_CODE
           and A.FINANCIAL_CYCLE = B.FIN_CYCLE
           and A.AC_BRANCH = c1.BRANCH_CODE
           and ((P_PER = 'FIN' and B.PC_START_DATE <= L_DT) or (P_PER <> 'FIN' and B.PC_START_DATE < L_DT));
    Debug.pr_debug('GL',TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') ||'>>M04>>FCY1-Fetched For  GL_CODE: '||c1.GL_CODE||'  with L_BAL: '||L_BAL||' #L_BAL_LCY: '||L_BAL_LCY);
  end if;
 End Loop;               
End;             
                 
