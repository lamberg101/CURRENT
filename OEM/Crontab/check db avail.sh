DBALIST="lamberg.nicolasbani@midasteknologi.com"

TARGET="EMREP, EMREP1"

. /home/oracle/.bash_profile
cd /home/oracle/Alert
#rm -f sizedb_all.* namaDB.txt

for i in $TARGET 
do
waktu=`date`
hsl=`tnsping $i`
if [ $? -ne 0 ]
then
echo " " >> sizedb_all.tmp
echo "Koneksi ke $i GAGAL, waktu : $waktu" >> sizedb_all.tmp
echo " " >> sizedb_all.tmp
else
namaDB=`sh /home/oracle/Alert/Check_dbname.sh oracle $i`
echo " " > namaDB.txt
echo " " >> namaDB.txt
echo "DB Name : $namaDB, waktu : $waktu" >> namaDB.txt
sqlplus -s <<!
DBSNMP/DbsnmpBMI#2023$i

set feed off
set linesize 100
set pagesize 200
set echo        off
set feedback    6
set heading     on
set linesize    180
set pagesize    50000
set termout     on
set timing      off
set trimout     on
set trimspool   on
set verify      off
set feed off
clear columns
clear breaks
clear computes
spool sizedb_all.alert

select sum(bytes/1024/1024/1024) from dba_segments;
select sum(bytes/1024/1024/1024) from dba_data_files;

spool off
exit
!
if [ `cat sizedb_all.alert|wc -l` -gt 0 ]
then
          cat namaDB.txt >> sizedb_all.tmp
	  cat sizedb_all.alert >> sizedb_all.tmp
fi
fi
done
mailx -s "sizedb_all" $DBALIST < sizedb_all.tmp