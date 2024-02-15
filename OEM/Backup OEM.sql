Backing Up the OMS

$ <OMS_HOME>/bin/emctl exportconfig oms -dir /oracle/source/backup/bkp_oms
--EM USER
sysman/oracle123



[oracle@bmioem bin]$ ./emctl exportconfig oms -dir /oracle/source/backup/bkp_oms
Oracle Enterprise Manager Cloud Control 13c Release 1
Copyright (c) 1996, 2015 Oracle Corporation.  All rights reserved.
Enter Enterprise Manager Root (SYSMAN) Password :
ExportConfig started...
Backup directory is /oracle/source/backup/bkp_oms
Machine is Admin Server host. Performing Admin Server backup...

Exporting emoms properties...
Exporting secure properties...

Export has determined that the OMS is not fronted
by an SLB. The local hostname was NOT exported.
The exported data can be imported on any host but
resecure of all agents will be required. Please
see the EM Advanced Configuration Guide for more
details.

Exporting configuration for pluggable modules...
Preparing archive file...
Backup has been written to file: /oracle/source/backup/bkp_oms/opf_ADMIN_20231212_132842.bka

The export file contains sensitive data.
 You must keep it secure.

ExportConfig completed successfully!
[oracle@bmioem bin]$


-----
how to change the swap file system during oem upgrade?
reboot the server.

-----


