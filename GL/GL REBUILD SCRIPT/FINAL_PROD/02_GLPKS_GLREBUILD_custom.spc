create or replace package GLPKS_GLREBUILD_custom as

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

  function fn_check_int_gls(p_brn in sttms_branch.branch_code%type,
                            p_per in sttms_branch.current_period%type,
                            p_fin in sttms_branch.current_cycle%type,
                            p_lcy in cytms_ccy_defn.ccy_code%type) return boolean;

  procedure Pr_insert_tracktable(p_sr_no number,
                                 p_msg   in varchar2);

  procedure PR_PRDWISE_ACTB_HISTORY_000IDR(p_GL_CODE       varchar2,
                                           p_BRN           varchar2,
                                           P_DT            date,
                                           P_total_BAL     out number,
                                           P_total_BAL_LCY out number);

  function fn_build_int_gls(p_brn in sttms_branch.branch_code%type,
                            p_per in sttms_branch.current_period%type,
                            p_fin in sttms_branch.current_cycle%type,
                            p_lcy in cytms_ccy_defn.ccy_code%type)
  
   return boolean;

end;
