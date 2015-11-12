# DETER ZFS Storage

DETER offers a projects access to bulk storage using a large ZFS system.  Right now, we automatically export and create ZFS space for every active project on the testbed, but we do not mount it by default on testbed nodes.  Mounting the filesystem by hand is pretty simple.  For Linux:

	
	mkdir -p /zfs/<PROJECTNAME>
	mount -t nfs -o tcp,vers=3 zfs:/zfs/<PROJECTNAME> /zfs/<PROJECTNAME>
	

On FreeBSD use the nfsv3 option when mounting.