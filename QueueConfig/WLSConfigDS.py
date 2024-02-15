# WLST Script to create and configure JMS resources.
# Ensure that the Datasource Name does not have any / characters. WLST will reject the names with"/"
# Additional fields in case of Datasource Config
# Datasource Related parameters that can be used for Configuration
# cd('/JDBCSystemResources/jdbc_fcjpmDSTest1/JDBCResource/jdbc_fcjpmDSTest1/JDBCDataSourceParams/jdbc_fcjpmDSTest1')
# cd('/JDBCSystemResources/'+dsName+'/JDBCResource/'+dsName+'/JDBCConnectionPoolParams/'+dsName)
# cmo.setInactiveConnectionTimeoutSeconds(30)
# cmo.setTestConnectionsOnReserve(true)
# cmo.setWrapTypes(true)
# cmo.setPinnedToThread(false)
# cmo.setHighestNumWaiters(2147483647)
# cmo.setCountOfRefreshFailuresTillDisable(2)
# cmo.setStatementTimeout(-1)
# cmo.setConnectionHarvestMaxCount(1)
# cmo.setLoginDelaySeconds(0)
# cmo.setCountOfTestFailuresTillFlush(2)
# cmo.setSecondsToTrustAnIdlePoolConnection(10)
# cmo.setShrinkFrequencySeconds(900)
# cmo.setConnectionHarvestTriggerCount(-1)
# cmo.setConnectionReserveTimeoutSeconds(10)
# cmo.setRemoveInfectedConnections(true)
# cmo.setTestTableName('SQL ISVALID\r\n')
# cmo.setIgnoreInUseConnectionsEnabled(true)
# cmo.setConnectionCreationRetryFrequencySeconds(0)
# cmo.setTestFrequencySeconds(120)
# cmo.setInitialCapacity(15)
# cmo.setMinCapacity(1)
# cmo.setStatementCacheSize(10)
# cmo.setMaxCapacity(75)
# cmo.setStatementCacheType('LRU')

# Datasource configuration to set 2 Phase commit in case of ELCM.
# cd('/JDBCSystemResources/'+dsName+'/JDBCResource/'+dsName+'/JDBCDataSourceParams/'+dsName)
# cmo.setGlobalTransactionsProtocol('EmulateTwoPhaseCommit')
# cmo.setGlobalTransactionsProtocol('OnePhaseCommit')
# cmo.setGlobalTransactionsProtocol('LoggingLastResource')
# cmo.setGlobalTransactionsProtocol('None')

# Datasource to be targeted to Multiple Servers
# cd('/JDBCSystemResources/'+dsName)
# set('Targets',jarray.array([ObjectName('com.bea:Name=Server1,Type=Server'), ObjectName('com.bea:Name=Server2,Type=Server')], ObjectName))


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
	
def createDS(dsName,dsJNDIName,dsURL,dsUserName,dsPassword):
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
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCConnectionPoolParams/' + dsName )
		#cmo.setTestTableName(dsTestQuery)
		cmo.setInactiveConnectionTimeoutSeconds(30)
		cmo.setTestConnectionsOnReserve(true)
		cmo.setShrinkFrequencySeconds(900)
		cmo.setTestFrequencySeconds(60)
		cmo.setSecondsToTrustAnIdlePoolConnection(10)
		cmo.setConnectionReserveTimeoutSeconds(30)

		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName )
		#try:
		cmo.createProperty('user')		 
		#except:
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName + '/Properties/user')
		cmo.setValue(dsUserName)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName )	
		cmo.setGlobalTransactionsProtocol('None')
		 
		cd('/SystemResources/' + dsName )
		
		#set('Targets',jarray.array([ObjectName('com.bea:Name=' + datasourceTarget + ',Type=Server')], ObjectName))	
		set('Targets',jarray.array([ObjectName('com.bea:Name='+datasourceTarget+',Type=Cluster')], ObjectName))		

	except:
		dumpStack()	
		print "Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
	#endTransaction()

