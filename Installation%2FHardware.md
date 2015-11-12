# DETER Recommended Hardware

We have a some recommended hardware for setting up DETER.  We can't hand you a shopping list, but here are the things that we use and like.  The four keys to success are: 

* Use HP switches unless you have a real need to use something else and a have a bored developer.
* Choose hardware that is simple and well supported under FreeBSD 8.3.
* Understand that DETER is about handing you physical nodes with physical networking.  Buy a bunch of cheap nodes instead of a few expensive nodes.  Given the way CPU prices scale you'll probably come out with more overall compute power anyway.
* Consider the cost of people in addition to the cost of hardware.  Successfully setting up a DETER requires more than just hardware.

## Nodes

DETER is a network testbed.  This means our nodes are different than your typical computing cluster and presents a little bit of an optimization problem based on budget.  If you have a fixed budget you should select your nodes as follows:

### Overall goal when purchasing nodes with a fixed budget

You want to maximize the number of nodes in your testbed.  The more independent nodes you have, the more resilient your testbed will be.  If you have 20 nodes and 1 fails, you have lost 5% of your testbed capacity.  If you only have 4 high end nodes and one fails, you have lost 25%.  Experimental allocation is done at the node level, so more nodes means finer grained allocation if multiple researchers are making use of your testbed.  More nodes gives you the flexibility to duplicate experiments.  When we do major demos at DETER, we sometimes swap in a duplicate of an experiment so we have a hot spare should a problem with the main demo experiment arise.

### The four key parts of a testbed node

DETER is a network testbed, not a compute cluster.  We have found that people need to counter some of their instincts when selecting testbed nodes.  What every testbed node needs to emphasize are:

* Network Connectivity.  Each node should have 6 Ethernet ports.
* RAM in proportion of CPU cores
* CPU with full virtualization support
* IPMI control

Here are some features that are not terribly important for testbed nodes:

* RAID controllers and high capacity storage.  Large, redundant storage should be centralized.
* High end CPUs.  This is because we have to optimize for the maximum number of nodes in a fixed budget.
* Redundant Power Supplies.  If you have more nodes and centralized storage, you can wait to get a power supply in the mail.
* Generally exotic hardware design (blade centers, etc).  These typically emphasize computer power per node which is not our goal.

### Budget, High Node Count, and Selecting Nodes

As an example, in DETER's most recent build-out, I managed to add 128 nodes with a budget of around $300k (including switches).  I also had to factor in power and weight constraints that are unique to the DETER server room.  Here is what I came up with:

* I used SuperMicro Microcloud servers.  These 3u servers contain 8 independent nodes.  They are simple Intel C20x based motherboards with two onboard NICs, an IPMI port, and a PCI-E slot.  They allowed me to fix 64 nodes per rack.
* For CPUs I used Xeon E3-1260L processors to keep our power consumption and heat output low.
* I was able to install 16GB of RAM per node.  I use unbuffered ECC RAM because DIMMs do go bad if you a large enough population.
* For hard drives, I picked the least expensive Western Digital RE edition hard drive.  I basically exchanged capacity for a more reliable drive with a 5 year warranty.  Drives were ~$80 each for 250GB of capacity.
* A quad port Intel I350 NIC per node.  This means each node has 5 dedicated experimental interfaces and 1 control interface.
* HP 5400 series switches.  I ended up using 4 5412zl switches for the experimental network and 2 5406zl switches for the control network.
 
Areas where I could have reduced cost on this installation:

* Used separate commodity switches for the IPMI ports.  The IPMI ports don't technically need to be connected to a managed switch.  Personally, I did save a lot of time by using the advanced features of the HP switches to map the 128 IPMI mac addresses to nodes (I used a known wiring pattern).
* Use Pentium G low power CPUs.  The Xeon E3 CPUs were about $300 when I did the build.  I could have saved $200 per node by selecting specific sub-$100 Pentium CPUs which work well with the C20x chipset and include support for ECC Ram.
* Less RAM.  ECC Unbuffered RAM is still somewhat expensive.  Going with 8GB or 4GB per node would have saved ~$150-$100 per node.

Areas where I wouldn't want to save money:

* Configuring a node with a dual port card instead of a quad port card could save some money.  Also, not buying Intel could save some money, but the Intel cards support advanced virtualization features and generally have very good driver support.
* Using something other than HP switches.  The HP switches come with free support and firmware updates.  They also come with a lifetime hardware warranty.  They are the only switch type currently in use at DETER and therefore will be the best supported switch.


