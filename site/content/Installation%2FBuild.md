# Overview

Since users is the file server, it is important that we install and reboot it first.  We can then proceed with the boss installation, since part of the boss installation involved mounting directories exported during users setup.

* Users *MUST* be installed first.
* Internal networking *MUST* be functional.
* Once the testbed software has been built on users, log into boss.
* You *MUST* use the latest source.

# Make sure your network is working first

All network traffic between boss and users goes by default over their private networks.  It is important that your boss and users images are able to ping each other through router. 


# Build Process

The original installation documentation is here.  I strongly recommend                                                       
reading through it in order to understand where the DETER install process                                                    
is evolving from:                                                                                                            
                                                                                                                             
 https://users.emulab.net/trac/emulab/wiki/InstallRoot                                                                       

# Getting access to the source code

We currently use a private github repository for the testbed codebase.  Please contact us for access.

# First Login to an image

Boss and Users come with a default 'deterbulid' account.  The password is 'deterinavm' and the account has full sudo privileges.  For Router, the root account has the same password.

When you first login to the Users image, you will be prompted to change your password and then for details about your Github account.

When you first login to the Boss image, you will be told that your home directory does not exist.  Do not worry about this.  You will be able to mount the home directory for the DETER build user once Users is installed (I export the repo over NFS in order to reduce the confusion of having two repos on two machines using the same definition files). 

# Configuring External Network Access

You will need to configure both the Boss and Users VM images with external, static IP addresses.  The configuration is at the top of the file '/etc/rc.conf' and the default External interface is 'em0' for both images.
Make sure to put in default route.  The initial name server configuration is set to use Google's 8.8.8.8 out of the box.  The testbed install process will change resolv.conf to use the nameserver on Boss once the installation is complete.
You can find more details about configuring FreeBSD networking.  [FreeBSD Handbook](http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/config-network-setup.html).

Once you have edited '/etc/rc.conf,'  you can test the setup by issuing the following commands: 

	
	sudo service netif restart
	sudo service routing restart
	ping -c1 www.google.com
	

# Updating to the latest code

Once you have setup external network access, it is easy to update to the latest source code.  When logged in as the 'deterbuild' user, simply:

	
	cd ~/testbed
	git pull
	

# Testing Internal Network access

The install process depends on the internal networking and Router image being operational.

From Users, try pinging Router and then Boss:
	
	ping -c1 192.168.253.254  # Router's address on the internal Users network
	ping -c1 192.168.252.1      # Boss's internal address
	

From Boss, try pinging Router and then Users:
	
	ping -c1 192.168.252.254  # Router's address on the internal Boss network
	ping -c1 192.168.253.254  # Users's internal address
	
                                                
# Creating a site definitions file 

When you have external network access working for your Users machine, you should be able to SSH in now.  In ~/testbed there is a file called defs-example-deter.  Change this file to reflect your site and save it as defs-<yoursite>.  We have slimmed down the defs file so this should be self explanatory.  Here is what defs-example-deter currently contains:

	
	#
	# This is an example definitions file for configure.
	#
	# Use the --with-TBDEFS=filename to specify your own file.
	# If you add a variable, be sure to go and update configure.in.
	#
	
	# The subdomain name of this installation
	OURDOMAIN=example.deterlab.net
	THISHOMEBASE=Example.Deterlab.Net
	SITENAME="USC/ISI"
	SITECOPYRIGHT="University of Southern California Information Sciences Institute (USC/ISI)"
	SITEDATES=2013
	
	#
	# SSL Setup
	#
	SSLCERT_COUNTRY="US"
	SSLCERT_STATE="California"
	SSLCERT_LOCALITY="Los Angeles"
	SSLCERT_ORGNAME="DETER EXAMPLE Testbed"
	
	#
	# Domain, host names, and external IP addresses
	#
	# The network that boss and users sit on
	EXTERNAL_TESTBED_NETWORK=A.B.C.0
	EXTERNAL_TESTBED_NETMASK=255.255.255.0
	
	# This should be boss.<yoursubdomain as defined in THISHOMEBASE>
	EXTERNAL_BOSSNODE_IP=A.B.C.D
	
	# This should be users.<yoursubdomain as defined in THISHOMEBASE>
	EXTERNAL_USERNODE_IP=A.B.C.D
	
	# Named forwarders, typically your upstream DNS servers.
	NAMED_FORWARDERS="A.B.C.D W.X.Y.Z"
	

