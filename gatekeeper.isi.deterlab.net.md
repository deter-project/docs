# gatekeeper.isi.deterlab.net

Gatekeeper is a bridging firewall running FreeBSD 7.3 and pf.

## Hardware

* Dell PowerEdge Chassis
* Pentium 4 2.4Ghz
* 256Mb of RAM
* 40GB Seagate ST340014A Hard Drive

## Interfaces
* Dual Port Card 1
  * em0 internet facing interface (verify)
   * ether 00:04:23:c2:8e:a8
  * em1 testbed facing interface (verify)
   * ether 00:04:23:c2:8e:a9
  
* Dual Port Card 2
  * em2 is unused
   * ether 00:04:23:a5:ac:ee
  * em3 10.0.23.0/24 network, address 10.0.23.254
   * ether 00:04:23:a5:ac:ef

## Bridging Configuration

* bridge0 consists of em0 and em1
* bridge0 is configured in rc.conf with the following lines:
   	
	   cloned_interfaces="bridge0"
	   ifconfig_bridge0="inet 206.117.25.46 netmask 255.255.255.0 addm em0 addm em1 up"
	   ifconfig_em0="up"
	   ifconfig_em1="up"
	   

## PF configuration

* Two sysctl variables need to be set in order to enable pf on a bridged interface in /etc/sysctl.conf.  Rules on bridges have no direction.
   	
	   net.link.bridge.pfil_bridge=1
	   net.link.bridge.pfil_onlyip=1
	   
* pf is enabled in /etc/rc.conf
   	
	   pf_enable="YES"
	   pflog_enable="YES"
	   

* The pf.conf file is in CVS under /operations/configuration/gatekeeper

* The kernel configuration in /operations/configuration/gatekeeper contains the pf and pflog devices:
   	
	   device          pf
	   device          pflog
	   


## NAT Configuration

* We have a NAT'ed network hanging off of gatekeeper for machines that need to access the internet, but do not need to have it.
* The sysctl variable for ip forwarding is enabled in /etc/sysctl.conf:
 	
	 net.inet.ip.forwarding=1
	 

