# Per-Link Traffic Shaping ("linkdelays")

In order to conserve nodes, it is possible to specify that instead of doing traffic shaping on separate delay nodes (which eats up a node for every two shaped links), it be done on the nodes that are actually generating the traffic.

If you are running FreeBSD on your nodes, end node traffic shaping uses IPFW to direct traffic into the proper Dummynet pipe. On each node in a duplex link or LAN, a set of IPFW rules and Dummynet pipes is set up. As traffic enters or leaves your node, IPFW looks at the packet and stuffs it into the proper Dummynet pipe. At the proper time, Dummynet takes the packet and sends it on its way.

Under Linux, end node traffic shaping is performed by the packet scheduler modules, part of the kernel NET3 implementation. Each packet is added to the appropriate scheduler queue tree and shaped as specified in your NS file. Note that Linux traffic shaping currently only supports the drop-tail queueing discipline; gred and red are not available yet.

To specify end node shaping in your NS file, simply set up a normal link or LAN, and then mark it as wanting to use end node traffic shaping. For example: 

    set link0 [$ns duplex-link $nodeA $nodeD 10Mb 0ms DropTail]
    set lan0  [$ns make-lan "nodeA nodeB nodeC" 1Mb 0ms]

    tb-set-endnodeshaping $link0 1
    tb-set-endnodeshaping $lan0 1


Please be aware though, that the kernels are different than the standard ones in a couple of ways:

  * The kernel runs at a 1000HZ (1024HZ in Linux) clockrate instead of 100HZ. That is, the timer interrupts 1000 (1024) times per second instead of 100. This finer granularity allows the traffic shapers to do a better job of scheduling packets.
  * Under FreeBSD, IPFW and Dummynet are compiled into the kernel, which affects the network stack; all incoming and outgoing packets are sent into IPFW to be matched on. Under Linux, packet scheduling exists implicitly, but uses lightweight modules by default.
  * The packet timing mechanism in the linkdelay Linux kernel uses a slightly heavier (but more precise) method.
  * Flow-based IP forwarding is turned off. This is also known as IP ''fast forwarding'' in the FreeBSD kernel. Note that regular IP packet forwarding is still enabled.

To use end node traffic shaping globally, without having to specify per link or LAN, use the following in your NS file:

    tb-use-endnodeshaping   1


To specify non-shaped links, but perhaps control the shaping parameters later (increase delay, decrease bandwidth, etc.) after the experiment is swapped in, use the following in your NS file:

    tb-force-endnodeshaping   1


## Multiplexed Links

Another feature we have added (FreeBSD only) is ''multiplexed'' (sometimes called ''emulated'') links. An emulated link is one that can be multiplexed over a physical link along with other links. Say your experimental nodes have just one physical interface (call it "fxp0"), but you want to create two duplex links on it:

    set link0 [$ns duplex-link $nodeA $nodeB 50Mb 0ms DropTail]
    set link1 [$ns duplex-link $nodeA $nodeC 50Mb 0ms DropTail]

    tb-set-multiplexed $link0 1
    tb-set-multiplexed $link1 1


Without multiplexed links, your experiment would not be mappable since there are no nodes that can support the two duplex links that NodeA requires; there is only one physical interface. 

Using multiplexed links however, the testbed software will assign both links on NodeA to one physical interface. That is because each duplex link is only 50Mbs, while the physical link (fxp0) is 100Mbs. 

Of course, if your application actually tried to use more than 50Mbs on each multiplexed link, there would be a problem; a flow using more than its share on link0 would cause packets on link1 to be dropped when they otherwise would not be. ('''At this time, you cannot specify that a LAN use multiplexed links''') 

