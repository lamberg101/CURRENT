# First set the WL Server Classpath.
# 
export CURDIR=$PWD
cd /app/Oracle/Middleware/wlserver_10.3/server/bin
. ./setWLSEnv.sh
cd /app/Oracle/Middleware/user_projects/domains/mcbuat/bin/
. ./setDomainEnv.sh
cd $CURDIR
java weblogic.WLST WLSConfigDS.py
#java weblogic.WLST WLSConfigQ.py