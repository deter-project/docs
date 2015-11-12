
[[TOC]]

# Link Tracing and Monitoring #Tracing

DeterLab has simple support for tracing and monitoring links and LANs. For example, to trace a link you would use code such as the following in your NS file:
	
		set link0 [$ns duplex-link $nodeB $nodeA 30Mb 50ms DropTail]
	
		$link0 trace
	

The default mode for tracing a link (or a LAN) is to capture just the packet headers (the first 64 bytes of the packet) and store them to a tcpdump output file. You may view a realtime summary of packets through the link, via the [web interface](http://www.isi.deterlab.net) by going to the Experiment page and clicking on the "Link Tracing/Monitoring" menu option. 

You may also control the link tracing programs on the fly, pausing them, restarting them, and killing them. 

Here is an example of the output from interactive "Link Tracing/Monitoring":
	
		1177100936.506386 (icmp:0,0 tcp:0,0 udp:0,0 other:0,0) (icmp:0,0 tcp:0,0 udp:0,0 other:0,0) (dropped:0)
	

The first thing on each line is a timestamp, in typically Unix format (seconds since the epoch). Each set of measurements in parentheses contains counts for one of the interfaces on the node to which you're connected. When you first connect, it prints a single line containing the number of interfaces for the node, and then one line explaining which link each interface belongs to. The first set of measurements on the line corresponds to the first interface reported, and so on. `icmp:A,B` means that, since the last message, there were A bytes of ICMP traffic sent in B packets. 

In addition to capturing just the packet headers, you may also capture the entire packet:
	
		$link0 trace packet
	

Or you may not capture any packets, but simply gather the realtime summary so that you may view it via the web interface.
	
		$link0 trace monitor
	

By default, all packets traversing the link are captured by the tracing agent. If you want to narrow the scope of the packets that are captured, you may supply any valid tcpdump (pcap) style expression:
	
		$link0 trace monitor "icmp or tcp"
	

You may also set the *snaplen* for a link or LAN, which sets the number of bytes that will be captured by each of the trace agents (as mentioned above, the default is 64 bytes, which is adequate for determining the type of most packets):
	
		$link0 trace_snaplen 128
	

Tracing parameters may also be specified on a *per-node basis*, for each node in a link or LAN. For example, consider the duplex link `link0` above between `nodeA` and `nodeB`. If you want to set a different snaplen and trace expression for packets _leaving_ `nodeA`, then use:
	
	
		[[$ns link $nodeA $nodeB] queue] set trace_type header
		[[$ns link $nodeA $nodeB] queue] set trace_snaplen 128
		[[$ns link $nodeA $nodeB] queue] set trace_expr "ip proto tcp"
	

To set the parameters for packets leaving `nodeB`, simply reverse the arguments to the `link` statement:
	
		[[$ns link $nodeB $nodeA] queue] set trace_snaplen 128
	

For a LAN, the syntax is slightly different. Consider a LAN called `lan0` with a node called `nodeL` on it:
	
		[[$ns lanlink $lan0 $nodeL] queue] set trace_type header
		[[$ns lanlink $lan0 $nodeL] queue] set trace_snaplen 128
		[[$ns lanlink $lan0 $nodeL] queue] set trace_expr "ip proto tcp"
	

When capturing packets (rather then just "monitoring"), the packet data is written to tcpdump (pcap) output files in `/local/logs` on the delay node. Note that while delay nodes are allocated for each traced link/lan, packets are shaped only if the NS file requested traffic shaping. Otherwise, the delay node acts simply as a bridge for the packets, which provides a place to capture and monitor the packets, without affecting the experiment directly. 

Whether the link or LAN is shaped or not, packets leaving each node are captured twice; once when they arrive at the delay node, and again when they leave the delay node. This allows you to precisely monitor how the delay node affects your packets, whether the link is actually shaped or not. You can use the [wiki:DeterLabCommands#loghole loghole utility] to copy the capture files back to the experiment's log directory. 

When a link or LAN is traced, you may monitor a realtime summary of the packets being captured, via the web interface's Experiment page by clicking on the "Link Tracing" link. You will see a list of each link and LAN that is traced, and each node in the link or LAN. For each node, you can click on the "Monitor" button to bring up a window that displays the realtime summary for packets _leaving_ that node. Currently, the realtime summary is somewhat primitive, displaying the number of packets (and total bytes) sent each second, as well as a breakdown of the packet types for some common IP packet types. 

Other buttons on the _Link Tracing_ page allow you to temporarily pause packet capture, restart it, or even kill the packet capture processes completely (since they continue to consume CPU even when paused). The "snapshot" button causes the packet capture process to close its output files, rename them, and then open up new output files. The files can then be saved off with the loghole utility, as mentioned above. 

If you want to script the control of the packet tracing processes, you can use the [#DynamicEvents event system] to send dynamic events. For example, to tell the packet capture processes monitoring `link0` to snapshot, pause, and restart:
	
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

where:
* The `.recv` files hold the packets that were sent by the node and _received_ by the delay node. 
* The `.xmit` files hold those packets that were _transmitted_ by the delay node and received by the other side of the link. 

So, for packets sent from `nodeA` to `nodeB`, the packet would arrive at the delay node and be recorded in `trace_nodeA-link0.recv`. Once the packet traverses the delay node (subject to Dummynet traffic shaping) and it is about to be transmitted, it is recorded in `trace_nodeA-link0.xmit`. By comparing these two files, you can see how the Dummynet traffic shaping has affected your packets, in each direction. 

Note that even if you have not specified traffic shaping, you still get the same set of files. In this case, the `.recv` and `.xmit` files will be nearly identical, reflecting only the negligible propagation delay through the software bridge. 

When you issue a "snapshot" command, the above files are closed, and renamed to:

  * trace_nodeA-link0.xmit.0
  * trace_nodeA-link0.recv.0
  * trace_nodeB-link0.xmit.0
  * trace_nodeB-link0.recv.0

and a new set of files is opened. Note that the files are not rolled; the next time you issue the snapshot command, the current set of files ending with `.0` are lost.

# EndNode Tracing and Monitoring

_Endnode tracing/monitoring_ refers to putting the trace hooks on the end nodes of a link, instead of on delay nodes. This happens when there are no delay nodes in use or if you have explicitly requested [wiki:linkdelays end node shaping] to reduce the number of nodes you need for an experiment. You may also explicitly request tracing to be done on the end nodes of a link (or a LAN) with the following NS command:
	
		$link0 trace_endnode 1
	

(Note that if a delay node does exist, it will be used for traffic capture even if endnode tracing is specified.) When tracing/monitoring is done on an endnode, the output files are again stored in `/local/logs`, and are named by the link and node name. The difference is that there is just a _single'' output file, for those packets ''leaving_ the node. Packets are captured after traffic shaping has been applied.

  * trace_nodeA-link0.xmit
