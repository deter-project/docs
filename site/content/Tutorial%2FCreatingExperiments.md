[[TOC]]

#!html
	<p style="text-align: center; background-color: #fcf8e3; font-weight: bold;">
	IMPORTANT: This page is outdated. Please go to the new version of this documentation in the <a href="/wiki/CoreGuide">Core Guide</a>.
	</p>
	

# Designing a Network Topology

Part of DETER's power lies in its ability to assume many different
topologies; the description of a such a topology is a necessary part
of an experiment. (Note: You may want to take a look at our
[Java GUI](https://www.isi.deterlab.net/clientui.php3) to build
experiments without directly editing NS files.)
  
DETER uses the "NS" ("Network Simulator") format to describe network topologies. This is substantially the same [Tcl](http://www.scriptics.com/software/tcltk/)-based format used by [ns-2](http://www.isi.edu/nsnam/ns/). Since DETER offers emulation, rather than simulation, these files are interpreted in a somewhat different manner than ns-2. Therefore, some ns-2 functionality may work differently than you expect, or may not be implemented at all. Please look for warnings of the form: 
	
	  	*** WARNING: Unsupported NS Statement!
	  	    Link type BAZ, using DropTail!
	
If you feel there is useful functionality missing, please let us know. Also, some [wiki:nscommands testbed-specific syntax] has been added, which with the inclusion of compatibility module (tb_compat.tcl), will be ignored by the NS simulator. This allows the same NS file to work on both DETER and ns-2, most of the time.

For those unfamiliar with the NS format, here is a small example (_We urge all new DETER users to begin with a small 3-5 node experiment such as this, so that you will become familiar with NS syntax and the practical aspects of DETER operation_). Let's say we are trying to create a test network which looks like the following:

[[Image(abcd.png)]]
(A is connected to B, and B to C and D with a LAN.)
[[BR]]
An NS file which would describe such a topology is as follows. First off, all NS files start with a simple prologue, declaring a simulator and including a file that allow you to use the special `tb-` commands:
	
	  	# This is a simple ns script. Comments start with #.
	  	set ns [new Simulator]
	        source tb_compat.tcl
	
Then define the 4 nodes in the topology.
	
	  	set nodeA [$ns node]
	  	set nodeB [$ns node]
	  	set nodeC [$ns node]
	  	set nodeD [$ns node]
	
`nodeA` and so on are the virtual names (vnames) of the nodes in your topology. When your experiment is swapped in, they will be assigned to physical node names like "pc45", probably different ones each time. (*NOTE:* It's a bad idea to pick vnames that clash with the physical node names in the testbed.)

Next define the link and the LAN that connect the nodes. NS syntax permits you to specify the bandwidth, latency, and queue type. Note that since NS can't impose artificial losses like DETER can, there is a separate command to add loss on a link. For our example, we will define a full speed LAN between B, C, and D, and a shaped link from node A to B.
	
	  	set link0 [$ns duplex-link $nodeB $nodeA 30Mb 50ms DropTail]
	  	tb-set-link-loss $link0 0.01
	  	set lan0 [$ns make-lan "$nodeD $nodeC $nodeB " 100Mb 0ms]
	
In addition to the standard NS syntax above, a number of [wiki:nscommands extensions] have been added that allow you to better control your experiment.

For example, you may specify what Operating System is booted on your nodes. For the versions of FreeBSD, Linux, and Windows we currently support, please refer to the [wiki:OSImages Operating System Images] page.

Click [List ImageIDs and OSIDs](https://www.isi.deterlab.net/showosid_list.php3) in the DETER web interface "Interaction" pane to see the current list of DETER-supplied OS. By default, our most recent Linux image is selected.
	
	  	tb-set-node-os $nodeA FBSD7-STD
	  	tb-set-node-os $nodeC Ubuntu1004-STD
	  	tb-set-node-os $nodeC WINXP-UPDATE
	
In a topology like this, you will likely want to communicate between all the nodes, including nodes that aren't directly connected, like A and C. In order for that to happen, we must enable routing in our experiment, so B can route packets for the other nodes. The typical way to do this is with Static routing. (Other options are detailed below, in the Routing section below.
	
	  	$ns rtproto Static
	

Lastly, all NS files end with an epilogue that instructs the simulator to start.
	
	 	# Go!
	  	$ns run
	

If you would like to try the above example, the completed [attachment:basic.ns NS file] can be run as an experiment in your project.
Because NS is based on TCL, the full power of the TCL language is available for you to use in your NS files, including loops, control structures, and even procedures/functions. Here's an example of a simple loop: (Download this example: [attachment:loop.ns loop.ns])
	
	  	# This is a simple ns script that demonstrates loops.
	  	set ns [new Simulator]
	  	source tb_compat.tcl
	  	set maxnodes 3
	  	set lanstr ""
	  	for {set i 1} {$i <= $maxnodes} {incr i} {
	  	    set node($i) [$ns node]
	  	    append lanstr "$node($i) "
	  	    tb-set-node-os $node($i) Ubuntu1004-STD
	  	}
	  	# Put all the nodes in a lan
	  	set big-lan [$ns make-lan "$lanstr" 100Mb 0ms]
	  	# Go!
	  	$ns run
	

# Beginning the Experiment

After logging on to the DETER Web Interface, choose the "Begin Experiment" option from the menu. First select which project you want the experiment to be configured in. Most people will be a member of just one project, and will not have a choice. If you are a member of multiple projects, be sure to select the correct project from the menu.
Next fill in the `Name' and `Description' fields. The Name should be a single word (no spaces) identifier, while the Description is a multi word description of your experiment. In the "Your NS file" field, place the _local path_ of an NS file which you have created to describe your network topology. This file will be uploaded through your browser when you choose "Submit."

After submission, DETER will begin processing your request. This will likely take several minutes, depending on how large your topology is, and what other features (such as delay nodes and bandwidth limits) you are using. Assuming all goes well, you will receive an email message indicating success or failure, and if successful, a listing of the nodes and IP address that were allocated to your experiment.
For the NS file described above, you would receive a listing that looks similar to this:

	
	Experiment: DeterTest/basic-experiment
	State: swapped
	
	Virtual Node Info:
	ID              Type         OS              Qualified Name
	--------------- ------------ --------------- --------------------
	nodeA           pc           FBSD7-STD       nodeA.basic-experiment.DeterTest.isi.deterlab.net
	nodeB           pc                           nodeB.basic-experiment.DeterTest.isi.deterlab.net
	nodeC           pc           Ubuntu1004-STD  nodeC.basic-experiment.DeterTest.isi.deterlab.net
	nodeD           pc                           nodeD.basic-experiment.DeterTest.isi.deterlab.net
	
	Virtual Lan/Link Info:
	ID              Member/Proto    IP/Mask         Delay     BW (Kbs)  Loss Rate
	--------------- --------------- --------------- --------- --------- ---------
	lan0            nodeB:1         10.1.2.4        0.00      100000    0.00000000
	                ethernet        255.255.255.0   0.00      100000    0.00000000
	lan0            nodeC:0         10.1.2.3        0.00      100000    0.00000000
	                ethernet        255.255.255.0   0.00      100000    0.00000000
	lan0            nodeD:0         10.1.2.2        0.00      100000    0.00000000
	                ethernet        255.255.255.0   0.00      100000    0.00000000
	link0           nodeA:0         10.1.1.3        25.00     30000     0.00501256
	                ethernet        255.255.255.0   25.00     30000     0.00501256
	link0           nodeB:0         10.1.1.2        25.00     30000     0.00501256
	                ethernet        255.255.255.0   25.00     30000     0.00501256
	
	Virtual Queue Info:
	ID              Member          Q Limit    Type    weight/min_th/max_th/linterm
	--------------- --------------- ---------- ------- ----------------------------
	lan0            nodeB:1         100 slots  Tail    0/0/0/0
	lan0            nodeC:0         100 slots  Tail    0/0/0/0
	lan0            nodeD:0         100 slots  Tail    0/0/0/0
	link0           nodeA:0         100 slots  Tail    0/0/0/0
	link0           nodeB:0         100 slots  Tail    0/0/0/0
	
	Event Groups:
	Group Name      Members
	--------------- ---------------------------------------------------------------
	link0-tracemon  link0-nodeB-tracemon,link0-nodeA-tracemon
	__all_lans      lan0,link0
	__all_tracemon  link0-nodeB-tracemon,link0-nodeA-tracemon,lan0-nodeD-tracemon,lan0-nodeC-tracemon,lan0-nodeB-tracemon
	lan0-tracemon   lan0-nodeB-tracemon,lan0-nodeC-tracemon,lan0-nodeD-tracemon
	

A few points should be noted:
    * A single delay node was allocated and inserted into the link between nodeA and nodeB. This link is invisible from your perspective, except for the fact that it adds latency, error, or reduced bandwidth. However, the information for the delay links are included so that you can modify the delay parameters after the experiment has been created (Note that you cannot convert a non shaped link into a shaped link; you can only modify the traffic shaping parameters of a link that is already being shaped). [[BR]]
    * Delays of less than 2ms (per trip) are too small to be accurately modeled at this time, and will be silently ignored. A delay of 0ms can be used to indicate that you do not want added delay; the two interfaces will be "directly" connected to each other. [[BR]]
    *  To modify the parameters, go to the Experiment Information page of your experiment, and click on the "Modify Traffic Shaping" menu option. Follow the instructions at the top of the page.  An alternative method is to log into users.isi.deterlab.net and use the *delay_config* program. This program requires that you know the symbolic names of the individual links. This information is available via the web interface on the Experiment Information page. 
    * Each link in the "Virtual !Lan/Link" section has its delay, etc., split between two entries. One is for traffic coming into the link from the node, and the other is for traffic leaving the link to the node. In the case of links, the four entries often get optimized to two entries in the "Physical !Lan/Link" section. [[BR]]
    * The names in the "Qualified Name" column refer to the control network interfaces for each of your allocated nodes. These names are added to the DETER nameserver map on the fly, and are immediately available for you to use so that you do not have to worry about the actual physical node names that were chosen. In the names listed above, `myproj' is the name of the project that you chose to work in, and `myexp' is the name of the experiment that you provided in the "Begin an Experiment" page. [[BR]]
    * Please don't use the "Qualified Name" from within nodes in your experiment, since it will contact them over the control network, bypassing the link shaping we configured.

# I've finished my experiment

When your experiment is completed, and you no longer need the resources that have been allocated to it, you will need to terminate the experiment via the DETER Web Interface. Click on the "End An Experiment" link. You will be presented with a list of all of the experiments in all of the projects for which you have the authorization to terminate experiments. Select the experiment you want to terminate by clicking on the button in the "Terminate" column on the right hand side. You will be asked to *confirm* your choice. The DETER configuration system will then tear down your experiment, and send you an email message when the process is complete. At this point you are allowed to reuse the experiment name (say, if you wanted to create a similar experiment with different parameters).

# Scheduling experiment swapout/termination #Halting

If you expect that your experiment should run for a set period of time, but you will not be around to terminate or swap the experiment out, then you should use the scheduled swapout/termination feature. This allows you to specify a maximum running time in your NS file so that you will not hold scarce resources when you are offline. To schedule a swapout or termination in your NS file:
	
	     $ns at 2000.0 "$ns terminate"
	   or
	     $ns at 2000.0 "$ns swapout"
	

This will cause your experiment to either be terminated or swapped out after 2000 seconds of wallclock time.


# Installing RPMS automatically
The DETER NS extension `tb-set-node-rpms` allows you to specify a (space separated) list of RPMs to install on each of your nodes when it boots:
	
	  tb-set-node-rpms $nodeA /proj/myproj/rpms/silly-freebsd.rpm
	  tb-set-node-rpms $nodeB /proj/myproj/rpms/silly-linux.rpm
	  tb-set-node-rpms $nodeC /proj/myproj/rpms/silly-windows.rpm
	
The above NS code says to install the `silly-freebsd.rpm` file on `nodeA`, the `silly-linux.rpm` on `nodeB`, and the `silly-windows.rpm` on `nodeC`. RPMs are installed as root, and must reside in either the project's `/proj` directory, or if the experiment has been created in a subgroup, in the `/groups` directory. You may not place your rpms in your home directory.
   
# Installing TAR files automatically

The DETER NS extension [wiki:nscommands#tb-set-node-tarfiles `tb-set-node-tarfiles`] allows you to specify a set of tarfiles to install on each of your nodes when it boots. While similar to the [wiki:nscommands#tb-set-node-rpms `tb-set-node-rpms`] command, the format of this command is slightly different in that you must specify a directory in which to unpack the tar file. This avoids problems with having to specify absolute pathnames in your tarfile, which many modern tar programs balk at.
	
	  tb-set-node-tarfiles $nodeA /usr/site /proj/myproj/tarfiles/silly.tar.gz
	
The above NS code says to install the `silly.tar.gz` tar file on `nodeA` from the working directory `/usr/site` when the node first boots. The tarfile must reside in either the project's `/proj` directory, or if the experiment has been created in a subgroup, in the `/groups` directory. You may not place your tarfiles in your home directory. You may specify as many tarfiles as you wish, as long as each one is preceded by the directory it should be unpacked in, all separated by spaces.
   
# Starting your application automatically

You can start your application automatically when your nodes boot for the first time (experiment is started or swapped in) by using the `tb-set-node-startcmd` NS extension. The argument is a command string (pathname of a script or program, plus arguments) that is run as the `UID` of the experiment creator, after the node has reached multiuser mode. The command is invoked using `/bin/csh`, and the working directory is undefined (your script should cd to the directory you need). You can specify the same program for each node, or a different program. For example:
	
	  tb-set-node-startcmd $nodeA "/proj/myproj/runme.nodeA"
	  tb-set-node-startcmd $nodeB "/proj/myproj/runme.nodeB"
	
will run `/proj/myproj/runme.nodeA` on nodeA and `/proj/myproj/runme.nodeB` on nodeB. The programs must reside on the node's local filesystem, or in a directory that can be reached via NFS. This is either the project's `/proj` directory, in the `/groups` directory if the experiment has been created in a subgroup, or a project member's home directory in `/users`. If you need to see the output of your command, be sure to redirect the output into a file. You can place the file on the local node, or in one of the NFS mounted directories mentioned above. For example:
	
	     tb-set-node-startcmd $nodeB "/proj/myproj/runme >& /tmp/foo.log"
	
Note that the syntax and function of `/bin/csh` differs from other shells (including bash), specifically in redirection syntax.  Be sure to use csh syntax or your start command will fail silently.

The exit value of the start command is reported back to the Web Interface, and is made available to you via the "Experiment Information" link. There is a listing for all of the nodes in the experiment, and the exit value is recorded in this listing. The special symbol `none` indicates that the node is still running the start command.
The start command is implemented using [wiki:Tutorial/Advanced#ProgramObjects  Program Objects], which are described in more detail in the [wiki:Tutorial/Advanced  Advanced Tutorial.] Note that the start command is run only when the experiment is swapped in. If you want to rerun the experiment, you can swap the experiment out and back in, or you can reboot all of the nodes in your experiment. If rebooting, you must fire off the program object(s) yourself by restarting the [wiki:Tutorial/Advanced Event System] on `users.isi.deterlab.net`:
	
	  	eventsys_control <proj> <expt> replay
	
You can also control each program object by sending it events, either with the NS "at" command:
	
	    $ns at 2000.0 "$nodeA_startcmd stop"
	    $ns at 2010.0 "$nodeA_startcmd start"
	
or you can use the event program on `users.isi.deterlab.net`
	
	    tevc -e myproj/myexpt now nodeA_startcmd stop
	    tevc -e myproj/myexpt now nodeA_startcmd start
	
   
# How do I know when all my nodes are ready?

It is often necessary for your start program to determine when all of the other nodes in the experiment have started, and are ready to proceed. Sometimes called a _barrier_, this allows programs to wait at a specific point, and then all proceed at once. DETER provides a simple form of this mechanism using a synchronization server that runs on a node of your choice. You specify the node in your NS file:
	
	    tb-set-sync-server $nodeB
	
When nodeB boots, the synchronization server will automatically start. Your software can then synchronize using the `emulab-sync` program that is installed on your nodes. For example, your node start command might look like this:
	
	   #!/bin/sh
	   if [ "$1" = "master" ]; then
	       /usr/testbed/bin/emulab-sync -i 4
	   else
	       /usr/testbed/bin/emulab-sync fi /usr/site/bin/dosilly
	
In this example, there are five nodes in the experiment, one of which must be configured to operate as the master, initializing the barrier to the number of clients (four in the above example) that are expected to rendezvous at the barrier. The master will by default wait for all of the clients to reach the barrier. Each client of the barrier also waits until all of the clients have reached the barrier (and of course, until the master initializes the barrier to the proper count). Any number of clients may be specified (any subset of nodes in your experiment can wait). If the master does not need to wait for the clients, you may use the _async_ option which releases the master immediately:
	
	    /usr/testbed/bin/emulab-sync -a -i 4
	
You may also specify the _name_ of the barrier.
	
	    /usr/testbed/bin/emulab-sync -a -i 4 -n mybarrier /usr/testbed/bin/emulab-sync -n mybarrier
	
This allows multiple barriers to be in use at the same time. Scripts on nodeA and nodeB can be waiting on a barrier named "foo" while (other) scripts on nodeA and nodeC can be waiting on a barrier named "bar." You may reuse an existing barrier (including the default barrier) once it has been released (all clients arrived and woken up).
   
As DETER strives to make all aspects of the network controllable by the user, we do not attempt to impose any IP routing architecture or protocol by default. However, many users are more interested in end-to-end aspects and don't want to be bothered with setting up routes. For those users we provide an option to automatically set up routes on nodes which run one of our provided FreeBSD, Linux or [wiki:Windows  Windows XP] disk images.
You can use the NS `rtproto` syntax in your NS file to enable routing:

	
	    $ns rtproto _protocol_
	

where the _protocol_ option is limited to one of `Session`, `Static`, `Static-old`, or `Manual`.

`Session` routing provides fully automated routing support, and is implemented by enabling `gated` running the OSPF protocol on all nodes in the experiment. This is not supported on [wiki:Windows#Routing Windows XP] nodes.
`Static` routing also provides automatic routing support, but rather than computing the routes dynamically, the routes are precomputed by a distributed route computation algorithm running in parallel on the experiment nodes.
`Static-old` specifies use of the older centralized route computation algorithm, precomputing the nodes when the experiment is created, and then loading them onto each node when it boots.
`Manual` routing allows you to explicitly specify per-node routing information in the NS file. To do this, use the `Manual` routing option to `rtproto`, followed by a list of routes using the `add-route` command:
	
	    $node add-route $dst $nexthop
	
where the `dst` can be either a node, a link, or a LAN. For example:
	
	    $client add-route $server $router
	    $client add-route [$ns link $server $router] $router
	    $client add-route $serverlan $router
	
Note that you would need a separate `add-route` command to establish a route for the reverse direction; thus allowing you to specify differing forward and reverse routes if so desired. These statements are converted into appropriate `route(8)` commands on your experimental nodes when they boot.
In the above examples, the first form says to set up a manual route between `$client` and `$server`, using `$router` as the nexthop; `$client` and `$router` should be directly connected, and the interface on `$server` should be unambiguous; either directly connected to the router, or an edge node that has just a single interface.

[[Image(routing.png)]]

If the destination has multiple interfaces configured, and it is not connected directly to the nexthop, the interface that you are intending to route to is ambiguous. In the topology shown to the right, `$nodeD` has two interfaces configured. If you attempted to set up a route like this:
	
	    $nodeA add-route $nodeD $nodeB
	
you would receive an error since it cannot be determined (easily, with little programmer effort, by DETER staff!) which of the two links on `$nodeD` you are referring to. Fortunately, there is an easy solution, courtesy of an Emulab extension. Instead of a node, specify the link directly:
	
	    $nodeA add-route [$ns link $nodeD $nodeC] $nodeB
	
This tells us exactly which link you mean, enabling us to convert that information into a proper `route` command on `$nodeA`.
The last form of `add-route` command is used when adding a route to an entire LAN. It would be tedious and error prone to specify a route to each node in a LAN by hand. Instead, just route to the entire network:
	
	    set clientlan [$ns make-lan "$nodeE $nodeF $nodeG" 100Mb 0ms]
	    $nodeA add-route $clientlan $nodeB
	
While all this manual routing infrastructure sounds really nifty, its probably a good idea to use either `Session` or `Static` routing for all but small, simple topologies. Explicitly setting up all the routes in even a moderately-sized experiment is extremely error prone. Consider this: a recently created experiment with 17 nodes and 10 subnets required 140 hand-created routes in the NS file. Yow!
Two final, cautionary notes on routing:
    * You might be tempted to set the default route on your nodes to reduce the number of explicit routes used. *Don't do it.* That would prevent nodes from contacting the outside world, i.e., you. The default route _must_ be set to use the control network interface.
    * If you use your own routing daemon, you must avoid using the control network interface in the configuration. Since every node in the testbed is directly connected to the control network LAN, a naive routing daemon configuration will discover that any node is just one hop away, via the control network, from any other node and _all_ inter-node traffic will be routed via that interface.
