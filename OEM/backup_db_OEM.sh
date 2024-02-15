
1. Create Directory
cd /datadump1
mkdir opiris
chmod 777 opiris
cd opiris
mkdir db arch
chmod 777 db arch

2. Create File
$ vi /home/oracle/script/backup/opurptrx.sh
$ chmod 777 /home/oracle/script/backup/opurptrx.sh




-------------------------------------------------------

echo '======================================='
echo `date`
export ORACLE_SID=em13crep
export ORACLE_HOME=/oracle/app/oracle/product/12.1.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/oracle/source/backup/log/backup_db.log << EOF

crosscheck backup;
delete force noprompt expired backup;
run
{
allocate channel ch01 device type disk format '/oracle/source/backup/db/%d_db_%T_%U.bk';
allocate channel ch03 device type disk format '/oracle/source/backup/db/%d_db_%T_%U.bk';
allocate channel ch05 device type disk format '/oracle/source/backup/db/%d_db_%T_%U.bk';
backup database;
backup current controlfile format '/oracle/source/backup/db/%d_db_control_%T_%U.bkp';
release channel ch01;
release channel ch03;
release channel ch05;
}

crosscheck archivelog all;
delete force noprompt expired archivelog all;
run
{
allocate channel ch01 device type disk format '/oracle/source/backup/arch/%d_arch_%T_%U.bk';
allocate channel ch03 device type disk format '/oracle/source/backup/arch/%d_arch_%T_%U.bk';
allocate channel ch05 device type disk format '/oracle/source/backup/arch/%d_arch_%T_%U.bk';
backup archivelog all delete input;
release channel ch01;
release channel ch03;
release channel ch05;
}

exit
EOF

echo '======================================='

[oracle@exa62pdb1-mgt ~]$ 
