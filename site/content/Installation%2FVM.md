[[TOC]]

# Networking

Although you might be tempted to setup your network after importing the virtual machine templates, we *strongly* recommend having your networking in order before proceeding.  By having the network setup, the virtual machines will automatically associate the appropriate networks with their virtual interfaces.  Experience has shown that getting the network in order first will dramatically cut down on deployment time.

# Server Templates

There are three VMWare templates available at http://deterlab.net/~jjh/Deter%20VM%20Images/ for Boss, Users, and Router nodes.  These images don't contain the DETER source, but do have all packages required package to build the testbed source.  

Templates are easy to deploy on your local ESXi server.

In the 'vSphere Client' Select 'File'->'Deploy OVF Template' and put in the URL for the OVA template you are deploying:

[[Image(Deploy OVA.png)]] 

The network mapping for your VM should map 1:1.  If it does not, *please make sure your networking is properly setup before proceeding*.  The previous section explains the network setup.

[[Image(Network Mapping.png)]] 


# A note about Virtual Machines and CPU core allocation

The boss and users templates come configured to use 2 CPUs.  This is problematic on VMWare servers with less than 2 CPUs, since you can only give a VM up to as many cores as the ESXi host has.  If you are installing onto an ESXi host that has fewer than 2 CPUs, you will have to edit the number of allocated cores in the VM settings for boss and users before being able to boot them.

## Users Image Notes

The users image contains two disk images.  One is for the main operating system and the other is for NFS exported filesystems.  These are kept separate in order to make it easy for sites to deploy a bigger NFS export filesystem.  You may want to replace the second image with a larger image.  Here are the steps used to setup the original /big disk (which is 80GB).  Make sure to pay attention to the device you are setting up.  If you are adding a third disk to replace the existing big, you will probably be dealing with 'da2':  

	
	root@users:/root # dmesg | tail
	da1 at mpt0 bus 0 scbus2 target 1 lun 0
	da1: <VMware Virtual disk 1.0> Fixed Direct Access SCSI-2 device 
	da1: 320.000MB/s transfers (160.000MHz DT, offset 127, 16bit)
	da1: Command Queueing enabled
	da1: 81920MB (167772160 512 byte sectors: 255H 63S/T 10443C)
	root@users:/root # gpart create -s gpt /dev/da1                                                                                                                                                                                        
	da1 created
	root@users:/root # gpart add -t freebsd-ufs da1
	da1p1 added
	root@users:/root # tunefs -j enable /dev/da1p1 
	Using inode 4 in cg 0 for 33554432 byte journal
	tunefs: soft updates journaling set
	root@users:/root # vim /etc/fstab 
	root@users:/root # cat /etc/fstab
	# Device        Mountpoint      FStype  Options Dump    Pass#
	/dev/da0p2      /               ufs     rw      1       1
	/dev/da0p3      none            swap    sw      0       0
	/dev/da1p1      /big            ufs     rw      1       1
	root@users:/root # mount /big
	root@users:/root # df -h
	Filesystem    Size    Used   Avail Capacity  Mounted on
	/dev/da0p2     73G     11G     56G    16%    /
	devfs         1.0k    1.0k      0B   100%    /dev
	/dev/da1p1     77G     32M     71G     0%    /big
	root@users:/root # cd /big
	root@users:/big # mkdir groups  proj    share   users
	root@users:/big # ls
	.snap           .sujournal      groups          proj            share           users
	root@users:/big # 
	

The users image is also configured with 'tinyproxy' which will allow isolated testbed nodes to fetch packages via HTTP.  The configuration is /usr/local/etc/tinyproxy.conf.   The proxy should be configured to only listen to requests coming from the control network.

## Boss Image Notes

Nothing special to note yet.


## Router Image Notes

This image is minimally configured to route between the various networks.  It is also configured to route/relay Multicast and DHCP requests between boss and the control network.