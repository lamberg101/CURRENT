# WLST Script to create and configure JMS resources.
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

def createErrorQueue(qname, qjndiname):
	try:
		print "createErrorQueue() START",qname
		cd('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName)
		q1 = create(qname, "Queue")
		q1.JNDIName = qjndiname
		q1.subDeploymentName = subDeploymentName
	except:
		dumpStack()
		print "Error in createErrorQueue qname",qname

def createQueue(qname, qjndiname):
	try:
		print "createQueue() START ",qname
		cd('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName)
		cmo.createQueue(qname)
		cd('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName + '/Queues/' + qname)
		cmo.setJNDIName(qjndiname)
		cmo.setSubDeploymentName(subDeploymentName)
	except:
		dumpStack()
		print "Error in CreateQueuefor qname",qname

def doQueueSetting(qname, errorQueueName, expiryTime, redeliveryLimit):
	print "***************************"
	print "doQueueSetting() START ",qname,errorQueueName,expiryTime,redeliveryLimit
	print "***************************"
	try:
		#Setting Error Destination
		cd('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName + '/Queues/' + qname + '/DeliveryFailureParams/' +qname)
		cmo.setErrorDestination(getMBean('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName + '/Queues/' + errorQueueName))
		#cmo.setTimeToLive(120000)
		cmo.setExpirationPolicy('Redirect')

		if len(redeliveryLimit) > 0:
			print "Setting redeliveryLimit"
			cd('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName + '/Queues/' + qname + '/DeliveryFailureParams/' +qname)
			cmo.setRedeliveryLimit(int(redeliveryLimit))
			
		if len(expiryTime) > 0:
			cd('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName + '/Queues/' + qname + '/DeliveryParamsOverrides/' +qname)
			cmo.setTimeToLive(int(expiryTime))
		#Setting Error Destination
		print "done with the QueueSetting",qname,errorQueueName,expiryTime,redeliveryLimit
	except:
		dumpStack()		
		print "Error in doQueueSetting qname",qname,errorQueueName,expiryTime,redeliveryLimit

def createCF(cfname, cfjndiname, xaEnabled):
	print "createCF() START",cfname
	cd('/JMSSystemResources/'+appType+moduleName+'/JMSResource/'+appType+moduleName)
	cf = create(cfname, "ConnectionFactory")
	cf.JNDIName = cfjndiname
	cf.subDeploymentName = subDeploymentName
	# Set XA transactions enabled
	if (xaEnabled == "true"):
		cf.transactionParams.setXAConnectionFactoryEnabled(1)
	print "createCF() END"

def createJMSModule():
	print "createJMSModule() START"
	cd('/JMSSystemResources')	
	jmsModule = create(appType+moduleName, "JMSSystemResource")
	jmsModule.targets = (adminServer,)	
	cd(jmsModule.name)
	# Create and configure JMS Subdeployment for this JMS System Module		
	sd = create(subDeploymentName, "SubDeployment")	
	myJMSServer = getMBean('/JMSServers/' + appType+jmsServerName)
	sd.targets = (myJMSServer,)
	print "createJMSModule() END"

def createJMSServer():
	print "createJMSServer() START"
	startTransaction()
	# Delete existing JMS Server and its Filestore
	cd("/JMSServers")
	print "before delete JMS Store"
	deleteIgnoringExceptions(appType+jmsServerName)
	print "before filestore"
	cd("/FileStores")
	deleteIgnoringExceptions(appType+fileStoreName)
	# Create Filestore
	cd('/')
	filestore = cmo.createFileStore(appType+fileStoreName)
	filestore.setDirectory(properties['fileStoreDirecory'])
	filestore.targets = (adminServer,)
	endTransaction()
		
	startTransaction()
	cd("/JMSServers")
	# Create JMS server and assign the Filestore
	jmsServer = create(appType+jmsServerName, "JMSServer")
	jmsServer.setPersistentStore(filestore)
	jmsServer.targets = (adminServer,)
	endTransaction()
	print "createJMSServer() END"

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
# appType = properties['APPLICATION_TYPE']
moduleName = properties['JMS_MODULE_NAME']
subDeploymentName =properties['SUBDEPLOYMENT_NAME']
fileStoreName = properties['FILESTORE_NAME']
jmsServerName = properties['JMS_SERVER_NAME']
targetServerName = properties['TARGET_SERVER']
QueueCFFile = properties['QueueCFFile']
QueueFile = properties['QueueFile']
QueueErrorFile = properties['QueueErrorFile']
QueueConfigFile = properties['QueueConfigFile']
	
	
# QCF Configuration
f_qcf = open(QueueCFFile, 'r')
ConnFctArry = [qcf.strip() for qcf in f_qcf]
f_qcf.close()

# Queues
f_queues = open(QueueFile, 'r')
QueueArry = [queue.strip() for queue in f_queues]
f_queues.close()

# Error Queues
f_err_queues = open(QueueErrorFile, 'r')
errorQueryArray = [equeue.strip() for equeue in f_err_queues]
f_err_queues.close()

# Queue Configuration
f_queue_config = open(QueueConfigFile, 'r')
queueSettingArray = [qconfig.strip() for qconfig in f_queue_config]
f_err_queues.close()	
	
#################################################################################################
# Connect to Admin Server !!!!
#################################################################################################
connect(username, password, url)
adminServerName = cmo.adminServerName
	
try:
	print "Connected to Admin Server"
	domainName = cmo.name			
        cd("/Servers/"+targetServerName)		
	adminServer = cmo
	print adminServer			
	
	#Delete existing JMS Module
	#startTransaction()
	#cd('/')
	#cmo.destroyJMSSystemResource(getMBean('/SystemResources/'+appType+moduleName))
	#cmo.destroyJMSServer(getMBean('/Deployments/'+appType+jmsServerName))
	#cmo.destroyFileStore(getMBean('/FileStores/'+appType+fileStoreName))
	#cd("/JMSSystemResources")
	#deleteIgnoringExceptions(moduleName)
	#endTransaction()		
		
	print "Creating JMS Server !!"
	createJMSServer()
	
	startTransaction()	
	print "Creating JMS Module !!"	
	createJMSModule()
	endTransaction()

	startTransaction()		
	print "Creating Error Queues !!"
	for i in range(len(errorQueryArray)):
		errorQueueSubArray=errorQueryArray[i].split('|')
		createErrorQueue(errorQueueSubArray[0], errorQueueSubArray[1])		
	endTransaction()
			
	startTransaction()
	print "Creating Queues !!"
	for i in range(len(QueueArry)):
		QueueSubArray=QueueArry[i].split('|')
		createQueue(QueueSubArray[0], QueueSubArray[1])
	endTransaction()

	startTransaction()			
	print "Setting Queue connection !!"
	for i in range(len(queueSettingArray)):
		queueSettingSubArray=queueSettingArray[i].split('|')
		doQueueSetting(queueSettingSubArray[0], queueSettingSubArray[1],queueSettingSubArray[2], queueSettingSubArray[3])
	endTransaction()

	startTransaction()
	print "Creating Connection Factory !!"
	for j in range(len(ConnFctArry)):
		confctSubArray = ConnFctArry[j].split('|')
		createCF(confctSubArray[0], confctSubArray[1], "true")

	endTransaction()	
		
except:
	dumpStack()
	cancelEdit("y")
print "disconnect"
disconnect()
print "exit"
exit()
