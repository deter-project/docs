# All wiring needs to be completed and checked before proceeding with the installation

Your testbed must be fully wired before you attempt the software installation.  This means all testbed nodes and IPMI interfaces are fully connected.  It means that proper hardware has been purchased or sources.  A poor foundation for your DETER installation will create problems down the line.  We will be unable to diagnose basic wiring or setup problems remotely too.

# Public, Static IP addresses for Boss and Users

While DETER can be deployed behind a NAT, it is currently geared towards a public installation.  The default internal networks are:

* 192.168.254.0/24
* 192.168.253.0/24
* 192.168.252.0/24
* 172.16.0.0/12

If you try to deploy a DETER installation with RFC1918 external addresses, they must not conflict with these subnets.  Setting up a private DETER install requires more effort and is not recommended if it can be avoided.

# If you need a subdomain for your site, we can give you one

If you are setting up a standard public site, but don't have DNS, we can give you a subdomain of deterlab.net.