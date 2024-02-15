####################################################################
#  Remove Old Oracle Log === rmvoldoraclelog.sh                    #
####################################################################
#!/bin/ksh
# Set parameter
currdt=`date '+%Y%m%d_%T'`; export currdt
LOGDIR=/oracle/maintenance/log/; export LOGDIR
LOGFILE=/oracle/maintenance/log/REMOVE_OLD_ARCHIVE_$currdt.log; export LOGFILE
ORA_OWNER=`id -un` ; export ORA_OWNER

DUMP_bmiprd1=/oracle/app/oracle/diag/rdbms/bmidr/bmiprd1; export DUMP_bmiprd1
BDUMP_DIR_bmiprd1=$DUMP_bmiprd1/trace; export BDUMP_DIR_bmiprd1
ALERT_DIR_bmiprd1=$DUMP_bmiprd1/alert; export ALERT_DIR_bmiprd1
ADUMP_DIR_bmiprd1=/oracle/app/oracle/admin/bmiprd/adump; export ADUMP_DIR_bmiprd1

exec 1>>$LOGFILE
echo "****************************************************************************"
echo "* REMOVE OLD ORACLE LOG - START "
echo "* ---------------------------------- "
echo "*     SYSTEM : `hostname`         "
echo "* START DATE : `date '+%d/%m/%Y'`   "
echo "* START TIME : `date '+%H:%M:%S'`   "
echo "****************************************************************************"
echo
cd $BDUMP_DIR_bmiprd1
echo "Listing of bdump old trace : $BDUMP_DIR_bmiprd1"
find . -name "*.trm" -mtime +3
find . -name "*.trc" -mtime +3
find . -name "*.trm" -mtime +3 -exec rm -f {} \; # *Remove old bdump file*
find . -name "*.trc" -mtime +3 -exec rm -f {} \; # *Remove old bdump file*
cd $ADUMP_DIR_bmiprd1
echo "Listing of adump old trace : $ADUMP_DIR_bmiprd1"
find . -name "*.aud" -mtime +3
find . -name "*.aud" -mtime +3 -exec rm -f {} \; # *Remove old adump file*
cd $ALERT_DIR_bmiprd1
cat /dev/null > log.xml # *Remove old alert file*
echo
cd $LOGDIR
find . -name "*.log" -mtime +3 -exec rm -f {} \; # *Remove old log file*
echo
echo "****************************************************************************"
echo "* REMOVE OLD ORACLE LOG - END "
echo "* -------------------------------- "
echo "*     SYSTEM : `hostname`         "
echo "* START DATE : `date '+%d/%m/%Y'`   "
echo "* START TIME : `date '+%H:%M:%S'`   "
echo "****************************************************************************"
exit 0