def createDS_ELPM(dsName,dsJNDIName,dsURL,dsUserName,dsPassword,XAType):
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
		#cmo.setPassword(dsPassword)
		set('Password', dsPassword)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCConnectionPoolParams/' + dsName )
		#cmo.setTestTableName(dsTestQuery)
		cmo.setInactiveConnectionTimeoutSeconds(30)
		cmo.setTestConnectionsOnReserve(true)
		cmo.setShrinkFrequencySeconds(900)
		cmo.setTestFrequencySeconds(60)
		cmo.setSecondsToTrustAnIdlePoolConnection(10)
		cmo.setConnectionReserveTimeoutSeconds(30)

		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName )
		cmo.createProperty('user')
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName + '/Properties/user')
		cmo.setValue(dsUserName)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName )	
		#cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')
		cmo.setGlobalTransactionsProtocol(XAType)
		 
		cd('/SystemResources/' + dsName )		
		#set('Targets',jarray.array([ObjectName('com.bea:Name=' + datasourceTarget + ',Type=Server')], ObjectName))	
		set('Targets',jarray.array([ObjectName('com.bea:Name='+datasourceTarget+',Type=Cluster')], ObjectName))	

	except:
		dumpStack()	
		print "Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
	#endTransaction()
	
def createDSXA(dsName,dsJNDIName,dsURL,dsUserName,dsPassword,XAType):
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
		#cmo.setTestTableName(dsTestQuery)
		cmo.setInactiveConnectionTimeoutSeconds(30)
		cmo.setTestConnectionsOnReserve(true)
		cmo.setShrinkFrequencySeconds(900)
		cmo.setTestFrequencySeconds(60)
		cmo.setSecondsToTrustAnIdlePoolConnection(10)
		cmo.setConnectionReserveTimeoutSeconds(30)

		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName )
		cmo.createProperty('user')
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName + '/Properties/user')
		cmo.setValue(dsUserName)
		 
		cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName )	
		#cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')
		cmo.setGlobalTransactionsProtocol(XAType)
		 
		cd('/SystemResources/' + dsName )		
		#set('Targets',jarray.array([ObjectName('com.bea:Name=' + datasourceTarget + ',Type=Server')], ObjectName))	
		set('Targets',jarray.array([ObjectName('com.bea:Name='+datasourceTarget+',Type=Cluster')], ObjectName))	

	except:
		dumpStack()	
		print "Unexpected error: ", sys.exc_info()[0], sys.exc_info()[1]
	#endTransaction()
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
#dsURL = properties['dsURL']
#dsUserName = properties['dsUserName']
#dsPassword = properties['dsPassword']
datasourceTarget = targetServerName 
DSFile=properties['DataSource_File']

# Datasource Configuration
f_ds = open(DSFile, 'r')
dsArray = [ds.strip() for ds in f_ds]
f_ds.close()

connect(username, password, url)
adminServerName = cmo.adminServerName
try:
	print "Connected to Admin Server"	
	startTransaction()			
	print "Creating DataSources!!"
	for i in range(len(dsArray)-1):
		print dsArray[i]
		dsSubArray=dsArray[i].split('|')	
		print dsSubArray	
		dsURL = dsSubArray[3]
		dsUserName = dsSubArray[4]
		dsPassword = dsSubArray[5]
		if dsSubArray[0] == 'N':
			dsDriverName='oracle.jdbc.OracleDriver'			
			#print "Before Normal DS creation"
			createDS(dsSubArray[1],dsSubArray[2],dsURL,dsUserName,dsPassword)
		elif dsSubArray[0] == 'XA':
			dsDriverName='oracle.jdbc.xa.client.OracleXADataSource'
			globalTxnProtocol='TwoPhaseCommit'
                        #print "Before XA DS creation"
			createDSXA(dsSubArray[1],dsSubArray[2],dsURL,dsUserName,dsPassword,globalTxnProtocol)
		elif dsSubArray[0] == 'XAEL':
			dsDriverName='oracle.jdbc.OracleDriver'
			globalTxnProtocol='EmulateTwoPhaseCommit'
                        #print "Before XAEL DS creation"
			createDS_ELPM(dsSubArray[1],dsSubArray[2],dsURL,dsUserName,dsPassword,globalTxnProtocol)
		elif dsSubArray[0] == 'XAPM':
			dsDriverName='oracle.jdbc.OracleDriver'			
			globalTxnProtocol='LoggingLastResource'
                        #print "Before XAPM DS creation"
			createDS_ELPM(dsSubArray[1],dsSubArray[2],dsURL,dsUserName,dsPassword,globalTxnProtocol)	
	endTransaction()
except:
	dumpStack()
	cancelEdit("y")
print "disconnect"
disconnect()
print "exit"
exit()	
