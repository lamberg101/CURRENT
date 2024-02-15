# WLST Script to create and configure JMS resources.
# Ensure that the Datasource Name does not have any / characters. WLST will reject the names with"/"
# Additional fields in case of Datasource Config
# Datasource Related parameters that can be used for Configuration
# cd('/JDBCSystemResources/jdbc_fcjpmDSTest1/JDBCResource/jdbc_fcjpmDSTest1/JDBCDataSourceParams/jdbc_fcjpmDSTest1')
# cd('/JDBCSystemResources/'+dsName+'/JDBCResource/'+dsName+'/JDBCConnectionPoolParams/'+dsName)
# cmo.setInactiveConnectionTimeoutSeconds(30)

from java.io import FileInputStream
from java.util import Properties

def deleteIgnoringExceptions(mbean):
	try: delete(mbean)
	except: pass
	
def startTransaction():
	edit()
	startEdit()
	
def endTransaction():
	save()
	activate(block="true")
	
def createDS(dsName,dsJNDIName):
	#startTransaction()
	try:
		print "Create createDS() START",dsName,dsJNDIName
		dsTestQuery='SQL ISVALID'
		dsDriverName='oracle.jdbc.OracleDriver'
		cd('/')
		cmo.createJDBCSystemResource(dsName)
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName)
		cmo.setName(dsName)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName )
		set('JNDINames',jarray.array([String(dsJNDIName )], String))
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName )
		cmo.setUrl(dsURL)
		cmo.setDriverName(dsDriverName)
		cmo.setPassword(dsPassword)
		#set('Password', dsPassword)
		 
		#cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCConnectionPoolParams/' + dsName )
		#cmo.setTestTableName(dsTestQuery)
		
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName )
		#try:
		cmo.createProperty('user')		 
		#except:
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName + '/Properties/user')
		cmo.setValue(dsUserName)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName )	
		cmo.setGlobalTransactionsProtocol('None')
		 
		cd('/SystemResources/' + dsName )
		set('Targets',jarray.array([ObjectName('com.bea:Name=' + datasourceTarget + ',Type=Server')], ObjectName))
	except:
		dumpStack()	
		print "Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
	#endTransaction()
	
def createDSXA(dsName,dsJNDIName):
	#startTransaction()
	try:
		print "Create createDSXA() START",dsName,dsJNDIName
		dsTestQuery='SQL ISVALID'
		dsDriverName='oracle.jdbc.xa.client.OracleXADataSource'
		cd('/')
		cmo.createJDBCSystemResource(dsName)
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName)
		cmo.setName(dsName)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName )
		set('JNDINames',jarray.array([String(dsJNDIName )], String))
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName )
		cmo.setUrl(dsURL)
		cmo.setDriverName(dsDriverName)
		#cmo.setPassword(dsPassword)
		set('Password', dsPassword)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCConnectionPoolParams/' + dsName )
		cmo.setTestTableName(dsTestQuery)
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName )
		cmo.createProperty('user')
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName + '/Properties/user')
		cmo.setValue(dsUserName)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName )	
		cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')
		 
		cd('/SystemResources/' + dsName )
		set('Targets',jarray.array([ObjectName('com.bea:Name=' + datasourceTarget + ',Type=Server')], ObjectName))	
	except:
		dumpStack()	
		print "Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
	#endTransaction()

