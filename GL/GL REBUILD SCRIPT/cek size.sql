set lines 300
col segment_name for a35
col owner for a35
select  owner, tablespace_name, segment_type, segment_name,sum(bytes/1024/1024) MB 
from dba_segments 
where segment_name in ('ACTB_HISTORY')
group by owner, tablespace_name, segment_name, segment_type
order by segment_type;


select count(*) from fcc114.actb_history where ac_branch='000' and ac_ccy='IDR';