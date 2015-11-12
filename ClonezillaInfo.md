This is an analysis of Clonezilla and how it might be integrated into DeterLab as a replacement to the MFS image arrangement we currently have using frisbee to distribute images to Deter nodes. The main motivations behind switching to such a system is that it hopefully is more widely used and, thus, maintained by a number of different projects, and that it might increase the rate at which we can image new nodes, allowing us to bring experiments up more quickly.

# About Clonezilla

Clonezilla is a project started by a Taiwanese research lab called the NCHC (National Center for High Performance Computing) as a way to more easily provision their large high performance computing clusters. Development on the project seems to be active with the last major release being 2.1.2-20 released on 3 July 2013.

## Clonezilla’s Purpose

On a high level Clonezilla is a system that allows the mass imaging of many systems over multicast through a PXE boot process. Let us go through a scenario in order to explain how this might work.

Let’s say that we have two machines we would like to put a new image on called A and B and a third machine that we are running Clonezilla on called C. In order to allow C to image these machines we must first inform C about these nodes. This is generally done through a setup process whereby C acts as a DHCP server and collects MAC addresses from nodes while they try to PXE boot. In order to do this we must configure A and B to always try to PXE boot and nothing else. Unless A and B are PXE booting every time Clonezilla won’t be able to provision them.

Once this initial setup process is finished we can then tell the Clonezilla that we would like to image A and B. This process starts a udpcast server on the Clonezilla server. Then we should restart A and B. When they start back up Clonezilla will serve each of them a Linux based boot image over PXE that runs a udpcast command in order to grab the image and throw it on to a local drive/partition. Because of the way that udpcast works it will not start transmitting until all the nodes have rendezvoused or until a timeout expires. After this the udpcast server will serve up the image and A and B will pipe this data into an image restoration program that will write it to the drive. Once this is finished the machine will restart and PXE boot again, but this time will chain into the newly restored image.

## Composite Parts

Clonezilla is mainly a collection of shell scripts that combine many other pieces of software together into a useful system. The first of these is DRBL, another project of NCHC.  DRBL stands for Diskless Remote Boot Linux. The main purpose of DRBL is to allow a single server to maintain the filesystem for a machine while other nodes may boot without a local disk and will be fed a boot image over PXE that sets up an NFS mount on the remote DRBL server to allow it to operate without a disk.

Clonezilla’s goal is somewhat more modest than this, but it uses DRBL’s PXE boot support in order to actually serve images to nodes.

As for multicast Clonezilla simply uses udpcast’s udp-send and udp-receive commands in order to move data from the Server to nodes.

For partition imaging Clonezilla is able to use three systems: partimage, partclone, ntfsclone, and dd.

Partimage is unaffiliated with NCHC and started development in 2001, though it doesn’t seem to be in especially active development as the last stable release was in 2010. It supports many file systems (with support meaning it can essentially ignore unused sectors on the disk to reduce image size and clone/restoration time) specifically: ext2/ext3, reiserfs-3, fat16/32, hpfs, jfs, xfs.  Beta: ufs, hfs Experimental: ntfs. Of note from this list, though, is that UFS’s support is apparently “experimental”. In addition, ext4 is very much not supported. An ext4 image can be cloned as an ext3 image, but if any ext4 features are used (like extents) then it will result in an unusable image. Partimage claims that the format is designed to ensure that restoring a disk happens sequentially across the drive so that it uses the minimum number of seeks.

Partclone is a project developed by NCHC as a replacement to partimage and is the default imaging system used by Clonezilla. It has support for many more filesystems, though ext2, ext3, ext4, hfs+, reiserfs, reiser4, btrfs, vmfs3, vmfs5, xfs, jfs, ufs, ntfs, fat(12/16/32), exfat.

Ntfsclone: for the purpose of this analysis we didn't look into ntfsclone too much. As the name suggests, it only supports cloning ntfs.

dd is exactly what you’d expect, it simply runs dd on the partition and writes it to a file.  The file is generally gzipped to save some space, though it still ends up being very large. Since the above systems support most of the common file system formats dd is rarely used, though it is available if a partition’s file system is unsupported.

## Clonezilla’s Shortcomings

As of version 2.1.2-20 Clonezilla doesn't actually support multiple image restore sessions happening on the same LAN. This is something that would definitely need to be remedied if it was adopted by DeterLab. On the positive side, though, this isn't a problem with udpcast itself. Udpcast uses a default multicast address that Clonezilla doesn't change right now. Adding support for multiple restores would only involve modifying the way that Clonezilla calls udpcast to ensure that we have each restore session happening on its own multicast address.

