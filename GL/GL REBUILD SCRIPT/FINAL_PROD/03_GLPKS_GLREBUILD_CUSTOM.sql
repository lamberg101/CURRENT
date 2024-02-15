create or replace package body GLPKS_GLREBUILD_CUSTOM as
  /*===========================================================================================================================================================================================================================
  ============================================================================================================================================================================================================================= 
           This package is created as Customization for BMI purpose only....
           
           Creation by  : Kushab Dhule
           Date         : 01-Feb-2023
           Reason       : To resolve GL imbalance issues by improving performance
           
         Note: Table "ACTB_HISTORY_000IDR" must be created before using this package to use for GL Imbalance correction for respective branch to be corrected. You can use below DDL if required:
         Create table ACTB_HISTORY_000IDR as Select * from actb_history where ac_branch='000' and ac_ccy='IDR';  -- this is specially for Branch 000 & IDR case only...
          
  =============================================================================================================================================================================================================================
  =============================================================================================================================================================================================================================*/

  l_srno number := 1;

  procedure DBG(X varchar2) is
  begin
    debug.pr_debug('GL', TO_char(sysdate, 'DDMONYYYY HH24:MM:SS') || '>>glpks_glrebuild_tmp>>' || x);
  end DBG;

  procedure Pr_insert_tracktable(p_sr_no number,
                                 p_msg   in varchar2) is
    pragma autonomous_transaction;
  begin
    insert into tmp_trackglresbuilt
      (sr_no,
       source_nm,
       message)
    values
      (p_sr_no,
       'GLPKS_GLREBUILD_CUSTOM',
       p_msg);
    commit;
  end Pr_insert_tracktable;

  procedure PR_PRDWISE_ACTB_HISTORY_000IDR(p_GL_CODE       varchar2,
                                           p_BRN           varchar2,
                                           P_DT            date,
                                           P_total_BAL     out number,
                                           P_total_BAL_LCY out number) is
    L_BAL           number := 0;
    L_BAL_LCY       number := 0;
    L_total_BAL     number := 0;
    L_total_BAL_LCY number := 0;
  begin
    L_total_BAL     := 0;
    L_total_BAL_LCY := 0;
    l_srno          := l_srno + 1;
    Pr_insert_tracktable(l_srno,
                         'K-Inside PR_CALPERIODWISE_ACTB_HIST, Started For Branch: ' || p_BRN || ' with GL_CODE: ' ||
                         p_GL_CODE || ' #P_DT: ' || P_DT || ' #L_total_BAL: ' || L_total_BAL);
    for ix in (select * from STTMS_PERIOD_CODES where PC_START_DATE < P_DT order by FIN_CYCLE)
    loop
      L_BAL     := 0;
      L_BAL_LCY := 0;
      /* l_srno    := l_srno + 1;
      Pr_insert_tracktable(l_srno,
                           'K1-Started For FINANCIAL_CYCLE: ' || ix.fin_cycle || ' with PERIOD_CODE: ' ||
                           ix.period_code);*/
      select nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(FCY_AMOUNT, 0)), 0) FSUM,
             nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(LCY_AMOUNT, 0)), 0) LSUM
        into L_BAL,
             L_BAL_LCY
        from ACTB_HISTORY_000IDR A
       where A.AC_NO = p_GL_CODE
             and A.AC_CCY = 'IDR'
             and A.PERIOD_CODE = ix.period_code
             and A.FINANCIAL_CYCLE = ix.fin_cycle
             and A.AC_BRANCH = p_BRN;
      L_total_BAL     := L_total_BAL + L_BAL;
      L_total_BAL_LCY := L_total_BAL_LCY + L_BAL_LCY;
      /*l_srno          := l_srno + 1;
      Pr_insert_tracktable(l_srno,
                           'K3>>L_BAL: ' || L_BAL || ' #L_BAL_LCY: ' || L_BAL_LCY || ' #L_total_BAL: ' || L_total_BAL ||
                           ' #L_total_BAL_LCY: ' || L_total_BAL_LCY);*/
    end loop;
  
    P_total_BAL     := L_total_BAL;
    P_total_BAL_LCY := L_total_BAL_LCY;
    l_srno          := l_srno + 1;
    Pr_insert_tracktable(l_srno,
                         'K4>>Returning from PR_CALPERIODWISE_ACTB_HIST and Finally For Branch: ' || p_BRN ||
                         ' with GL_CODE: ' || p_GL_CODE || ' Final P_total_BAL: ' || P_total_BAL);
  
  end PR_PRDWISE_ACTB_HISTORY_000IDR;

  function FN_CHECK_INT_GLS(P_BRN in STTMS_BRANCH.BRANCH_CODE%type,
                            P_PER in STTMS_BRANCH.CURRENT_PERIOD%type,
                            P_FIN in STTMS_BRANCH.CURRENT_CYCLE%type,
                            P_LCY in CYTMS_CCY_DEFN.CCY_CODE%type) return boolean is
    cursor CR_GL is
      select A.*
        from GLTB_GL_BAL    A,
             GLTMS_GLMASTER B
       where A.BRANCH_CODE = P_BRN
             and A.PERIOD_CODE = P_PER
             and A.FIN_YEAR = P_FIN
             and A.GL_CODE = B.GL_CODE
             and A.LEAF = 'Y'
             and B.CUSTOMER = 'I';
  
    type ty_cr_gl is table of CR_GL%rowtype index by binary_integer;
    L_ty_cr_gl ty_cr_gl;
  
    L_BAL          number := 0;
    L_BAL_LCY      number := 0;
    L_T_BAL_LCYFCY number := 0;
    L_BAL_LCY_SUM  number := 0;
    L_BAL_LCY_MIS  number := 0;
    L_DT           STTMS_DATES.TODAY%type;
    L_FINDT        STTMS_DATES.TODAY%type;
    L1             number := 0;
    L2             number := 0;
    L3             number := 0;
    L4             number := 0;
  
    L_total_cnt number := 0;
  
  begin
    l_srno := l_srno + 1;
    Pr_insert_tracktable(l_srno,
                         'Inside glpks_glrebuild_tmp_1.FN_CHECK_INT_GLS with Brn: ' || P_BRN || ' #P_PER: ' || P_PER ||
                         ' #P_FIN: ' || P_FIN || ' #P_LCY: ' || P_LCY);
  
    delete Gltbs_Mismatch
     where BRANCH_CODE = P_BRN
           and PERIOD_CODE = P_PER
           and FIN_YEAR = P_FIN;
    delete GLTBS_MISMATCH_MOV
     where BRANCH_CODE = P_BRN
           and PERIOD_CODE = P_PER
           and FIN_YEAR = P_FIN;
    commit;
    select PC_END_DATE
      into L_DT
      from STTMS_PERIOD_CODES
     where PERIOD_CODE = P_PER
           and FIN_CYCLE = P_FIN;
  
    l_srno := l_srno + 1;
    Pr_insert_tracktable(l_srno, 'K-L_DT: ' || L_DT);
  
    if CR_GL%isopen
    then
      close CR_GL;
    end if;
    L_total_cnt := 0;
    open CR_GL;
    loop
      if L_ty_cr_gl.COUNT > 0
      then
        L_ty_cr_gl.delete;
      end if;
    
      fetch CR_GL bulk collect
        into L_ty_cr_gl limit 3000;
    
      if L_ty_cr_gl.COUNT > 0
      then
        for ix in 1 .. L_ty_cr_gl.COUNT
        loop
          l_srno := l_srno + 1;
          Pr_insert_tracktable(l_srno,
                               'K-For ix: ' || ix || ' with l_srno: ' || l_srno || ' #GL_CODE: ' || L_ty_cr_gl(ix)
                               .GL_CODE || ' with CCY_CODE: ' || L_ty_cr_gl(ix).CCY_CODE ||
                                ' #TotallyCompletedTillnow: ' || L_total_cnt);
          L_total_cnt := L_total_cnt + 1;
        
          if ((L_ty_cr_gl(ix).CATEGORY in ('1', '2', '5', '6', '7', '8', '9')) or
             (L_ty_cr_gl(ix).CATEGORY in ('3', '4') and L_ty_cr_gl(ix).CCY_CODE <> P_LCY))
          then
            L_BAL     := 0;
            L_BAL_LCY := 0;
          
            if L_ty_cr_gl(ix).CCY_CODE = 'IDR'
            then
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno, 'Here1 in LCY Case..');
              L_FINDT := null;
              if P_PER = 'FIN'
              then
                L_FINDT := L_DT + 1;
              else
                L_FINDT := L_DT;
              end if;
            
              PR_PRDWISE_ACTB_HISTORY_000IDR(trim(L_ty_cr_gl(ix).GL_CODE),
                                             L_ty_cr_gl(ix).BRANCH_CODE,
                                             L_FINDT,
                                             L_BAL,
                                             L_BAL_LCY);
            
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno,
                                   'K-LCY1 for ix: ' || ix || ' #L_BAL: ' || L_BAL || ' #L_BAL_LCY: ' || L_BAL_LCY);
            
            else
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno, 'Here1 in FCY Case..');
              select nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(FCY_AMOUNT, 0)), 0) FSUM,
                     nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(LCY_AMOUNT, 0)), 0) LSUM
                into L_BAL,
                     L_BAL_LCY
                from ACTB_HISTORY       A,
                     STTMS_PERIOD_CODES B
               where A.AC_NO = trim(L_ty_cr_gl(ix).GL_CODE)
                     and A.AC_CCY = L_ty_cr_gl(ix).CCY_CODE
                     and A.PERIOD_CODE = B.PERIOD_CODE
                     and A.FINANCIAL_CYCLE = B.FIN_CYCLE
                     and A.AC_BRANCH = L_ty_cr_gl(ix).BRANCH_CODE
                     and ((P_PER = 'FIN' and B.PC_START_DATE <= L_DT) or (P_PER <> 'FIN' and B.PC_START_DATE < L_DT));
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno,
                                   'K-FCY1 for ix: ' || ix || ' #L_BAL: ' || L_BAL || ' #L_BAL_LCY: ' || L_BAL_LCY);
            end if;
          
            L_BAL_LCY_SUM := NVL(L_BAL_LCY_SUM, 0) + NVL(L_BAL_LCY, 0);
          
            if (((NVL(L_ty_cr_gl(ix).CR_BAL, 0) - NVL(L_ty_cr_gl(ix).DR_BAL, 0)) <> NVL(L_BAL, 0)) or
               ((NVL(L_ty_cr_gl(ix).CR_BAL_LCY, 0) - NVL(L_ty_cr_gl(ix).DR_BAL_LCY, 0)) <> NVL(L_BAL_LCY, 0)))
            then
              L_BAL_LCY_MIS := NVL(L_BAL_LCY_MIS, 0) + NVL(L_BAL_LCY, 0) - NVL(L_ty_cr_gl(ix).CR_BAL_LCY, 0) +
                               NVL(L_ty_cr_gl(ix).DR_BAL_LCY, 0);
            
              insert into Gltbs_Mismatch
                (BRANCH_CODE,
                 GL_CODE,
                 CCY_CODE,
                 PERIOD_CODE,
                 FIN_YEAR,
                 CATEGORY,
                 BAL,
                 BAL_LCY,
                 ACTUAL_BAL,
                 ACTUAL_BAL_LCY)
              values
                (L_ty_cr_gl(ix).BRANCH_CODE,
                 trim(L_ty_cr_gl(ix).GL_CODE),
                 L_ty_cr_gl(ix).CCY_CODE,
                 P_PER,
                 P_FIN,
                 L_ty_cr_gl(ix).CATEGORY,
                 NVL(L_ty_cr_gl(ix).CR_BAL, 0) - NVL(L_ty_cr_gl(ix).DR_BAL, 0),
                 NVL(L_ty_cr_gl(ix).CR_BAL_LCY, 0) - NVL(L_ty_cr_gl(ix).DR_BAL_LCY, 0),
                 NVL(L_BAL, 0),
                 NVL(L_BAL_LCY, 0));
            
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno, 'Inserted into Gltbs_Mismatch');
            end if;
          
            L1 := 0;
            L2 := 0;
            L3 := 0;
            L4 := 0;
          
            l_srno := l_srno + 1;
            Pr_insert_tracktable(l_srno, 'Here2 in FCY Case..');
            select nvl(sum(DECODE(DRCR_IND, 'D', NVL(LCY_AMOUNT, 0), 0)), 0) DR_AMT,
                   nvl(sum(DECODE(DRCR_IND, 'C', NVL(LCY_AMOUNT, 0), 0)), 0) CR_AMT,
                   nvl(sum(DECODE(DRCR_IND, 'D', NVL(FCY_AMOUNT, 0), 0)), 0) DR_FCY_AMT,
                   nvl(sum(DECODE(DRCR_IND, 'C', NVL(FCY_AMOUNT, 0), 0)), 0) CR_FCY_AMT
              into L1,
                   L2,
                   L3,
                   L4
              from ACTB_HISTORY A
             where AC_NO = trim(L_ty_cr_gl(ix).GL_CODE)
                   and AC_CCY = L_ty_cr_gl(ix).CCY_CODE
                   and A.PERIOD_CODE = P_PER
                   and A.FINANCIAL_CYCLE = P_FIN
                   and AC_BRANCH = P_BRN;
          
            l_srno := l_srno + 1;
            Pr_insert_tracktable(l_srno,
                                 'K-FCY2 for ix: ' || ix || ' #L1: ' || L1 || ':' || L2 || ':' || L3 || ':' || L4);
          
            if (NVL(L_ty_cr_gl(ix).DR_MOV_LCY, 0) <> NVL(L1, 0) or NVL(L_ty_cr_gl(ix).DR_MOV, 0) <> NVL(L3, 0) or
               NVL(L_ty_cr_gl(ix).CR_MOV_LCY, 0) <> NVL(L2, 0) or NVL(L_ty_cr_gl(ix).CR_MOV, 0) <> NVL(L4, 0))
            then
              insert into GLTBS_MISMATCH_MOV
                (BRANCH_CODE,
                 GL_CODE,
                 CCY_CODE,
                 PERIOD_CODE,
                 FIN_YEAR,
                 CATEGORY,
                 DR_MOV,
                 CR_MOV,
                 DR_MOV_LCY,
                 CR_MOV_LCY,
                 DR_MOV_ACT,
                 CR_MOV_ACT,
                 DR_MOV_LCY_ACT,
                 CR_MOV_LCY_ACT)
              values
                (L_ty_cr_gl(ix).BRANCH_CODE,
                 trim(L_ty_cr_gl(ix).GL_CODE),
                 L_ty_cr_gl(ix).CCY_CODE,
                 P_PER,
                 P_FIN,
                 L_ty_cr_gl(ix).CATEGORY,
                 NVL(L_ty_cr_gl(ix).DR_MOV, 0),
                 NVL(L_ty_cr_gl(ix).CR_MOV, 0),
                 NVL(L_ty_cr_gl(ix).DR_MOV_LCY, 0),
                 NVL(L_ty_cr_gl(ix).CR_MOV_LCY, 0),
                 NVL(L3, 0),
                 NVL(L4, 0),
                 NVL(L1, 0),
                 NVL(L2, 0));
            
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno, 'Inserted into GLTBS_MISMATCH_MOV');
            end if;
          else
          
            L_BAL_LCY      := 0;
            L_T_BAL_LCYFCY := 0;
            l_srno         := l_srno + 1;
            Pr_insert_tracktable(l_srno, 'Here3 in LCY and FCY Both Case..');
          
            L_FINDT := null;
            if P_PER = 'FIN'
            then
              L_FINDT := L_DT + 1;
            else
              L_FINDT := L_DT;
            end if;
          
            PR_PRDWISE_ACTB_HISTORY_000IDR(trim(L_ty_cr_gl(ix).GL_CODE),
                                           L_ty_cr_gl(ix).BRANCH_CODE,
                                           L_FINDT,
                                           L_BAL,
                                           L_BAL_LCY);
            L_T_BAL_LCYFCY := L_BAL_LCY;
            l_srno         := l_srno + 1;
            Pr_insert_tracktable(l_srno,
                                 'K-FCY3 for ix: ' || ix || ' #L_BAL_LCY: ' || L_BAL_LCY || ' #L_T_BAL_LCYFCY: ' ||
                                 L_T_BAL_LCYFCY);
          
            /*select nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(LCY_AMOUNT, 0)), 0) LSUM
             into L_BAL_LCY
             from ACTB_HISTORY       A,
                  STTMS_PERIOD_CODES B
            where A.AC_NO = trim(L_ty_cr_gl(ix).GL_CODE)
                  and A.PERIOD_CODE = B.PERIOD_CODE
                  and A.FINANCIAL_CYCLE = B.FIN_CYCLE
                  and A.AC_BRANCH = L_ty_cr_gl(ix).BRANCH_CODE
                  and ((P_PER = 'FIN' and B.PC_START_DATE <= L_DT) or (P_PER <> 'FIN' and B.PC_START_DATE < L_DT));*/
            L_BAL_LCY := 0;
            select nvl(sum(DECODE(DRCR_IND, 'D', -1, 1) * NVL(LCY_AMOUNT, 0)), 0) LSUM
              into L_BAL_LCY
              from ACTB_HISTORY       A,
                   STTMS_PERIOD_CODES B
             where A.AC_NO = trim(L_ty_cr_gl(ix).GL_CODE)
                   and A.PERIOD_CODE = B.PERIOD_CODE
                   and A.FINANCIAL_CYCLE = B.FIN_CYCLE
                   and A.AC_CCY <> 'IDR'
                   and A.AC_BRANCH = L_ty_cr_gl(ix).BRANCH_CODE
                   and ((P_PER = 'FIN' and B.PC_START_DATE <= L_DT) or (P_PER <> 'FIN' and B.PC_START_DATE < L_DT));
          
            l_srno := l_srno + 1;
            Pr_insert_tracktable(l_srno,
                                 'So Before adding FCY L_BAL_LCY: ' || L_BAL_LCY || ' #L_T_BAL_LCYFCY: ' ||
                                 L_T_BAL_LCYFCY);
          
            L_T_BAL_LCYFCY := L_T_BAL_LCYFCY + L_BAL_LCY;
            L_BAL_LCY      := L_T_BAL_LCYFCY;
          
            l_srno := l_srno + 1;
            Pr_insert_tracktable(l_srno,
                                 'So After adding New FCY L_BAL_LCY: ' || L_BAL_LCY || ' #L_T_BAL_LCYFCY: ' ||
                                 L_T_BAL_LCYFCY);
          
            L_BAL_LCY_SUM := NVL(L_BAL_LCY_SUM, 0) + NVL(L_BAL_LCY, 0);
          
            if ((NVL(L_ty_cr_gl(ix).CR_BAL_LCY, 0) - NVL(L_ty_cr_gl(ix).DR_BAL_LCY, 0)) <> NVL(L_BAL_LCY, 0))
            then
              L_BAL_LCY_MIS := NVL(L_BAL_LCY_MIS, 0) + NVL(L_BAL_LCY, 0) - NVL(L_ty_cr_gl(ix).CR_BAL_LCY, 0) +
                               NVL(L_ty_cr_gl(ix).DR_BAL_LCY, 0);
              insert into Gltbs_Mismatch
                (BRANCH_CODE,
                 GL_CODE,
                 CCY_CODE,
                 PERIOD_CODE,
                 FIN_YEAR,
                 CATEGORY,
                 BAL,
                 BAL_LCY,
                 ACTUAL_BAL,
                 ACTUAL_BAL_LCY)
              values
                (L_ty_cr_gl(ix).BRANCH_CODE,
                 trim(L_ty_cr_gl(ix).GL_CODE),
                 L_ty_cr_gl(ix).CCY_CODE,
                 P_PER,
                 P_FIN,
                 L_ty_cr_gl(ix).CATEGORY,
                 NVL(L_ty_cr_gl(ix).CR_BAL, 0) - NVL(L_ty_cr_gl(ix).DR_BAL, 0),
                 NVL(L_ty_cr_gl(ix).CR_BAL_LCY, 0) - NVL(L_ty_cr_gl(ix).DR_BAL_LCY, 0),
                 NVL(L_ty_cr_gl(ix).CR_BAL, 0) - NVL(L_ty_cr_gl(ix).DR_BAL, 0),
                 NVL(L_BAL_LCY, 0));
            
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno, 'Inserted into Gltbs_Mismatch1');
            end if;
          
            L1     := 0;
            L2     := 0;
            l_srno := l_srno + 1;
            Pr_insert_tracktable(l_srno, 'Here4 in FCY Case..');
            select nvl(sum(DECODE(DRCR_IND, 'D', NVL(LCY_AMOUNT, 0), 0)), 0) DR_AMT,
                   nvl(sum(DECODE(DRCR_IND, 'C', NVL(LCY_AMOUNT, 0), 0)), 0) CR_AMT
              into L1,
                   L2
              from ACTB_HISTORY A
             where AC_NO = trim(L_ty_cr_gl(ix).GL_CODE)
                   and A.PERIOD_CODE = P_PER
                   and A.FINANCIAL_CYCLE = P_FIN
                   and AC_BRANCH = P_BRN;
          
            l_srno := l_srno + 1;
            Pr_insert_tracktable(l_srno, 'K-FCY4 for ix: ' || ix || ' #L1: ' || L1 || ':' || L2);
          
            if (NVL(L_ty_cr_gl(ix).DR_MOV_LCY, 0) <> NVL(L1, 0) or NVL(L_ty_cr_gl(ix).CR_MOV_LCY, 0) <> NVL(L2, 0))
            then
              insert into GLTBS_MISMATCH_MOV
                (BRANCH_CODE,
                 GL_CODE,
                 CCY_CODE,
                 PERIOD_CODE,
                 FIN_YEAR,
                 CATEGORY,
                 DR_MOV,
                 CR_MOV,
                 DR_MOV_LCY,
                 CR_MOV_LCY,
                 DR_MOV_ACT,
                 CR_MOV_ACT,
                 DR_MOV_LCY_ACT,
                 CR_MOV_LCY_ACT)
              values
                (L_ty_cr_gl(ix).BRANCH_CODE,
                 trim(L_ty_cr_gl(ix).GL_CODE),
                 L_ty_cr_gl(ix).CCY_CODE,
                 P_PER,
                 P_FIN,
                 L_ty_cr_gl(ix).CATEGORY,
                 NVL(L_ty_cr_gl(ix).DR_MOV, 0),
                 NVL(L_ty_cr_gl(ix).CR_MOV, 0),
                 NVL(L_ty_cr_gl(ix).DR_MOV_LCY, 0),
                 NVL(L_ty_cr_gl(ix).CR_MOV_LCY, 0),
                 0,
                 0,
                 NVL(L1, 0),
                 NVL(L2, 0));
            
              l_srno := l_srno + 1;
              Pr_insert_tracktable(l_srno, 'Inserted into GLTBS_MISMATCH_MOV1');
            end if;
          end if;
        end loop;
      end if;
      commit;
      exit when CR_GL%notfound;
    end loop;
    close CR_GL;
    commit;
    l_srno := l_srno + 1;
    Pr_insert_tracktable(l_srno,
                         'Returning from FN_CHECK_INT_GLS with lcy sum ' || TO_CHAR(L_BAL_LCY_SUM) ||
                         ' #lcy mismatch  ' || TO_CHAR(L_BAL_LCY_MIS));
    return true;
  exception
    when others then
      Pr_insert_tracktable(l_srno + 1, 'Error in fn_check_int_gls was ' || sqlerrm);
      return false;
  end FN_CHECK_INT_GLS;

  function FN_BUILD_INT_GLS(P_BRN in STTMS_BRANCH.BRANCH_CODE%type,
                            P_PER in STTMS_BRANCH.CURRENT_PERIOD%type,
                            P_FIN in STTMS_BRANCH.CURRENT_CYCLE%type,
                            P_LCY in CYTMS_CCY_DEFN.CCY_CODE%type) return boolean is
    cursor CR_GL_PROBS is
      select *
        from Gltbs_Mismatch
       where BRANCH_CODE = P_BRN
             and PERIOD_CODE = P_PER
             and FIN_YEAR = P_FIN;
    cursor CR_GL_MOV_PROBS is
      select *
        from GLTBS_MISMATCH_MOV
       where BRANCH_CODE = P_BRN
             and PERIOD_CODE = P_PER
             and FIN_YEAR = P_FIN;
    L_DR_BAL     number := 0;
    L_CR_BAL     number := 0;
    L_DR_BAL_LCY number := 0;
    L_CR_BAL_LCY number := 0;
    L_DR_MOV     number := 0;
    L_CR_MOV     number := 0;
    L_DR_MOV_LCY number := 0;
    L_CR_MOV_LCY number := 0;
    L_CNT        number;
  
  begin
    Pr_insert_tracktable(l_srno,
                         'Inside glpks_glrebuild_tmp_1.FN_BUILD_INT_GLS for P_BRN: ' || P_BRN || ' #P_FIN: ' || P_FIN ||
                         ' #P_PER: ' || P_PER);
  
    if not FN_CHECK_INT_GLS(P_BRN, P_PER, P_FIN, P_LCY)
    then
      return false;
    end if;
    select count(*)
      into L_CNT
      from Gltbs_Mismatch
     where BRANCH_CODE = P_BRN
           and PERIOD_CODE = P_PER
           and FIN_YEAR = P_FIN;
    l_srno := l_srno + 1;
    Pr_insert_tracktable(l_srno, 'Gltbs_Mismatch count = ' || TO_CHAR(L_CNT));
    for EACH_RECORD in CR_GL_PROBS
    loop
      if EACH_RECORD.ACTUAL_BAL < 0
      then
        L_DR_BAL := ABS(EACH_RECORD.ACTUAL_BAL);
        L_CR_BAL := 0;
      else
        L_DR_BAL := 0;
        L_CR_BAL := EACH_RECORD.ACTUAL_BAL;
      end if;
      if EACH_RECORD.ACTUAL_BAL_LCY < 0
      then
        L_DR_BAL_LCY := ABS(EACH_RECORD.ACTUAL_BAL_LCY);
        L_CR_BAL_LCY := 0;
      else
        L_DR_BAL_LCY := 0;
        L_CR_BAL_LCY := EACH_RECORD.ACTUAL_BAL_LCY;
      end if;
      update GLTB_GL_BAL -- GLTBS_GL_BAL
         set DR_BAL     = L_DR_BAL,
             CR_BAL     = L_CR_BAL,
             DR_BAL_LCY = L_DR_BAL_LCY,
             CR_BAL_LCY = L_CR_BAL_LCY
       where BRANCH_CODE = EACH_RECORD.BRANCH_CODE
             and GL_CODE = trim(EACH_RECORD.GL_CODE)
             and CCY_CODE = EACH_RECORD.CCY_CODE
             and FIN_YEAR = EACH_RECORD.FIN_YEAR
             and PERIOD_CODE = EACH_RECORD.PERIOD_CODE;
    
    end loop;
    l_srno := l_srno + 1;
    Pr_insert_tracktable(l_srno, 'Updated GLTBS_GL_BAL_M03_1...');
    for EACH_RECORD in CR_GL_MOV_PROBS
    loop
      update GLTB_GL_BAL --GLTBS_GL_BAL
         set DR_MOV_LCY = EACH_RECORD.DR_MOV_LCY_ACT,
             CR_MOV_LCY = EACH_RECORD.CR_MOV_LCY_ACT,
             DR_MOV     = EACH_RECORD.DR_MOV_ACT,
             CR_MOV     = EACH_RECORD.CR_MOV_ACT
       where BRANCH_CODE = EACH_RECORD.BRANCH_CODE
             and GL_CODE = trim(EACH_RECORD.GL_CODE)
             and CCY_CODE = EACH_RECORD.CCY_CODE
             and FIN_YEAR = EACH_RECORD.FIN_YEAR
             and PERIOD_CODE = EACH_RECORD.PERIOD_CODE;
    end loop;
    l_srno := l_srno + 1;
    Pr_insert_tracktable(l_srno,
                         'Updated gltbs_gl_bal_tmp2 and Script got COMPLETED for P_BRN: ' || P_BRN || ' #P_FIN: ' ||
                         P_FIN || ' #P_PER: ' || P_PER);
    commit;
    return true;
  exception
    when others then
      Pr_insert_tracktable(l_srno + 1, 'In when others of fn_build_internal_gls: ' || sqlerrm);
      return false;
  end FN_BUILD_INT_GLS;

end GLPKS_GLREBUILD_custom;
/