[oracle@bmioem ~]$ ps -ef | grep OMS
oracle     5748   5688  1 Sep18 ?        1-00:01:11 /oracle/app/oracle/middleware/oracle_common/jdk/bin/java -server -Xms256M -Xmx1740M -XX:PermSize=128M -XX:MaxPermSize=768M -XX:CompileThreshold=8000 -XX:-DoEscapeAnalysis -XX:+UseCodeCacheFlushing -XX:ReservedCodeCacheSize=100M -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSClassUnloadingEnabled -Dweblogic.Name=EMGC_OMS1 -Djava.security.policy=/oracle/app/oracle/middleware/wlserver/server/lib/weblogic.policy -Dweblogic.ProductionModeEnabled=true -Dweblogic.system.BootIdentityFile=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/servers/EMGC_OMS1/data/nodemanager/boot.properties -Dweblogic.nodemanager.ServiceEnabled=true -Dweblogic.nmservice.RotationEnabled=true -Dweblogic.security.SSL.ignoreHostnameVerification=true -Dweblogic.ReverseDNSAllowed=false -DINSTANCE_HOME=/oracle/app/oracle/gc_inst/em/EMGC_OMS1 -DORACLE_HOME=/oracle/app/oracle/middleware -Ddomain.home=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain -Djava.awt.headless=true -Ddomain.name=GCDomain -Doracle.sysman.util.logging.mode=dual_mode -Djbo.doconnectionpooling=true -Djbo.txn.disconnect_level=1 -Docm.repeater.home=/oracle/app/oracle/middleware -Djbo.ampool.minavailablesize=1 -Djbo.ampool.timetolive=-1 -Djbo.load.components.lazily=true -Djbo.max.cursors=5 -Djbo.recyclethreshold=50 -Djbo.ampool.maxavailablesize=50 -Djavax.xml.bind.JAXBContext=com.sun.xml.bind.v2.ContextFactory -Djava.security.egd=file:///dev/./urandom -Dweblogic.debug.DebugWebAppSecurity=true -Dweblogic.SSL.LoginTimeoutMillis=300000 -Djps.auth.debug=true -Djps.authz=ACC -Djps.combiner.optimize.lazyeval=true -Djps.combiner.optimize=true -Djps.subject.cache.key=5 -Djps.subject.cache.ttl=600000 -Doracle.apm.home=/oracle/app/oracle/middleware/apm/ -DAPM_HELP_FILENAME=oesohwconfig.xml -Dweblogic.data.canTransferAnyFile=true -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2 -DHTTPClient.retryNonIdempotentRequest=false -Dweblogic.security.SSL.minimumProtocolVersion=TLSv1 -Djava.endorsed.dirs=/oracle/app/oracle/middleware/oracle_common/jdk/jre/lib/endorsed:/oracle/app/oracle/middleware/oracle_common/modules/endorsed -Djava.protocol.handler.pkgs=oracle.mds.net.protocol -Dopss.version=12.1.3 -Digf.arisidbeans.carmlloc=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/config/fmwconfig/carml -Digf.arisidstack.home=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/config/fmwconfig/arisidprovider -Doracle.security.jps.config=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/config/fmwconfig/jps-config.xml -Doracle.deployed.app.dir=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/servers/EMGC_OMS1/tmp/_WL_user -Doracle.deployed.app.ext=/- -Dweblogic.alternateTypesDirectory=/oracle/app/oracle/middleware/oracle_common/modules/oracle.ossoiap_12.1.3,/oracle/app/oracle/middleware/oracle_common/modules/oracle.oamprovider_12.1.3,/oracle/app/oracle/middleware/oracle_common/modules/oracle.jps_12.1.3 -Doracle.mds.filestore.preferred= -Dadf.version=12.1.3 -Dweblogic.jdbc.remoteEnabled=false -Dcommon.components.home=/oracle/app/oracle/middleware/oracle_common -Djrf.version=12.1.3 -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.Jdk14Logger -Ddomain.home=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain -Doracle.server.config.dir=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/config/fmwconfig/servers/EMGC_OMS1 -Doracle.domain.config.dir=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/config/fmwconfig -Dohs.product.home=/oracle/app/oracle/middleware/ohs -da -Dwls.home=/oracle/app/oracle/middleware/wlserver/server -Dweblogic.home=/oracle/app/oracle/middleware/wlserver/server -Djavax.management.builder.initial=weblogic.management.jmx.mbeanserver.WLSMBeanServerBuilder -Dxdo.server.config.dir=/oracle/app/oracle/gc_inst/user_projects/domains/GCDomain/config/bipublisher -DXDO_FONT_DIR=/oracle/app/oracle/middleware/bi/common/fonts -Dweblogic.management.server=https://bmioem:7102 -Djava.util.logging.manager=oracle.core.ojdl.logging.ODLLogManager -Dweblogic.utils.cmm.lowertier.ServiceDisabled=true weblogic.Server
oracle    25847  24872  0 16:52 pts/0    00:00:00 grep --color=auto OMS
[oracle@bmioem ~]$
[oracle@bmioem ~]$
[oracle@bmioem ~]$
[oracle@bmioem ~]$ ps -ef | grep agent
oracle     3271      1  0 Sep13 ?        00:06:07 /oracle/app/oracle/agent/agent_13.1.0.0.0/perl/bin/perl /oracle/app/oracle/agent/agent_13.1.0.0.0/bin/emwd.pl agent /oracle/app/oracle/agent/agent_inst/sysman/log/emagent.nohup
oracle     8059   3271  0 Sep13 ?        08:00:14 /oracle/app/oracle/agent/agent_13.1.0.0.0/oracle_common/jdk/bin/java -Xmx190M -XX:MaxPermSize=96M -server -Djava.security.egd=file:///dev/./urandom -Dsun.lang.ClassLoader.allowArraySyntax=true -XX:-UseLargePages -XX:+UseLinuxPosixThreadCPUClocks -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseCompressedOops -Dwatchdog.pid=3271 -cp /oracle/app/oracle/agent/agent_13.1.0.0.0/jdbc/lib/ojdbc5.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/ucp/lib/ucp.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/oracle_common/modules/jsch-0.1.51.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/oracle_common/modules/com.oracle.http_client.http_client_12.1.3.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/oracle_common/modules/oracle.xdk_12.1.3/xmlparserv2.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/oracle_common/modules/oracle.dms_12.1.3/dms.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/oracle_common/modules/oracle.odl_12.1.3/ojdl.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/oracle_common/modules/oracle.odl_12.1.3/ojdl2.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/lib/optic.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/sysman/jlib/log4j-core.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/jlib/gcagent_core.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/sysman/jlib/emagentSDK-intg.jar:/oracle/app/oracle/agent/agent_13.1.0.0.0/sysman/jlib/emagentSDK.jar oracle.sysman.gcagent.tmmain.TMMain
oracle    26504  24872  0 16:53 pts/0    00:00:00 grep --color=auto agent
itsvr    114423 114276  0 Dec04 ?        00:00:01 /usr/bin/ssh-agent /bin/sh -c exec -l /bin/bash -c "env GNOME_SHELL_SESSION_MODE=classic gnome-session --session gnome-classic"
[oracle@bmioem ~]$