# Building the testbed software on Users

Login as 'deterbuild' with the password 'deterinavm' to build the testbed code.  Be sure to pull down the latest source:

	
	cd testbed
	git pull
	

Now go into the ~/obj directory.

	
	cd ~/obj
	../testbed/configure --with-TBDEFS=../testbed/defs-<yoursite>
	

This will create the object tree for the testbed.  Once the object tree is build, run the users installation perl script:

	
	cd ~/obj/install
	sudo perl ./users-install
	

If the install process complains about an outdated metapackage, please refer to the next section.

The output of the build script will look like this:

	
	[jjh@users ~/obj/install]$ sudo perl users-install 
	WARNING: This script is ONLY intended to be run on a machine
	that is being set up as a dedicated users node. Continue? [y/N] y
	
	Creating users and groups                         
	| Creating tbadmin group                          [ Succeeded ] (16:00:42)
	+-----------------------------------------------> [ Succeeded ] (16:00:42)
	Creating /usr/testbed                             [ Succeeded ] (16:00:42)
	Setting directory permissions                     
	| /usr/testbed                                    [ Succeeded ] (16:00:42)
	| /users                                          [ Succeeded ] (16:00:42)
	| /proj                                           [ Succeeded ] (16:00:42)
	| /groups                                         [ Succeeded ] (16:00:42)
	| /share                                          [ Succeeded ] (16:00:42)
	+-----------------------------------------------> [ Succeeded ] (16:00:42)
	Installing main package                           [ Skipped (Package already installed) ]
	Applying patches                                  [ Succeeded ] (16:00:42)
	Adding testbed content to rc.conf                 [ Succeeded ] (16:00:42)
	Adding boss/ops/fs IP addresses to /etc/hosts     [ Succeeded ] (16:00:42)
	Checking to make sure names for boss/ops/fs resolve
	| users.mini-isi.deterlab.net                     [ Succeeded ] (16:00:42)
	| users                                           [ Succeeded ] (16:00:42)
	| ops                                             [ Succeeded ] (16:00:42)
	| fs                                              [ Succeeded ] (16:00:42)
	| boss.mini-isi.deterlab.net                      [ Succeeded ] (16:00:42)
	| boss                                            [ Succeeded ] (16:00:42)
	+-----------------------------------------------> [ Succeeded ] (16:00:42)
	Configuring sendmail                              
	| Setting up /etc/mail/local-host-names           [ Succeeded ] (16:00:42)
	| Setting up mailing lists                        
	| | Creating /etc/mail/lists                      [ Succeeded ] (16:00:42)
	| | Creating mailing list files                   
	| | | testbed-ops                                 [ Succeeded ] (16:00:42)
	| | | testbed-logs                                [ Succeeded ] (16:00:42)
	| | | testbed-www                                 [ Succeeded ] (16:00:42)
	| | | testbed-approval                            [ Succeeded ] (16:00:42)
	| | | testbed-audit                               [ Succeeded ] (16:00:42)
	| | | testbed-stated                              [ Succeeded ] (16:00:42)
	| | | testbed-testsuite                           [ Succeeded ] (16:00:42)
	| | | testbed-ops                                 [ Skipped (File already exists) ]
	| | | testbed-logs                                [ Skipped (File already exists) ]
	| | +-------------------------------------------> [ Succeeded ] (16:00:42)
	| | Adding lists to /etc/mail/aliases             [ Succeeded ] (16:00:42)
	| | Running newaliases                            [ Succeeded ] (16:00:42)
	| +---------------------------------------------> [ Succeeded ] (16:00:42)
	+-----------------------------------------------> [ Succeeded ] (16:00:42)
	Setting up exports                                
	| Creating /etc/exports.head                      [ Succeeded ] (16:00:42)
	| HUPing mountd                                   [ Skipped (mountd not running) ]
	+-----------------------------------------------> [ Succeeded ] (16:00:43)
	Setting up NFS mounts                             [ Skipped (FSes are local) ]
	Setting up syslog                                 
	| Editing /etc/syslog.conf                        [ Succeeded ] (16:00:43)
	| Creating /var/log/tiplogs                       [ Succeeded ] (16:00:43)
	| Creating log directory                          [ Succeeded ] (16:00:43)
	| Creating log files                              
	| | /var/log/logins                               [ Succeeded ] (16:00:43)
	| | /var/log/tiplogs/capture.log                  [ Succeeded ] (16:00:43)
	| | /var/log/mountd.log                           [ Succeeded ] (16:00:43)
	| | /usr/testbed/log/pubsubd.log                  [ Succeeded ] (16:00:43)
	| | /usr/testbed/log/elvin_gateway.log            [ Succeeded ] (16:00:43)
	| +---------------------------------------------> [ Succeeded ] (16:00:43)
	| Setting up /etc/newsyslog.conf                  [ Succeeded ] (16:00:43)
	+-----------------------------------------------> [ Succeeded ] (16:00:43)
	Adding cron jobs                                  
	| Editing /etc/crontab                            [ Succeeded ] (16:00:43)
	| HUPing cron                                     [ Succeeded ] (16:00:43)
	+-----------------------------------------------> [ Succeeded ] (16:00:43)
	Editing /usr/local/etc/sudoers to allow wheel group[ Succeeded ] (16:00:43)
	Setting up Samba                                  
	| Installing smb.conf[.head]                      [ Succeeded ] (16:00:43)
	+-----------------------------------------------> [ Succeeded ] (16:00:43)
	Allowing root ssh                                 
	| Permitting root login through ssh               [ Succeeded ] (16:00:43)
	| Making root's .ssh directory                    [ Skipped (File already exists) ]
	| Installing temporary root ssh public key        [ Succeeded ] (16:00:43)
	+-----------------------------------------------> [ Succeeded ] (16:00:43)
	Setting up rc.d scripts                           
	| Installing testbed RC scripts                   
	| | Removing port version of elvind.sh            [ Skipped (File does not exist) ]
	| +---------------------------------------------> [ Skipped   ] (16:00:43)
	+-----------------------------------------------> [ Skipped   ] (16:00:43)
	----------------------------------------------------------------------
	Installation completed succesfully!
	Please reboot this machine before proceeding with boss setup
	Local mailing lists have been created, with no members, in
	/etc/mail/lists . Please add members to the following lists:
	testbed-ops@mini-isi.deterlab.net
	testbed-logs@mini-isi.deterlab.net
	testbed-www@mini-isi.deterlab.net
	testbed-approval@mini-isi.deterlab.net
	testbed-audit@mini-isi.deterlab.net
	testbed-stated@mini-isi.deterlab.net
	testbed-testsuite@mini-isi.deterlab.net
	testbed-ops@mini-isi.deterlab.net
	testbed-logs@mini-isi.deterlab.net
	[jjh@users ~/obj/install]$
	

# Setup mailing lists on users

You will have to add someone to the mailing lists in */etc/mail/lists* on users after the install:

	
	users# cd /etc/mail/lists
	users# foreach i ( `ls testbed-*` )
	foreach? echo "admin@yoursite.net" >> $i
	foreach? end
	

# Installing the Boss Node

*You must install and reboot the users node first.*

Log in as the 'deterbuild' user.  You will get an error about your home directory is missing.  You will have to mount the /share directory from Users by hand.  This will take a little while since DNS for the testbed is not setup yet:

 	
	sudo mkdir /share
	sudo mount 192.168.253.1:/big/share /share
	cd ~
	. .profile
	

Now clear out the object tree from the users install:

	
	sudo rm -rf obj
	mkdir obj
	

From here, the build process is pretty much the same as the Users process:

	
	cd ~/obj
	../testbed/configure --with-TBDEFS=../testbed/defs-<yoursite>
	cd ~/obj/install
	sudo perl ./boss-install
	
