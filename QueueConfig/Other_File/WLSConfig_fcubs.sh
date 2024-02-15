# First set the WL Server Classpath.
# 
export CURDIR=$PWD
cd /scratch/oraofss/Oracle/Middleware/Oracle_Home/wlserver/server/bin
. ./setWLSEnv.sh
cd /scratch/oraofss/Oracle/Middleware/Oracle_Home/user_projects/domains/FCUBS_DOMAIN/bin/
. ./setDomainEnv.sh
cd $CURDIR
java weblogic.WLST WLSConfigDS.py
# java weblogic.WLST WLSConfigQ.py



