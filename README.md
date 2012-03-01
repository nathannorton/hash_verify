Hash Verify
===
Hash Verify will take hashes of files on your system and then store those hashes in a database. 

Some use cases you could use this application for are verifying important system files from tampering or validating backed up files against the original. 


Installing 
===
I have created a spec file so you can build this as an rpm. 

Using Hash Verify
===
Once installed you will be left with a binary "hash_verify", a config file in /etc/hash_verify/hash_verify.conf. and a cron entry. You can change the run time in the cron entry to enable multiple runs a day for example. The config file is quite well documented with varius use cases described in there. 

Set up Mongo
===
    1. install mongodb 
    2. set to start on reboot 
	- el5/6 : chkconfig mongod on 
	- f17+  : systemctl enable mongod.service
	- ubuntu: service mongod start  
    3. start the mongo shell (# mongo)
        - % use hash_verify
        - % db.addUser("username", "password")
    4. you may also only allow authenticated users to add to the database.	
once the above is done you should be able to connect to the mongo instance

