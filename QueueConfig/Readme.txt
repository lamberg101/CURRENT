1 - FCPM.properties
	
	->	Set the Server Name
	->	File Store Path for Queue Creation
	-> 	Queue Data Input
	->	Datasource Data Input

2 - WLSConfig.sh -> Final Executable
	
	-> DOMAIN PATH and WL_SERVER path need to be set before execution
	
3 - Invoke WLSConfigQ.py in case of Queue Creation	
	Invoke WLSConfigDS.py in case of Datasource Creation
	Invoke WLSConfigServer.py in case of Managed Server Creation

This script should be executed from bash/sh. ( Putty ).
Place all these scripts in one folder with Modified Properties File and WLSConfig.sh.
Internally, WLSConfig.sh will trigger WLSConfigQ for Queue Creation.
In case of Datasource Creation,change the call to WLSConfigDS in WLSConfig.sh.



	

	