export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/dbhome_1
export ORACLE_SID=em13crep
export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

alias sq='sqlplus / as sysdba'
alias alert='tail -100f /oracle/app/oracle/diag/rdbms/em13crep/em13crep/trace/alert_em13crep.log'




====


export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19.0.0/dbhome_1
export ORACLE_SID=emrep
export PATH=/usr/sbin:/usr/local/bin:/usr/bin/xdpyinfo:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
## User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin
alias sq='sqlplus / as sysdba'
alias alert='tail -100f /oracle/app/oracle/diag/rdbms/emrep/emrep/trace/alert_emrep.log'
export PATH





/oracle/app/oraInventory/orainstRoot.sh
/oracle/app/oracle/product/19.0.0/dbhome_1/root.sh

DISPLAY=bmioem:0.0; export DISPLAY

ssh -X 10.55.60.193 

export DISPLAY=bmioem:10.0;
ssh -o ServerAliveInterval=30 -X 10.55.60.193 -l oracle

[oracle@bmioem dbhome_1]$ sudo yum install xorg-x11-utils
[sudo] password for oracle:
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: centos.mirror.angkasa.id
 * extras: mirror.beon.co.id
 * updates: linux.domainesia.com
Package xorg-x11-utils-7.5-23.el7.x86_64 already installed and latest version
Nothing to do


export PATH=$PATH:/usr/bin/xdpyinfo




=====================

[oracle@bmioem bin]$ ./dbca -silent -createDatabase                                                   \
>      -templateName General_Purpose.dbc                                         \
>      -gdbname ${ORACLE_SID} -sid  ${ORACLE_SID} -responseFile NO_VALUE         \
>      -characterSet AL32UTF8                                                    \
>      -sysPassword oracle                                                 \
>      -systemPassword oracle                                              \
>      -databaseType MULTIPURPOSE                                                \
>      -memoryMgmtType auto_sga                                                  \
>      -totalMemory 2000                                                         \
>      -storageType FS                                                           \
>      -datafileDestination "${DATA_DIR}"                                        \
>      -redoLogFileSize 50                                                       \
>      -emConfiguration NONE                                                     \
>      -ignorePreReqs

[WARNING] [DBT-06208] The 'SYS' password entered does not conform to the Oracle recommended standards.
   CAUSE:
a. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9].
b.The password entered is a keyword that Oracle does not recommend to be used as password
   ACTION: Specify a strong password. If required refer Oracle documentation for guidelines.
[WARNING] [DBT-06208] The 'SYSTEM' password entered does not conform to the Oracle recommended standards.
   CAUSE:
a. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9].
b.The password entered is a keyword that Oracle does not recommend to be used as password
   ACTION: Specify a strong password. If required refer Oracle documentation for guidelines.
Prepare for db operation
10% complete
Copying database files

40% complete
Creating and starting Oracle instance
42% complete
46% complete

50% complete
54% complete
60% complete
Completing Database Creation

66% complete
69% complete
70% complete
Executing Post Configuration Actions
100% complete
Database creation complete. For details check the logfiles at:
 /oracle/app/oracle/cfgtoollogs/dbca/emrep.
Database Information:
Global Database Name:emrep
System Identifier(SID):emrep
Look at the log file "/oracle/app/oracle/cfgtoollogs/dbca/emrep/emrep.log" for further details.


