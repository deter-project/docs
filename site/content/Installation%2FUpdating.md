# Updating the DETER meta packages
                                                                                                               
The dependencies are installed via a special meta package.  This is already installed on the stock images, so if you get a conflict let us know.


	                                                                                                                             
	 cd testbed/install/ports                                                                                                    
	 sudo make install                                                                                                           
	 cd /usr/ports/misc/instant-deter                                                                                            
	 sudo make deinstall                                                                                                         
	 sudo make reinstall                                                                                                         
	                                                                                                                         

# Updating the codebase

In order to update the codebase, running the install script is not necessary.

	
	cd ~/testbed
	git pull
	sudo rm -rf ~/obj
	mkdir ~/obj
	cd ~/obj
	../testbed/configure --with-TBDEFS=../testbed/defs-<your defs>
	gmake
	sudo gmake [boss|users]-install
	sudo gmake post-install # on boss
	

## Updating the database on boss

There is a database update script, testbed/db/dbupdate.in, that will run the various update scripts against your existing database on boss.  These scripts are located in testbed/sql/updates.  Please make sure to backup your database before running:

	
	~/obj/db/dbupdate tbdb
	

## Updating switch node and interface types

In order to add our switch to the database, we need to setup node and interface types for them.

We provide some SQL to make this easy.  The script switch-types-create defines the following:

* Node types for hp5412 (which included hp5406), hp2810, and nortel5510 switch types.
* Interfaces for generic inter-switch trunks (if your site has more than one switch) named "trunk_100MbE", "trunk_1GbE", and "trunk_10GbE".

For other switch types, please refer to the [Emulab Documentation](https://users.emulab.net/trac/emulab/wiki/install/switches-db.html).

These are *loaded by boss-install* script, but if you need to load them by hand:

	
	mysql tbdb < ~<builduser>/testbed/sql/interface-types-create.sql
	mysql tbdb < ~<builduser>/testbed/sql/node-types-create.sql
	