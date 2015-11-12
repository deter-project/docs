This page is a work in progress.  Please be sure to read and be familiar with the [Emulab documentation](https://users.emulab.net/trac/emulab/wiki/InstallDocs).  

The testbed needs to know what switches are connected to it and what power ports they are plugged into.  Right now, we insert these manually into the database.

Testbed nodes need to be setup to boot from the network by default.  This is done through the Preboot eXecution Environment, available for most network cards.  For onboard network cards, it is typically enabled through the BIOS.

* [Preboot Execution Environment on Wikipedia](http://en.wikipedia.org/wiki/Preboot_Execution_Environment)
* [Intel PXE firmware and utilities](http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=19186)

# Setting up the MFS for testbed nodes

These filesystems are PXE booted over the network via TFTP and allow us to perform various parts of node maintenance.

There are three different MFS (memory file system) images that come with DETER/Emulab.  

They are:

* The Admin MFS (/tftpboot/freebsd)
  * Primarily used to create new operating system images using imagezip and ssh
* The New Node MFS (/tftpboot/freebsd.newnode)
  * This is the default image for nodes not explicitly listed in dhcpd.conf. 
  * Has scripts to try to identify what type of node is being booted based on node_type variables.
  * Runs a process to enable auto-detection of which switch ports the node is wired into.
* The Frisbee MFS (/tftpboot/frisbee)
  * This image is used when loading an operating system image onto 
  
The reason all these tasks are split up among multiple images is to keep the image size down since they are booted over the network.  With faster networks, these images will likely be rolled into a single Linux based image in the future.

Each site will have to install root SSH keys from boss into each MFS and change the root password.

This process, along with fetching/unpacking the MFS tarball, has been automated by the script setup_mfs in testbed/install:

	
	[jjh@boss ~/testbed/install]$ sudo ./setup_mfs -h
	Usage: setup_mfs
	The setup phase is always performed.  Options not required
	  -g Get the MFS from web and extract
	  -f <filename> Use provided mfs tar.bz2 archive
	

This script will configure all three MFS images with your boss's root ssh key and a password of your choice.

The a copy of the MFS tarball is located in */share/tarballs* now.  

	
	
	[deterbuild@boss ~/testbed/install]$ sudo ./setup_mfs -f /share/tarballs/deter-mfs.tar.bz2 
	
	################################################################################
	# Extracting /share/tarballs/deter-mfs.tar.bz2 to /usr/testbed/tftpboot
	#
	Please enter a MFS root password
	Password: 
	Verifying - Password: 
	
	################################################################################
	# Setting up MFS: /usr/testbed/tftpboot/freebsd/boot
	#
	Created md0...
	Created /mnt-md0
	....
	

You can use the '-g' option to fetch the latest tarball as well:

	
	[jjh@boss ~/testbed/install]$ sudo ./setup_mfs -g
	
	################################################################################
	# Fetching http://www.deterlab.net/~jjh/Deter%20OS%20Images/deter-mfs.tar.bz2
	# Extracting to /usr/testbed/tftpboot
	#
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100 37.4M  100 37.4M    0     0  3295k      0  0:00:11  0:00:11 --:--:-- 3287k
	Please enter a MFS root password
	Password: 
	Verifying - Password: 
	
	################################################################################
	# Setting up MFS: /usr/testbed/tftpboot/freebsd/boot
	#
	Created md0...
	Created /mnt-md0
	Changing the image root password...
	Locking toor...
	Unmounting /mnt-md0
	Removing mount point /mnt-md0
	Unconfiguring md0
	Running prepare on mfs and kernel
	loader.conf: 
	loader.rc: 
	kernel: 
	mfsroot: mfsroot.gz updated...
	
	################################################################################
	# Setting up MFS: /usr/testbed/tftpboot/freebsd.newnode/boot
	#
	Created md0...
	Created /mnt-md0
	Changing the image root password...
	Locking toor...
	Unmounting /mnt-md0
	Removing mount point /mnt-md0
	Unconfiguring md0
	Running prepare on mfs and kernel
	loader.conf: 
	loader.rc: 
	kernel: 
	mfsroot: mfsroot.gz updated...
	acpi.ko: 
	
	################################################################################
	# Setting up MFS: /usr/testbed/tftpboot/frisbee/boot
	#
	Created md0...
	Created /mnt-md0
	Changing the image root password...
	Locking toor...
	Unmounting /mnt-md0
	Removing mount point /mnt-md0
	Unconfiguring md0
	Running prepare on mfs and kernel
	loader.conf: 
	loader.rc: 
	kernel: 
	mfsroot: mfsroot.gz updated...
	[jjh@boss ~/testbed/install]$  
	

# Network connections 

Generally each node will have a control network interface and experimental interfaces.  The control network interface should be on a switch port that is on the CONTROL (VLAN 2003) network.  The experimental interfaces should be on ports that are enabled, but can be in a default VLAN for now.

# BIOS settings for testbed nodes

The testbed nodes should be set to boot only off of the network.  Disable hard drive boot to prevent failed PXE requests from falling through to booting whatever is on the disk.

# Node Types

## Select a console type 

This setting will determine which MFS the node will boot.  If you are using a serial port, please be aware that by default, we use 115200 as the baud rate for all MFS images.  This is a compile time value, so it is best to use 115200. 

## Determining the disk type

It is important to know what sort of disks your new nodes have.  FreeBSD differentiates between SATA and SAS drives by using the device types ad and da, respectively.  Also, with older machines, the first ATA disk unit number may be 4.  You will need to know what disk type and unit number you are dealing with before attempting to create a node type.  It is easiest to probably boot a node to a FreeBSD live USB key and run "_geom disk list'_:

	
	$ geom disk list
	Geom name: cd0
	Providers:
1. Name: cd0
	   Mediasize: 0 (0B)
	   Sectorsize: 2048
	   Mode: r0w0e0
	   descr: NECVMWar VMware IDE CDR10
	   ident: (null)
	   fwsectors: 0
	   fwheads: 0
	
	Geom name: da0
	Providers:
1. Name: da0
	   Mediasize: 85899345920 (80G)
	   Sectorsize: 512
	   Mode: r2w2e3
	   descr: VMware Virtual disk
	   ident: (null)
	   fwsectors: 63
	   fwheads: 255
	

So for this example, our type is *da* and our unit is 0.

## Determining the control network interface

Before creating a node type, you should know which interface is the control network interface on your node.  Typically it is the first interface on the system, but sometimes it isn't.  You can double check that you have the correct interface by watching a node boot into the "freebsd.newnode" MFS.  During the boot, dhcp requests will be sent out of all interfaces in order to determine the control network interface.  Here is an example of a machine with 6 interfaces.  It turns out that the unit for the control network is 4 instead of 0.

	
	Emulab looking for control net among:  igb0 igb1 igb2 igb3 igb4 igb5 ...
	igb5: link state changed to UP
	igb3: link state changed to UP
	igb2: link state changed to UP
	igb0: link state changed to UP
	igb4: link state changed to UP
	Terminated
	Emulab control net is igb4
	

If you miss the boot message, don't worry.  You can log into the MFS after it booted and run this:

	
	pc4# kenv boot.netif.name
	igb4
	

## Creating the type

You will have to create a new "Node Type" for each class of node you wish to add to your testbed. 

1. Log into the your testbed web interface.  Go "Red Dot."
1. Select "Experimentation -> Node Status"
1. At the bottom of the page go click on the link that says "Create a New Type"

If you are creating a node type for a typical testbed pc, use the class 'pc.'  If you are creating a node type for special hardware, choose something else such as 'router' for routers or 'appliance' for appliance type nodes.


## Associating Operating System images with your new node type

After creating a new node type, you will need to enable support for it with each operating system image.  This can be accomplished by editing the operating system image through the web interface and selecting the new type.  On new installs, you can also cheat with the SQL command below.  Be sure to substitute *minipc* with the node type you created.

	
	mysql> insert into osidtoimageid select default_osid as osid, 'minipc' as type, imageid from images;
	Query OK, 5 rows affected (0.00 sec)
	Records: 5  Duplicates: 0  Warnings: 0
	
	mysql> select * from osidtoimageid;
	+-------+--------+---------+
	| osid  | type   | imageid |
	+-------+--------+---------+
	| 10007 | minipc |   10007 |
	| 10009 | minipc |   10009 |
	| 10005 | minipc |   10005 |
	| 10008 | minipc |   10008 |
	| 10006 | minipc |   10006 |
	+-------+--------+---------+
	5 rows in set (0.00 sec)
	

# Manually adding non-standard nodes
## Create the node type

See the section on node types.  For appliances, two things are important when creating the type:
* default_imageid_01 needs to be set to "No ImageID" (the entry is at the end of the list)
* imageable needs to be set to 0

## Create the nodes manually

Connect to the MySQL database on boss (typically tbdb).

	
	mysql> insert into nodes (node_id, type, phys_nodeid, role) values ("juniper1", "junpier", "juniper1", "testnode");
	

Update the other fields in the node table for this new type of node:

	
	mysql> update nodes set inception=now(), def_boot_path=_, def_boot_cmd_line='', next_boot_path='', pxe_boot_path='', rpms='', deltas='', tarballs='', startupcmd='', startstatus='none', bootstatus='unknown', status='', status_timestamp='', failureaction='fatal', eventstate='ISUP', state_timestamp=now(), op_mode='MINIMAL', op_mode_timestamp=now(), allocstate='FREE_DIRTY', allocstate_timestamp=now(), next_op_mode='', ipodhash=_ where type="juniper";
	

Set the node status to up for the newly created nodes:

	
	mysql> insert into node_status values ('juniper1', 'up', NULL);
	


## Create Interface Table Entries

Card is typically incremented and port is always 1 for testbed nodes (I know, confusing).

	
	mysql> insert into interfaces (node_id, card, port, interface_type, iface, role) values ("juniper1", 1, 1, "fop", "eth0", "expt");
	mysql> insert into interfaces (node_id, card, port, interface_type, iface, role) values ("juniper1", 2, 1, "fop", "eth1", "expt");
	

We must also setup the interface state table:

	
	mysql> insert into interface_state (node_id, card, port, iface) values ("juniper1", 1, 1, "eth0");
	mysql> insert into interface_state (node_id, card, port, iface) values ("juniper1", 2, 1, "eth1");
	

## Create the Wires Table Entries

Lets say our juniper has two ports on card 2 of our switch on ports 23 and 24:

	
	mysql> insert into wires (node_id1, node_id2, type, card1, port1, card2, port2) values ("juniper1", "hp1", "Node", 1, 1, 2, 23);
	mysql> insert into wires (node_id1, node_id2, type, card1, port1, card2, port2) values ("juniper1", "hp1", "Node", 2, 1, 2, 24);
	

## Add in entries for power and serial connectivity

If you have a serial controller, you can add an entry into the tip lines table.  The 'tipname' corresponds to the name given to the capture daemon on the serial server:

	
	mysql> insert into tiplines (tipname, node_id, server) values ('juniper1', 'juniper1', 'serial3');
	

If you have your node hooked up to a power controller, add a line into the outlets table to allow for power cycling:

	
	mysql> insert into outlets (node_id, power_id, outlet) values ('juniper1', 'power7', 3);
	

If your node is stuck in reloading you can restart the process by using the nfree command on boss:

	
	 nfree emulab-ops reloading pc2
	