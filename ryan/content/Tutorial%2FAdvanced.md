[[TOC]]

#!html
	<p style="text-align: center; background-color: #fcf8e3; font-weight: bold;">
	IMPORTANT: This page is outdated. Please go to the new version of this documentation in the <a href="/wiki/CoreGuide">Core Guide</a>.
	</p>
	

This tutorial is taken from the Emulab Advanced Tutorial.  Minor edits have been included to account for differences between Emulab and DETER.  The original file is at [Emulab Advanced Example](https://users.emulab.net/trac/emulab/wiki/AdvancedExample).
Here is a slightly more complex example demonstrating the use of RED queues, traffic generation, and the event system. Where possible, we adhere to the syntax and operational model of [ns-2](http://www.isi.edu/nsnam/ns/), as described in the [NS manual](http://www.isi.edu/nsnam/ns/doc/index.html).

  * *RED/GRED Queues*: In addition to normal DropTail links, DETER supports the specification of the RED and GRED (Gentle RED) links in your NS file. RED/GRED queuing is handled via the insertion of a traffic shaping delay node, in much the same way that bandwidth, delay, and packet loss is handled. For a better understanding of how we support traffic shaping, see the `ipfw` and `dummynet` man pages on `users.isi.deterlab.net`. It is important to note that DETER supports a smaller set of tunable parameters then NS does; please read the aforementioned manual pages!
  * *Traffic Generation*: DETER supports Constant Bit Rate (CBR) traffic generation, in conjunction with either Agent/UDP or Agent/TCP agents. We currently use the [TG Tool Set](http://www.postel.org/tg) to generate traffic.
  * *Event System*: DETER supports limited use of the NS _at_ syntax, allowing you to define a static set of events in your NS file, to be delivered to agents running on your nodes. There is also "dynamic events" support that can be used to inject events into the system on the fly, say from a script running on `users.isi.deterlab.net`.
  * *Program Objects*: DETER has added extensions that allow you to run arbitrary programs on your nodes, starting and stopping them at any point during your experiment run.
  * *Link Tracing and Monitoring*: DETER supports simplified [#Tracing tracing and monitoring] of links and lans.

What follows is an [attachment:advanced.ns sample NS file] that demonstrates the above features, with annotations where appropriate. First we define the 2 nodes in the topology:
	
		set nodeA [$ns node]
		set nodeB [$ns node]
	

Next define a duplex link between nodes nodeA and nodeB. Instead of a standard DropTail link, it is declared to be a Random Early Detection (RED) link. While this is obviously contrived, it allows us to ignore [wiki:Tutorial#Routing routing] issues within this example.
	
		set link0 [$ns duplex-link $nodeA $nodeB 100Mb 0ms RED]
	

Each link is has an NS "Queue" object associated with it, which you can modify to suit your needs (_currently, there are two queue objects per duplex link; one for each direction. You need to set the parameters for both directions, which means you can set the parameters asymmetrically if you want_). Accessing the duplex links queue objects is done by accessing the `fromqueue` and `toqueue` instance members.  Example code for that is below. The following parameters can be changed, and are defined in the NS manual (see Section 7.3).

	
		set queue0 [[$ns link $nodeA $nodeB] queue]
	
	        # Get access to a duplex link's queue
	        set link0 [$ns duplex-link $nodeA $nodeB 500Mb 0ms DropTail]
	        set q0 [$link0 set fromqueue]
	
	        # Modifying the duplex link's parameters would use $q0 as the example below uses $queue0
	
		$queue0 set gentle_ 0
		$queue0 set red_ 0
		$queue0 set queue-in-bytes_ 0
		$queue0 set limit_ 50
		$queue0 set maxthresh_ 15
		$queue0 set thresh_ 5
		$queue0 set linterm_ 10
		$queue0 set q_weight_ 0.002
	
_The maximum `limit_` for a queue is *1 megabyte''' if it is specified in bytes, or '''100 slots* if it is specified in slots (each slot is 1500 bytes)._

In the case of a LAN, there is a single queue object for every node that is a member of the LAN and it refers to the node-to-lan direction. The only special case is a 100Mb 0ms LAN that does *not* use [wiki:linkdelays end node shaping]. No queue object is available in that case. Here is an example that illustrates how to get handles on the queue objects of a LAN so as to change the parameters:
	
		set n0 [$ns node]
		set n1 [$ns node]
		set n2 [$ns node]
	
		set lan0 [$ns make-lan "$n0 $n1 $n2" 100Mb 0ms]
	
		set q0 [[$ns lanlink $lan0 $n0] queue]
		set q1 [[$ns lanlink $lan0 $n1] queue]
		set q2 [[$ns lanlink $lan0 $n2] queue]
	
		$q0 set limit_ 20
		...
	

A UDP agent is created and attached to nodeA, then a CBR traffic generator application is created, and attached to the UDP agent:
	
		set udp0 [new Agent/UDP]
		$ns attach-agent $nodeA $udp0
	
		set cbr0 [new Application/Traffic/CBR]
		$cbr0 set packetSize_ 500
		$cbr0 set interval_ 0.005
		$cbr0 attach-agent $udp0
	

A TCP agent is created and also attached to nodeA, then a second CBR traffic generator application is created, and attached to the TCP agent:
	
		set tcp0 [new Agent/TCP]
		$ns attach-agent $nodeA $tcp0
	
		set cbr1 [new Application/Traffic/CBR]
		$cbr1 set packetSize_ 500
		$cbr1 set interval_ 0.005
		$cbr1 attach-agent $tcp0
	

You must define traffic sinks for each of the traffic generators created above. The sinks are attached to nodeB:
	
		set null0 [new Agent/Null]
		$ns attach-agent $nodeB $null0
	
		set null1 [new Agent/TCPSink]
		$ns attach-agent $nodeB $null1
	

Then you must connect the traffic generators on nodeA to the traffic sinks on nodeB:
	
		$ns connect $udp0 $null0
		$ns connect $tcp0 $null1
	

Lastly, a set of events to control your applications and link characteristics:
	
	
		$ns at 60.0  "$cbr0  start"
		$ns at 70.0  "$link0 bandwidth 10Mb duplex"
		$ns at 80.0  "$link0 delay 10ms"
		$ns at 90.0  "$link0 plr 0.05"
		$ns at 100.0 "$link0 down"
		$ns at 110.0 "$link0 up"
		$ns at 115.0 "$cbr0  stop"
	
		$ns at 120.0 "$cbr1  start"
		$ns at 130.0 "$cbr1  set packetSize_ 512"
		$ns at 130.0 "$cbr1  set interval_ 0.01"
		$ns at 140.0 "$link0 down"
		$ns at 150.0 "$cbr1  stop"
	

When you receive email containing the experiment setup information (as described in [wiki:Tutorial Beginning an Experiment]), you will notice an additional section that gives a summary of the events that will be delivered during your experiment: 
	
	Event Summary:
	--------------
	Event count: 18
	First event: 60.000 seconds
	Last event: 160.000 seconds
	

You can get a full listing of the events for your experiment by checking the 'Details' pane on the 'Show Experiment' page for your experiment. This report will include a section like this:
	
	Event List:
	Time         Node         Agent      Type       Event      Arguments
	------------ ------------ ---------- ---------- ---------- ------------
	60.000       nodeA        cbr0       TRAFGEN    START      PACKETSIZE=500
	                                                           RATE=100000
	                                                           INTERVAL=0.005
	70.000       tbsdelay0    link0      LINK       MODIFY     BANDWIDTH=10000
	80.000       tbsdelay0    link0      LINK       MODIFY     DELAY=10ms
	90.000       tbsdelay0    link0      LINK       MODIFY     PLR=0.05
	100.000      tbsdelay0    link0      LINK       DOWN
	110.000      tbsdelay0    link0      LINK       UP
	115.000      nodeA        cbr0       TRAFGEN    STOP
	120.000      nodeA        cbr1       TRAFGEN    START      PACKETSIZE=500
	                                                           RATE=100000
	                                                           INTERVAL=0.005
	130.000      nodeA        cbr1       TRAFGEN    MODIFY     PACKETSIZE=512
	130.000      nodeA        cbr1       TRAFGEN    MODIFY     INTERVAL=0.01
	140.000      tbsdelay0    link0      LINK       DOWN
	150.000      tbsdelay0    link0      LINK       UP
	160.000      nodeA        cbr1       TRAFGEN    STOP
	

The above list represents the set of events for your experiments, and are stored in the DETER Database. When your experiment is swapped in, an _event scheduler_ is started that will process the list, and send them at the time offset specified. In order to make sure that all of the nodes are actually rebooted and ready, time does not start ticking until all of the nodes have reported to the event system that they are ready. At present, events are restricted to system level agents (DETER traffic generators and delay nodes), but in the future we expect to provide an API that will allow experimenters to write their own event agents.


# Dynamic Scheduling of Events #DynamicEvents

NS scripts give you the ability to schedule events dynamically; an NS script is just a TCL program and the argument to the "at" command is any valid TCL expression. This gives you great flexibility in a simulated world, but alas, this cannot be supported in a practical manner in the real world. Instead, we provide a way for you to inject events into the system dynamically, but leave it up to you to script those events in whatever manner you are most comfortable with, be it a PERL script, or a shell script, or even another TCL script! Dynamic event injection is accomplished via the _Testbed Event Client_ (tevc), which is installed on your experimental nodes and on `users.isi.deterlab.net`. The command line syntax for `tevc` is:
	
		tevc -e proj/expt time objname event [args ...]
	

where the `time` parameter is one of:

  * now
  * +seconds (floating point or integer)
  * [[[[yy]mm]dd]HH]MMss

For example, you could issue this sequence of events.
	
		tevc -e testbed/myexp now cbr0 set interval_=0.2
		tevc -e testbed/myexp +10 cbr0 start
		tevc -e testbed/myexp +15 link0 down
		tevc -e testbed/myexp +17 link0 up
		tevc -e testbed/myexp +20 cbr0 stop
	

Some points worth mentioning:

  * There is no "global" clock; DETER nodes are kept in sync with NTP, which does a very good job of keeping all of the clocks within 1ms of each other.
  * The times "now" and "+seconds" are relative to the time at which each event is submitted, not to each other or the start of the experiment.
  * The set of events you can send is currently limited to control of traffic generators and delay nodes. We expect to add more agents in the future.
  * Sending dynamic events that intermix with statically scheduled events can result in unpredictable behavior if you are not careful.
  * Currently, the event list is replayed each time the experiment is swapped in. This is almost certainly not the behavior people expect; we plan to change that very soon.
  * `tevc` does not provide any feedback; if you specify an object (say, cbr78 or link45) that is not a valid object in your experiment, the event is silently thrown away. Further, if you specify an operation or parameter that is not appropriate (say, "link0 start" instead of "link0 up"), the event is silently dropped. We expect to add error feedback in the future.

# Supported Events

This is a (mostly) comprehensive list of events that you can specify, either in your NS file or as a dynamic event on the command line. In the listings below, the use of "link0", "cbr0", etc. are included to clarify the syntax; the actual object names will depend on your NS file. Also note that when sending events from the command line with `tevc`, you should not include the dollar ($) sign. For example:

|| NS File: || `$ns at 3.0 "$link0 down"` ||
|| tevc: || `tevc -e proj/expt +3.0 link0 down` ||

  * Links:
	
	     In "ns" script:
	       $link0 bandwidth 10Mb duplex
	       $link0 delay 10ms
	       $link0 plr 0.05
	     With "tevc":
	       tevc ... link0 modify bandwidth=20000	# In kbits/second; 20000 = 20Mbps
	       tevc ... link0 modify delay=10ms		# In msecs (the "ms" is ignoredd)
	       tevc ... link0 modify plr=0.1
	     Both:
	       $link0 up
	       $link0 down
	
  * Queues: Queues are special. In your NS file you modify the actual queue, while on the command line you use the link to which the queue belongs.
	
	       $queue0 set queue-in-bytes_ 0
	       $queue0 set limit_ 75
	       $queue0 set maxthresh_ 20
	       $queue0 set thresh_ 7
	       $queue0 set linterm_ 11
	       $queue0 set q_weight_ 0.004
	
  * CBR: interval_ and rate_ are two way of specifying the same thing. iptos_ allows you to set the IP_TOS socket option for a traffic stream.
	
	       $cbr0 start
	       $cbr0 set packetSize_ 512
	       $cbr0 set interval_ 0.01
	       $cbr0 set rate_ 10Mb
	       $cbr0 set iptos_ 16
	       $cbr0 stop
	

# Event Groups
Event Groups allow you to conveniently send events to groups of like objects. For example, if you want to bring down a set of links at the same time, you could do it one event at a time:
	
		$ns at 100.0 "$link0 down"
		$ns at 100.0 "$link1 down"
		$ns at 100.0 "$link2 down"
		$ns at 100.0 "$link3 down"
	

which works, but is somewhat verbose. Its also presents a problem when sending dynamic events with `tevc` from the shell:
	
		tevc -e proj/expt now link0 down
		tevc -e proj/expt now link1 down
		tevc -e proj/expt now link2 down
		tevc -e proj/expt now link3 down
	

These four events will be separated by many milliseconds as each call to tevc requires forking a command from the shell, contacting boss, sending the event to the event scheduler, etc. [[BR]][[BR]] A better alternative is to create an _event group_, which will schedule events for all of the members of the group, sending them at the same time from the event scheduler. The example above can be more simply implemented as:
	
		set mylinks [new EventGroup $ns]
		$mylinks add $link0 $link1 $link2 $link3
	
		$ns at 60.0 "$mylinks down"
	

From the command line:
	
		tevc -e proj/expt now mylinks down
	

Note:

  * All of the members of an event group must be of the same type; you cannot, say, put a link and a program object into the same event group since they respond to entirely different commands. The parser will reject such groups.
  * An object (such as a link or lan) can be in multiple event groups.
  * Event groups are not hierarchical; you cannot put one event group into another event group. If you need this functionality, then you need to put the objects themselves (such as a link or lan) into each event group directly:
	
	       set mylinks1 [new EventGroup $ns]
	       set mylinks2 [new EventGroup $ns]
	       $mylinks1 add $link0 $link1 $link2 $link3
	       $mylinks2 add $link0 $link1 $link2 $link3
	

# Program Objects

We have added some extensions that allow you to use NS's `at` syntax to invoke arbitrary commands on your experimental nodes. Once you define a program object and initialize its command line and the node on which the command should be run, you can schedule the command to be started and stopped with NS `at` statements. Some points worth mentioning:

  * A program must be "stopped" before it is started; if the program is currently running on the node, the start event will be silently ignored.
  * The command line is passed to /bin/csh; any valid csh expression is allowed, although no syntax checking is done prior to invoking it. If the syntax is bad, the command will fail. It is a good idea to redirect output to a log file so you can track failures.
  * The "stop" command is implemented by sending a SIGTERM to the process group leader (the csh process). If the SIGTERM fails, a SIGKILL is sent.

To define a program object:

	
		set prog0 [$nodeA program-agent -command "/bin/ls -lt"]
		set prog1 [$nodeB program-agent -command "/bin/sleep 60"]
	

Then in your NS file a set of static events to run these commands:
	
		$ns at 10 "$prog0 start"
		$ns at 20 "$prog1 start"
		$ns at 30 "$prog1 stop"
	

If you want to schedule starts and stops using dynamic events:
	
		tevc -e testbed/myexp now prog0 start
		tevc -e testbed/myexp now prog1 start
		tevc -e testbed/myexp +20 prog1 stop
	

If you want to change the command that is run (override the command you specified in your NS file), then:
	
		tevc -e testbed/myexp now prog0 start COMMAND='ls'
	

If you want to log output in order to debug your script, you can redirect it (in csh, *>&* redirects both stdout and stderr):
	
		set prog0 [$nodeA program-agent -command "/bin/ls -lt /etc >& /tmp/output.debug"]
	

# Link Tracing and Monitoring #Tracing

DETER has simple support for tracing and monitoring links and lans. For example, to trace a link:
	
		set link0 [$ns duplex-link $nodeB $nodeA 30Mb 50ms DropTail]
	
		$link0 trace
	

The default mode for tracing a link (or a lan) is to capture just the packet headers (first 64 bytes of the packet) and store them to a tcpdump output file. You may also view a realtime summary of packets through the link, via the web interface, by going to the 'Show Experiment' page for the experiment, and clicking on the Link Tracing/Monitoring' menu option. You may also control the link tracing programs on the fly, pausing them, restarting them, and killing them. [[BR]][[BR]] Here is an example of the output from interactive 'Link Tracing/Monitoring':
	
		1177100936.506386 (icmp:0,0 tcp:0,0 udp:0,0 other:0,0) (icmp:0,0 tcp:0,0 udp:0,0 other:0,0) (dropped:0)
	

The first thing on each line is a timestamp, in typically unix format (seconds since the epoch). Each set of measurements in parentheses contains counts for one of the interfaces on the node to which you're connected. When you first connect, it prints a single line containing the number of interfaces for the node, and then one line explaining which link each interface belongs to. The first set of measurements on the line corresponds to the first interface reported, and so on. 'icmp:A,B' means that, since the last message, there were A bytes of ICMP traffic sent in B packets. [[BR]][[BR]] In addition to capturing just the packet headers, you may also capture the entire packet:
	
		$link0 trace packet
	

Or you may not capture any packets, but simply gather the realtime summary so that you can view it via the web interface.
	
		$link0 trace monitor
	

By default, all packets traversing the link are captured by the tracing agent. If you want to narrow the scope of the packets that are captured, you may supply any valid tcpdump (pcap) style expression:
	
		$link0 trace monitor "icmp or tcp"
	

You may also set the *snaplen* for a link or lan, which sets the number of bytes that will be captured by each of the trace agents (as mentioned above, the default is 64 bytes, which is adequate for determining the type of most packets):
	
		$link0 trace_snaplen 128
	

Tracing parameters may also be specified on a *per-node basis*, for each node in a link or lan. For example, consider the duplex link `link0` above between `nodeA` and `nodeB`. If you want to set a different snaplen and trace expression for packets _leaving_ `nodeA`, then:
	
	
		[[$ns link $nodeA $nodeB] queue] set trace_type header
		[[$ns link $nodeA $nodeB] queue] set trace_snaplen 128
		[[$ns link $nodeA $nodeB] queue] set trace_expr "ip proto tcp"
	

To set the parameters for packets leaving `nodeB`, simply reverse the arguments to the `link` statement:
	
		[[$ns link $nodeB $nodeA] queue] set trace_snaplen 128
	

For a lan, the syntax is slightly different. Consider a lan called `lan0` with a node called `nodeL` on it:
	
		[[$ns lanlink $lan0 $nodeL] queue] set trace_type header
		[[$ns lanlink $lan0 $nodeL] queue] set trace_snaplen 128
		[[$ns lanlink $lan0 $nodeL] queue] set trace_expr "ip proto tcp"
	

[[BR]] When capturing packets (rather then just "monitoring"), the packet data is written to tcpdump (pcap) output files in `/local/logs` on the delay node. Note that while delay nodes are allocated for each traced link/lan, packets are shaped only if the NS file requested traffic shaping. Otherwise, the delay node acts simply as a bridge for the packets, which provides a place to capture and monitor the packets, without affecting the experiment directly. Whether the link or lan is shaped or not, packets leaving each node are captured twice; once when they arrive at the delay node, and again when they leave the delay node. This allows you to precisely monitor how the delay node affects your packets, whether the link is actually shaped or not. You can use the [loghole utility](http://www.emulab.net/tutorial/loghole.html) to copy the capture files back to the experiment's log directory. [[BR]] When a link or lan is traced, you may monitor a realtime summary of the packets being captured, via the web interface. From the "Show Experiment" page for your experiment, click on the "Link Tracing" link. You will see a list of each link and lan that is traced, and each node in the link or lan. For each node, you can click on the "Monitor" button to bring up a window that displays the realtime summary for packets _leaving_ that node. Currently, the realtime summary is somewhat primitive, displaying the number of packets (and total bytes) sent each second, as well as a breakdown of the packet types for some common IP packet types. [[BR]] Other buttons on the Link Tracing page allow you to temporarily pause packet capture, restart it, or even kill the packet capture processes completely (since they continue to consume CPU even when paused). The "snapshot" button causes the packet capture process to close its output files, rename them, and then open up new output files. The files can then be saved off with the loghole utility, as mentioned above. [[BR]] If you want to script the control of the packet tracing processes, you can use the [#DynamicEvents event system] to send dynamic events. For example, to tell the packet capture processes monitoring `link0` to snapshot, pause, and restart:
	
		tevc -e myproj/myexp now link0-tracemon snapshot
		tevc -e myproj/myexp now link0-tracemon stop
		tevc -e myproj/myexp now link0-tracemon start
	

And of course, you may use the NS "at" syntax to schedule static events from your NS file:
	
		$ns at 10 "$link0 trace stop"
		$ns at 20 "$link0 trace start"
		$ns at 30 "$link0 trace snapshot"
	

The output files that the capture process create, are stored in `/local/logs`, and are named by the link and node name. In the above link example, four capture files are created:

  * trace_nodeA-link0.xmit
  * trace_nodeA-link0.recv
  * trace_nodeB-link0.xmit
  * trace_nodeB-link0.recv

where the `.recv` files hold the packets that were sent by the node and _received'' by the delay node. The `.xmit` files hold those packets that were ''transmitted_ by the delay node and received by the other side of the link. So, for packets sent from `nodeA` to `nodeB`, the packet would arrive at the delay node and be recorded in trace_nodeA-link0.recv. Once the packet traverses the delay node (subject to Dummynet traffic shaping) and it is about to be transmitted, it is recorded in trace_nodeA-link0.xmit. By comparing these two files, you can see how the Dummynet traffic shaping has affected your packets, in each direction. Note that even if you have not specified traffic shaping, you still get the same set of files. In this case, the `.recv` and `.xmit` files will be nearly identical, reflecting only the negligible propagation delay through the software bridge. [[BR]] When you issue a "snapshot" command, the above files are closed, and renamed to:

  * trace_nodeA-link0.xmit.0
  * trace_nodeA-link0.recv.0
  * trace_nodeB-link0.xmit.0
  * trace_nodeB-link0.recv.0

and a new set of files is opened. Note that the files are not rolled; the next time you issue the snapshot command, the current set of files ending with `.0` are lost.

# EndNode Tracing and Monitoring

_Endnode tracing/monitoring_ refers to putting the trace hooks on the end nodes of a link, instead of on delay nodes. This happens when there are no delay nodes in use or if you have explicitly requested [wiki:linkdelays end node shaping] to reduce the number of nodes you need for an experiment. You may also explicitly request tracing to be done on the end nodes of a link (or a lan) with the following NS command:
	
		$link0 trace_endnode 1
	

(Note that if a delay node does exist, it will be used for traffic capture even if endnode tracing is specified.) When tracing/monitoring is done on an endnode, the output files are again stored in `/local/logs`, and are named by the link and node name. The difference is that there is just a _single'' output file, for those packets ''leaving_ the node. Packets are captured after traffic shaping has been applied.

  * trace_nodeA-link0.xmit