To prevent this problem, a multiplexed link is automatically setup to use [#LINKDELAYS per-link traffic shaping]. Each of the links in the above example would get a set of DummyNet pipes restricting their bandwidth to 50Mbs. Each link is forced to behave just as it would if the actual link bandwidth were 50Mbs. This allows the underlying physical link to support the aggregate bandwidth. Of course, the same caveats listed for per-link delays apply when using multiplexed links. 

As a concrete example, consider the following NS file which creates a router and attaches it to 12 other nodes:

    set maxnodes 12

    set router [$ns node]

    for {set i 1} {$i <= $maxnodes} {incr i} {
        set node($i) [$ns node]
        set link($i) [$ns duplex-link $node($i) $router 30Mb 10ms DropTail]
        tb-set-multiplexed $link($i) 1
    }
    tb-set-vlink-emulation vlan

    # Turn on routing.
    $ns rtproto Static


Since each node has four 100Mbs interfaces, the above mapping would not be possible without the use of multiplexed links. However, since each link is defined to use 30Mbs, by using multiplexed links, the 12 links can be shared over the four physical interfaces, without oversubscribing the 400Mbs aggregate bandwidth available to the node that is assigned to the router. 

## FreeBSD Technical Discussion

First, let's just look at what happens with per-link delays on a duplex link. In this case, an IPFW pipe is set up on each node. The rule for the pipe looks like:

    ipfw add pipe 10 ip from any to any out xmit fxp0


which says that any packet going out on fxp0 should be stuffed into pipe 10. 

Consider the case of a ping packet that traverses a duplex link from NodeA to NodeB: 
* Once the proper interface is chosen (based on routing or the fact that the destination is directly connected), the packet is handed off to IPFW, which determines that the interface (fxp0) matches the rule specified above. 
* The packet is then stuffed into the corresponding Dummynet pipe, to emerge sometime later (based on the traffic shaping parameters) and be placed on the wire. 
* The packet then arrives at NodeB. 
* A ping reply packet is created and addressed to NodeA, placed into the proper Dummynet pipe, and arrives at NodeA. 

As you can see, each packet traversed exactly one Dummynet pipe (or put another way, the entire ping/reply sequence traversed two pipes). 

Constructing delayed LANs is more complicated than duplex links because of the desire to allow each node in a LAN to see different delays when talking to any other node in the LAN. That is, the delay when traversing from NodeA to NodeB is different than when traversing from NodeA to NodeC. Further, the return delays might be specified completely differently so that the return trips take a different amount of time.  

To support this, it is necessary to insert two delay pipes for each node. One pipe is for traffic leaving the node for the LAN, and the other pipe is for traffic entering the node from the LAN. Why not create ''N'' pipes on each node for each possible destination address in the LAN, so that each packet traverses only one pipe? The reason is that a node on a LAN has only one connection to it, and multiple pipes would not respect the aggregate bandwidth cap specified. 

The rule for the second pipe looks like:

    ipfw add pipe 15 ip from any to any in recv fxp0


which says that any packet received on fxp0 should be stuffed into pipe 15. The packet is later handed up to the application, or forwarded on to the next hop, if appropriate. 

The addition of multiplexed links complicates things further. To multiplex several different links on a physical interface, one must use either encapsulation (ipinip, VLAN, etc) or IP interface aliases. We chose IP aliases because it does not affect the MTU size. The downside of IP aliases is that it is difficult (if not impossible) to determine what flow a packet is part of, and thus which IPFW pipe to stuff the packet into. In other words, the rules used above:

    ipfw add ... out xmit fxp0
    ipfw add ... in recv fxp0


do not work because there are now multiple flows multiplexed onto the interface (multiple IPs) and so there is no way to distinguish which flow. 

Consider a duplex link in which we use the first rule above. If the packet is not addressed to a direct neighbor, the routing code lookup will return a nexthop, which '''does''' indicate the flow, but because the rule is based simply on the interface (fxp0), all flows match! 

Unfortunately, IPFW does not provide an interface for matching on the nexthop address, but seeing as we are kernel hackers, this is easy to deal with by adding new syntax to IPFW to allow matching on nexthop:

    ipfw add ... out xmit fxp0 nexthop 192.168.2.3:255.255.255.0


Now, no matter how the user alters the routing table, packets will be stuffed into the proper pipe since the nexthop indicates which directly connected virtual link the packet was sent over. The use of a mask allows for matching when directly connected to a LAN (a simplification). 

Multiplexed LANs present even worse problems because of the need to figure out which flow an incoming packet is part of. When a packet arrives at an interface, there is nothing in the packet to indicate which IP alias the packet was intended for (or which it came from) when the packet is not destined for the local node (is being forwarded).

## Linux Technical Discussion

Traffic shaping under Linux uses the NET3 packet scheduling modules, a hierarchically composable set of disciplines providing facilities such as bandwidth limiting, packet loss, and packet delay. As in the FreeBSD case, simplex (outgoing) link shaping is used on point-to-point links, while duplex shaping (going out, and coming in an interface) is used with LANs. See the previous section to understand why this is done. 

Unlike FreeBSD, Linux traffic shaping modules must be connected directly to a network device, and hence don't require a firewall directive to place packets into them. This means that all packets must pass through the shaping tree connected to a particular interface. Note that filters may be used on the shapers themselves to discriminate traffic flows, so it's not strictly the case that all traffic must be shaped if modules are attached. However, all traffic to an interface, at the least, is queued and de-queued through the root module of the shaping hierarchy. And all interfaces have at least a root module, but it is normally just a fast FIFO. 

Also of note is the fact that Linux traffic shaping normally only happens on the outgoing side of an interface, and requires a special virtual network device (known as an intermediate queuing device or IMQ) to capture incoming packets for shaping. This also requires the aid of the Linux firewalling facility, iptables, to divert the packets to the IMQs prior to routing. 

Here is an example duplex-link configuration with 50Mbps of bandwidth, a 0.05 PLR, and 20ms of delay in both directions: 

Outgoing side setup commands:

    # implicitly sets up class 1:1
    tc qdisc add dev eth0 root handle 1 plr 0.05

    # attach to class 1:1 and tell the module the default place to send
    # traffic is to class 2:1 (could attach filters to discriminate)
    tc qdisc add dev eth0 parent 1:1 handle 2 htb default 1

    # class 2:1 does the actual limiting
    tc class add dev eth0 parent 2 classid 2:1 htb rate 50Mbit ceil 50Mbit

    # attach to class 2:1, also implicitly creates class 3:1, and attaches
    # a FIFO queue to it.
    tc qdisc add dev eth0 parent 2:1 handle 3 delay usecs 20000


The incoming side setup commands will look the same, but with eth0 replaced by imq0. Also, we have to tell the kernel to send packets coming into eth0 to imq0 (where they will be shaped):

    iptables -t mangle -A PREROUTING -i eth0 -j IMQ --todev 0


A flood ping sequence utilizing eth0 (echo->echo-reply) would experience a round trip delay of 40 ms, be restricted to 50Mbit, and have a 10% chance of losing packets. The doubling of numbers is due to shaping as packets go out, and come back in the interface. 

At the time of writing, we don't support multiplexed links under Linux, so no explicit matching against nexthop is necessary.