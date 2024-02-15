set timing on;
set time on;


!echo this is ICTB_UDEVALS
set serveroutput on
declare
v_unformatted_blocks number;
v_unformatted_bytes number;
v_fs1_blocks number;
v_fs1_bytes number;
v_fs2_blocks number;
v_fs2_bytes number;
v_fs3_blocks number;
v_fs3_bytes number;
v_fs4_blocks number;
v_fs4_bytes number;
v_full_blocks number;
v_full_bytes number;
begin
dbms_space.space_usage ('FCC114', 'ICTB_UDEVALS', 'TABLE', v_unformatted_blocks,
v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes);
dbms_output.put_line('Unformatted Blocks = '||v_unformatted_blocks);
dbms_output.put_line('FS1 Blocks = '||v_fs1_blocks);
dbms_output.put_line('FS2 Blocks = '||v_fs2_blocks);
dbms_output.put_line('FS3 Blocks = '||v_fs3_blocks);
dbms_output.put_line('FS4 Blocks = '||v_fs4_blocks);
dbms_output.put_line('Full Blocks = '||v_full_blocks);
end;
/

!echo this is ICTW_MAKE_ROW
set serveroutput on
declare
v_unformatted_blocks number;
v_unformatted_bytes number;
v_fs1_blocks number;
v_fs1_bytes number;
v_fs2_blocks number;
v_fs2_bytes number;
v_fs3_blocks number;
v_fs3_bytes number;
v_fs4_blocks number;
v_fs4_bytes number;
v_full_blocks number;
v_full_bytes number;
begin
dbms_space.space_usage ('FCC114', 'ICTW_MAKE_ROW', 'TABLE', v_unformatted_blocks,
v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes);
dbms_output.put_line('Unformatted Blocks = '||v_unformatted_blocks);
dbms_output.put_line('FS1 Blocks = '||v_fs1_blocks);
dbms_output.put_line('FS2 Blocks = '||v_fs2_blocks);
dbms_output.put_line('FS3 Blocks = '||v_fs3_blocks);
dbms_output.put_line('FS4 Blocks = '||v_fs4_blocks);
dbms_output.put_line('Full Blocks = '||v_full_blocks);
end;
/


--CHECK
set lines 9999
select 
 table_name,round(((blocks*8)/1024/1024),2) "size (gb)" , 
 round(((num_rows*avg_row_len/1024))/1024/1024,2) "actual_data (gb)",
 round((((blocks*8)) - ((num_rows*avg_row_len/1024)))/1024/1024,2) "wasted_space (gb)",
 round(((((blocks*8)-(num_rows*avg_row_len/1024))/(blocks*8))*100 -10),2) "reclaimable space %",
 partitioned from 
 dba_tables
where table_name in 
('ICTB_UDEVALS','ICTW_MAKE_ROW')
and (round((blocks*8),2) > round((num_rows*avg_row_len/1024),2))
order by 4 desc;

--check invalid
select owner, object_type, count(*) total 
from dba_objects 
where owner='FCC114' 
and status ='INVALID'
group by owner, object_type 
order by 1,3;

--check rowmovement
SELECT table_name, row_movement FROM dba_tables 
WHERE table_name in 
('ICTB_UDEVALS','ICTW_MAKE_ROW') order by table_name;

------------------------------------------------------------------------------------------------------------

!date
!echo this is ICTB_UDEVALS
ALTER TABLE FCC114.ICTB_UDEVALS ENABLE ROW MOVEMENT;
ALTER TABLE FCC114.ICTB_UDEVALS MOVE parallel 8;
ALTER INDEX FCC114.PK01_ICTB_UDEVALS rebuild parallel 8;
ALTER INDEX FCC114.IX01_ICTB_UDEVALS rebuild parallel 8;
ALTER TABLE FCC114.ICTB_UDEVALS DISABLE ROW MOVEMENT;

!date
!echo this is ICTW_MAKE_ROW
ALTER TABLE FCC114.ICTW_MAKE_ROW ENABLE ROW MOVEMENT;
ALTER TABLE FCC114.ICTW_MAKE_ROW MOVE parallel 8;
ALTER INDEX FCC114.PK01_ICTW_MAKE_ROW rebuild parallel 8;
ALTER TABLE FCC114.ICTW_MAKE_ROW DISABLE ROW MOVEMENT;