# Performance Numbers

In order to test potential performance of Clonezilla in comparison to the current frisbee system we created a deter experiment for testing each. The Clonezilla experiment used three Ubuntu machines with one server imaging two clients while the frisbee experiment used three FreeBSD 9 machines running frisbee (this is due to the fact that while Frisbee’s imagezip and imageunzip programs can be compiled and run on Linux, Frisbee's frisbee client can only run under FreeBSD).

We also eliminated the DRBL part of Clonezilla from the experiment since getting nodes to PXE boot properly from within a DeterLab experiment is very difficult since the Deter system itself has is also serving PXE images to the node in order to actually allow the system to operate. For that reason testing on the Clonezilla side of things only involved using udpcast on the nodes and piping the outputs to the different available image restoration programs and timing how long this took.

The tcl file for the Clonezilla experiment looks like this:
	
	source tb_compat.tcl
	set ns [new Simulator]
	
	# crate new nodes. the default image is 64-bit Ubuntu
	set server [$ns node]
	set client1 [$ns node]
	set client2 [$ns node]
	
	set lan0 [$ns make-lan "$server $client1 $client2" 1000Mb 0ms]
	
	$ns run
	

For testing purposes the [UBUNTU12-64-STD](https://www.emulab.net/downloads/images-STD/UBUNTU12-64-STD.ndz) emulab image was used. Using imagezip we put it on /dev/sda4 on an experimental node and created a partclone and partimage image out of it.

Similarly we tested frisbee from the same three nodes after compiling it for Linux. For frisbee we had to manually tell it the bandwidth between our nodes (1Gbit) in order to get it to perform comparably. This value is actually higher than the perl script that Deterlab uses to start frisbee sets it to. The script in question can be found at [https://github.com/deter-project/testbed/blob/development/tbsetup/frisbeelauncher.in] with lines 75, 76, and 265-272 being of particular interest.

These tests rendered the following data:

||Setup||Udpcast/Partclone||Udpcast/Partimage||Frisbee/Imagezip (1Gbit/s limit)||Frisbee/Imagezip (1Gbit/s limit with 9000 byte jumbo frames)||Frisbee/Imagezip (72Mbit/s limit)||Udpcast/Imagezip||
||Image Size||1.8GB (512MB after recommended gzipping)||508MB||528MB||528MB||528MB||||528MB
||Filesystem support||ext2, ext3, ext4, hfs+, reiserfs, reiser4, btrfs, vmfs3, vmfs5, xfs, jfs, ufs, ntfs, fat(12/16/32), exfat||ext2/ext3, reiserfs-3, fat16/32, hpfs, jfs, xfs.  Beta: ufs, hfs Experimental: ntfs||extfs (except ext4 specific features), ffs, fat, ntfs||extfs (except ext4 specific features), ffs, fat, ntfs||extfs (except ext4 specific features), ffs, fat, ntfs||extfs (except ext4 specific features), ffs, fat, ntfs||
||Restore time trial 1||50.73s||62.14s||37.26s||37.42s||71.6s||88.41s||
||Restore time trial 2||53.22s||64.87s||37.51s||38.79s||70.95s||87.79s||
||Restore time trial 3||51.12s||65.87s||37.54s||37.42s||70.99s||86.95s||
||Average restore time||52.02s||64.33s||37.44s||37.88s||71.18s||87.72s||
||Clone time trial 1||170.68s||195.37s||xxx.xxs||xxx.xxs||xxx.xxs||xxx.xxs||
||Clone time trial 2||169.52s||195.03s||xxx.xxs||xxx.xxs||xxx.xxs||xxx.xxs||
||Clone time trial 3||171.2s||195.23s||xxx.xxs||xxx.xxs||xxx.xxs||xxx.xxs||
||Average clone time||170.47s||195.21s||xxx.xxs||xxx.xxs||xxx.xxs||xxx.xxs||

## Analysis

It seems that using Clonezilla doesn't provide any increased performance over the current frisbee/imagezip solution. Clonezilla is, of course, used by many more people and would be better supported than Clonezilla.

While doing these tests, though, I noticed that it seems that the maximum bandwidth frisbee is allowed to use is limited to 72Mbit/s.  Since there are at least gigabit links to the nodes this could be improved by setting the limit higher or by adding a kind of congestion avoidance layer into frisbee.