def createManagedServer(server,listenPort,SSLPort):
	#startTransaction()
	try:
		print "Create createManagedServer() START",server,listenPort,SSLPort
		cd('/')
		cmo.createServer(server)	
		cd('/Servers/' + server)
		cmo.setCluster(None)
		cmo.setListenPort(listenPort)
		cmo.setMaxOpenSockCount(-1)
		cmo.setAdministrationPort(9002)
		cmo.setNativeIOEnabled(true)
		cmo.setStartupMode('RUNNING')
		cmo.setClasspathServletDisabled(false)
		cmo.setClientCertProxyEnabled(false)
		cmo.setListenAddress('')
		cmo.setAcceptBacklog(300)
		cmo.setListenPortEnabled(true)
		cmo.setScatteredReadsEnabled(false)
		cmo.setLoginTimeoutMillis(5000)
		cmo.setStuckThreadMaxTime(18000)
		cmo.setReverseDNSAllowed(false)
		cmo.setVirtualMachineName(server)
		cmo.setStuckThreadTimerInterval(60)
		cmo.setGatheredWritesEnabled(false)		
		cmo.setJavaCompiler('javac')				
		#cmo.setMachine(getMBean('/Machines/UnixMachine_1'))
		
		cd('/Servers/'+server+'/SSL/'+server)
		cmo.setEnabled(true)
		cmo.setLoginTimeoutMillis(25000)
		cmo.setListenPort(SSLPort)

		cd('/Servers/'+server+'/Log/Server-0')
		cmo.setDateFormatPattern('MMM d, yyyy h:mm:ss,SSS a z')
		cmo.setFileMinSize(500)
		cmo.setFileName('logs/ManagedServer_4.log')
		cmo.setLogMonitoringMaxThrottleMessageSignatureCount(1000)
		cmo.setRedirectStderrToServerLogEnabled(false)
		cmo.setDomainLogBroadcasterBufferSize(1)
		cmo.setRotationType('bySize')
		cmo.setFileCount(7)
		cmo.setRedirectStdoutToServerLogEnabled(false)
		cmo.setStdoutLogStack(true)
		cmo.setLogMonitoringIntervalSecs(30)
		cmo.setLogMonitoringEnabled(true)
		cmo.setStacktraceDepth(5)
		cmo.setLoggerSeverity('Warning')
		cmo.setStdoutFormat('standard')
		cmo.setLogMonitoringThrottleThreshold(1500)
		cmo.setNumberOfFilesLimited(true)
		cmo.setStdoutSeverity('Critical')
		cmo.setLogMonitoringThrottleMessageLength(50)
		cmo.setRotateLogOnStartup(true)
		cmo.setBufferSizeKB(8)
		cmo.setDomainLogBroadcastSeverity('Critical')
		cmo.setLogFileSeverity('Warning')

		cd('/Servers/'+server+'/WebServer/'+server+'/WebServerLog/'+server+'')
		cmo.setFileMinSize(500)
		cmo.setFileName('logs/access.log')
		cmo.setRotationType('bySize')
		cmo.setFileCount(7)
		cmo.setLoggingEnabled(false)
		cmo.setNumberOfFilesLimited(false)
		cmo.setRotateLogOnStartup(true)

		cd('/Servers/'+server+'/DataSource/'+server)
		cmo.setRmiJDBCSecurity('Compatibility')

		cd('/Servers/'+server+'/ServerStart/'+server)
		cmo.setArguments('')
		
		cd('/Servers/'+server+'/ServerDiagnosticConfig/'+server)
		cmo.setWLDFDiagnosticVolume('Low')
	except:
		dumpStack()	
		print "Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
	
def loadProperties(fileName):
	properties = Properties()
	input = FileInputStream(fileName)
	properties.load(input)
	input.close()
	result= {}
	for entry in properties.entrySet(): result[entry.key] = entry.value
	return result

appType='FCPM';	
print appType

properties = loadProperties(appType+".properties")
username = properties['username']
password = properties['password']
url = properties['providerURL']
targetServerName = properties['TARGET_SERVER']	
dsURL = properties['dsURL']
dsUserName = properties['dsUserName']
dsPassword = properties['dsPassword']
datasourceTarget = properties['datasourceTarget']
DSFile=properties['DataSource_File']

servername=properties['SERVER_NAME']
serverport=properties['SERVER_PORT']
serverSSLP=properties['SERVER_SSLP']

# Datasource Configuration
f_ds = open(DSFile, 'r')
dsArray = [ds.strip() for ds in f_ds]
f_ds.close()

connect(username, password, url)
adminServerName = cmo.adminServerName
try:
	print "Connected to Admin Server"
	
	print "Creating new Server"
	startTransaction()		
	print "ManagedServer Creation"
	createManagedServer(servername,serverport,serverSSLP)
	endTransaction()
		
except:
	dumpStack()
	cancelEdit("y")
print "disconnect"
disconnect()
print "exit"
exit()	