!date

------------------------------------------------------------------------------------------------------------

--check rowmovement
SELECT table_name, row_movement FROM dba_tables 
WHERE table_name in
('ICTB_UDEVALS','ICTW_MAKE_ROW') order by table_name;


--check unusable
select index_owner,index_name,partition_name, tablespace_name,status from dba_ind_partitions where status ='UNUSABLE';
select OWNER, index_name,index_type,tablespace_name,status, index_type from dba_indexes where status='UNUSABLE';
select index_owner, index_name, partition_name, subpartition_name, tablespace_name from dba_ind_subpartitions where  status = 'UNUSABLE';

--check invalid
select owner, object_type, count(*) total 
from dba_objects 
where owner='FCC114' 
and status ='INVALID' 
group by owner, object_type 
order by 1,3;
--CHECK
set lines 9999
select 
 table_name,round(((blocks*8)/1024/1024),2) "size (gb)" , 
 round(((num_rows*avg_row_len/1024))/1024/1024,2) "actual_data (gb)",
 round((((blocks*8)) - ((num_rows*avg_row_len/1024)))/1024/1024,2) "wasted_space (gb)",
 round(((((blocks*8)-(num_rows*avg_row_len/1024))/(blocks*8))*100 -10),2) "reclaimable space %",
 partitioned from dba_tables
where table_name in 
('ICTB_UDEVALS','ICTW_MAKE_ROW')
and (round((blocks*8),2) > round((num_rows*avg_row_len/1024),2))
order by 4 desc;

!echo this is ICTB_UDEVALS
set serveroutput on
declare
v_unformatted_blocks number;
v_unformatted_bytes number;
v_fs1_blocks number;
v_fs1_bytes number;
v_fs2_blocks number;
v_fs2_bytes number;
v_fs3_blocks number;
v_fs3_bytes number;
v_fs4_blocks number;
v_fs4_bytes number;
v_full_blocks number;
v_full_bytes number;
begin
dbms_space.space_usage ('FCC114', 'GETM_LIAB', 'TABLE', v_unformatted_blocks,
v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes);
dbms_output.put_line('Unformatted Blocks = '||v_unformatted_blocks);
dbms_output.put_line('FS1 Blocks = '||v_fs1_blocks);
dbms_output.put_line('FS2 Blocks = '||v_fs2_blocks);
dbms_output.put_line('FS3 Blocks = '||v_fs3_blocks);
dbms_output.put_line('FS4 Blocks = '||v_fs4_blocks);
dbms_output.put_line('Full Blocks = '||v_full_blocks);
end;
/

!echo this is ICTW_MAKE_ROW
set serveroutput on
declare
v_unformatted_blocks number;
v_unformatted_bytes number;
v_fs1_blocks number;
v_fs1_bytes number;
v_fs2_blocks number;
v_fs2_bytes number;
v_fs3_blocks number;
v_fs3_bytes number;
v_fs4_blocks number;
v_fs4_bytes number;
v_full_blocks number;
v_full_bytes number;
begin
dbms_space.space_usage ('FCC114', 'ICTW_MAKE_ROW', 'TABLE', v_unformatted_blocks,
v_unformatted_bytes, v_fs1_blocks, v_fs1_bytes, v_fs2_blocks, v_fs2_bytes,
v_fs3_blocks, v_fs3_bytes, v_fs4_blocks, v_fs4_bytes, v_full_blocks, v_full_bytes);
dbms_output.put_line('Unformatted Blocks = '||v_unformatted_blocks);
dbms_output.put_line('FS1 Blocks = '||v_fs1_blocks);
dbms_output.put_line('FS2 Blocks = '||v_fs2_blocks);
dbms_output.put_line('FS3 Blocks = '||v_fs3_blocks);
dbms_output.put_line('FS4 Blocks = '||v_fs4_blocks);
dbms_output.put_line('Full Blocks = '||v_full_blocks);
end;
/

!date
exit;

