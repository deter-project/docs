# Overview
	
	#!html
	Eucalyptus is an open-source software platform that implements <abbr title="Infrastructure as a Service">IaaS</abbr>-style cloud computing using the existing Linux-based infrastructure found in the modern data center. It is interface compatible with Amazon's <abbr title="Amazon Web Services">AWS</abbr> making it possible to move workloads between AWS and the data center without modifying the code that implements them. Eucalyptus also works with most of the currently available Linux distributions including Ubuntu, Red Hat Enterprise Linux (RHEL), CentOS, SUSE Linux Enterprise Server (SLES), openSUSE, Debian and Fedora. Similarly, Eucalyptus can use a variety of virtualization technologies including VMware, Xen, and KVM to implement the cloud abstractions it supports.
	
Helpful Links: [[br]]
[http://www.eucalyptus.com/products/overview]  [[br]]
[http://open.eucalyptus.com/wiki/EucalyptusUserGuide_v1.6]  [[br]]
[http://open.eucalyptus.com/wiki/eucalyptus-administrators-guide-16]  [[br]]

# Eucalyptus on Deter
The DETER testbed is a public facility for medium-scale repeatable experiments in computer security. Now Deter can create experiment to run one or multiple Eucalyptus clouds in one experiment. Installation script can help user to create experiment with Eucalyptus automatically. So users can not only create any number of nodes in one Eucalyptus cloud, but also can create any number Eucalyptus cloud in one experiment. Deter is flexible and easy to assign the hardware type and network connection in each private cloud, which is very powerful to run some experiment against multiple cloud.

# Eucalyptus Installation 
1)There are three basic components in one Eucalyptus cloud: Node Controller (node), Front End (ctl) and Eucalyptus Tools(cli).
2 To install Node Contoller (node) :
  * set node1 [$ns node]  * #   to  new a node named node1 *
  * tb-set-node-os $node1 Ubuntu-Xen-904  * #   set up node1 with OS: Ubuntu9.04 with Xen Sever *
  * tb-set-node-startcmd $node1 "bash /proj/Virtual/script/eucalyptus_setup/install_node.sh >& /tmp/node1.log" * #  set up the start command to run node1 node *
2) To install Front End (ctl): 
  * set ctl [$ns node]
  * tb-set-node-os $ctl  Ubuntu904-unsup  * #  set up ctl node with OS: Ubuntu-904 *
  * tb-set-node-startcmd $ctl "bash /proj/Virtual/script/eucalyptus_setup/install_ctl.sh node1 node2 >& /tmp/ctl.log " * #  set up the start command to run ctl node *
  * tb-set-sync-server $ctl * #  set up the ctl as the synchronization server *
3) To install Eucalyptus Tools (cli):
  * set cli [$ns node]
  * tb-set-node-os $cli  Ubuntu904-unsup * #  set up cli node with OS: Ubuntu-904 * 
  * tb-set-node-startcmd $cli "bash /proj/Virtual/script/eucalyptus_setup/install_cli.sh >& /tmp/cli.log" *#   set up the start command to run cli  node * 
4) 
* to example ns script is attached at the end of this page

# Upload Image 
1) Change directory to /proj/Virtual/script/eucalyptus_setup [[br]]
2) Switch user to root. [[br]]
   sudo (all the commands below all assume to be invoked by root user)
3) Upload the os image by the command as the user of eucalyptus: 
   su eucalyptus –c “./upload_image.sh  -i [image name] “[[br]]
   a.the supported image name now are ubuntu9.04; centos5.3; debian5.0; fedora11; [[br]]
   b.if user wants to upload the ubuntu9.04, the command should be: [[br]]
     su eucalyptus –c “./upload.sh  -i ubuntu9.04 “ [[br]]
4) Set up environmental variables by the command: source /var/lib/eucalyptus/euca/eucarc 	
5) check out the status of virtual node by the command: euca-describe-instances
   a.if the status of the node is running instead of pending, it means the node is ready, you can login to this virtual node.[[br]]
   b.login command: ssh -i /var/lib/eucalyptus/euca/mykey.private root@10.1.1.101 (you should change the IP address to the IP of the virtual node. In my case it was 10.1.1.101) [[br]]












