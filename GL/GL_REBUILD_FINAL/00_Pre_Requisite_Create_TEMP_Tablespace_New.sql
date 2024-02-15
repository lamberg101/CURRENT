
--This first step to create tablespace, run manually using putty (no need from background)


--create tablespace PRD_TMP_TBS

CREATE TABLESPACE PRD_TMP_TBS DATAFILE '+DATA02' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 31G;

ALTER TABLESPACE PRD_TMP_TBS ADD DATAFILE '+DATA02' SIZE 100M AUTOEXTEND ON NEXT 512M MAXSIZE 30G;
--14x

--alter quota to user fcc114
ALTER USER FCC114 QUOTA UNLIMITED ON PRD_TMP_TBS;


--Check the Privilege and ALL

--Make sure the new table is in the new tablespace