## Network Switches

The DETER software stack dynamically sets up real VLANs on switches.  There are also two networks in a typical DETER/Emulab install.  The control network is where testbed nodes network boot and mount filesystems over.  The experimental network is where experimental topologies are instantiated.  These networks may be separated or coexists on the same switch.  It depends on how big your testbed is and if you mind control/fileserver traffic going over the same switch trunks with experimental data.  For small installs, a single switch is fine.

Although you may be tempted to borrow an engineering sample PacketMasher 9000 from that cool startup your friend works at in Silicon Valley, it is important that you choose a switch that has software support.  Adding support for new switches is possible, but non-trivial.  Right now, we recommend HP 5400zl series switches.  The number of ports depends on how many nodes you want to support.  At DETER, we typically have at least five interfaces per testbed node.

[HP 5400zl Series overview](http://h17007.www1.hp.com/us/en/products/switches/HP_5400_zl_Switch_Series/index.aspx)

For really small installations, we have had good luck with HP 2810 switches:

[HP 2810 overview](http://h17007.www1.hp.com/us/en/products/switches/HP_2810_Switch_Series/index.aspx)


## Infrastructure Machines

There are three main machines in a DETER/Emulab installation.  These are boss, users, and router.  Boss hosts the database, web interface, and main logic.  Users acts as the NFS/SMB server and user login machine.  All these machines run FreeBSD 9.1.

These machines do not need to be very high powered if your budget is limited.  We have successfully deployed all three machines on a single PowerEdge 860 with 4GB of ram running VMWare ESXi.  How much of a box your provision is really up to what your site requirements are.

## Testbed nodes

The Emulab software stack that powers DETER predates the 'Cloud' buzzword by about a decade.  Although we support a virtualization overlay through [DETER Containers](http://containers.deterlab.net), we are really about handing researchers physical machines and physical networks.  At DETER we tend to purchase low end, single CPU server class machines.  Things like advanced remote management, redundant power supplies, and over engineered hardware are best left to the infrastructure machines described above.  If you have a choice between doing 16 entry level machines or 4 over powered nodes, we currently recommend going for quantity.

What you provision here is really up to you.  All of the machines we are using at DETER are no longer in production, so we can not recommend specific models.  
* The machines must be able to PXE boot.
* The machines need to be capable of running FreeBSD 8.3.  Watch out for fancy RAID controllers or strange network cards.  Standard SATA drives and Intel NICs are what we use.
* You should ideally have about 5 Gbe network interfaces on each node.  One interface for the control network and four for the experimental network.

For our most recent buildout, we used [SuperMicro MicroCloud](http://www.supermicro.com/products/system/3U/5037/SYS-5037MC-H8TRF.cfm) machines.  We get 8 Xeon E3 servers in 3u of rack space and control them via IPMI.

Aside from these basic requirements, the testbed nodes depend on what you intend to do.

Our standard operating system images include Ubuntu 12.04, CentOS 6, and FreeBSD 9. 


## Power and Serial Controllers

DETER gives researchers full control over their machines.  Having physical control over the power state of the machine is important to recovering from kernel panics, misconfigured machines, or if the PXE boot process goes wrong (remember that DHCP and TFTP are not the most resilient protocols).  The testbed software will attempt to reboot a node via SSH, a special "Ping of Death" packet, and finally by physically turning the machine on and off if it is still unresponsive.

Serial consoles are logged and provide important diagnostic information.  They also allow access to nodes with misconfigured networks and enable kernel debugging.  

Historically, we have used real power controllers and serial concentrators rather than IPMI, but moving forward we hope to use IPMI in place of both.   So far we have been successful using the SuperMicro Nuvoton WPCM450RA0BX found on their MicroCloud systems.  Adding support for other IPMI controllers should not be too bad if they can be made to work with open source IPMI tools that compile on FreeBSD.

For physical power controllers, we are using APC 7902 rack PDUs.

[APC 7902 Rack PDU](http://www.apc.com/resource/include/techspec_index.cfm?base_sku=AP7902)

For physical serial controllers, we are using Digi Etherlite models.

[DIGI Etherlite network serial concentrators](http://www.digi.com/products/serialservers/etherlite.jsp#overview) 