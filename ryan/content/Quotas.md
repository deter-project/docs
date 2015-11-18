# Quotas on DETER

Right now we are only enforcing home directory quotas on /mnt/other on users.  The protouser for the quotas is elabman.  Quotas have been applied up to UID 60000.

	
	edquota -p elabman 12001-60000
	