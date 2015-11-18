In order to use the testbed specific commands, you must include the following line near the top of your NS topology file (before any testbed commands are used):

```
    source tb_compat.tcl
```

If you wish to use your file under NS, download <a href="/downloads/tb_compat.tcl">tb_compat.tcl</a> and place it in the same directory as your NS file. When run in this way under NS, the testbed commands will have no effect, but NS will be able to parse your file.

----

## TCL, NS, and node names

In your file, you will be creating nodes with something like the following line:

```
    set node1 [$ns node]
```

With this command, the simulator, represented by ```$ns``` is creating a new node involving many internal data changes and returning a reference to it which is stored in the variable ```node1```. 

In almost all cases when you need to refer to a node, you will do it as ```$node1```, the ```$``` indicating that you want the value of the variable ```node1```, i.e. the reference to the node. Thus you will be issuing commands like:
```
    $ns duplex-link $node1 $node2 100Mb 150ms DropTail
    tb-set-ip $node1 10.1.0.2
```

Note the instances of ```$```.

You will notice that when your experiment is set up, the node names and such will be ```node1```, ```node2```, ```node3```, etc. This happens because the parser detects what variable you are using to store the node reference and uses that as the node name. In the case that you do something like:

```
    set node1 [$ns node2]
    set A $node1
```

The node will still be called ```node1``` as that was the first variable to contain the reference.

If you are dealing with many nodes you may store them in an array, using a command similar to the following:

```
    for {set i 0} {$i < 4} {incr i} {
       set nodes($i) [$ns node]
    }
```

In this case, the names of the node will be ```nodes-0```, ```nodes-1```, ```nodes-2```, ```nodes-3```. In other words, the "(" character is replaced with "-", and ")" is removed. This slightly different syntax is used to avoid any problems that "()" may cause later in the process. For example, the "()" characters may not appear in DNS entries.

As a final note, everything said above for nodes applies equally to LANs, i.e.:

```
    set lan0 [$ns make-lan "$node0 $node1" 100Mb 0ms]
    tb-set-lan-loss $lan0 .02
```

Again, note the instances of ```$```.

Links may also be named just like nodes and LANs. The names may then be used to set loss rates or IP addresses. This technique is the only way to set such attributes when there are multiple links between two nodes.

```
    set link1 [$ns duplex-link $node0 $node1 100Mb 0ms DropTail]
    tb-set-link-loss $link1 0.05
    tb-set-ip-link $node0 $link1 10.1.0.128
```

----

## Captured NS file parameters

A common convention when writing NS files is to place any parameters in an array named ```opt``` at the beginning of the file. For example:

```
    set opt(CLIENT_COUNT) 5
    set opt(BW) 10mb;    Link bandwidth
    set opt(LAT) 10ms;   Link latency

   ...

    $ns duplex-link $server $router $opt(BW) $opt(LAT) DropTail

    for {set i 0} {$i < $opt(CLIENT_COUNT)} {incr i} {
        set nodes($i) [$ns node]
	...
    }
    set serverprog [$server program-agent -command "starter.sh"]
```

Normally, this convention is only used to help organize the parameters. In DETERLab, however, the contents of the ```opt``` array are captured and made available to the emulated environment. For instance, the parameters are added as environment variables to any commands run by program-agents. So in the above example of NS code, the ```starter.sh``` script will be able to reference parameters by name, like so:

```
    #! /bin/sh

    echo "Testing with $CLIENT_COUNT clients."
    ...
```

Note that the contents of the ```opt``` array are not ordered, so you should not reference other parameters and expect the shell to expand them appropriately:

```
    set opt(prefix) "/foo/bar"
    set opt(BINDIR) '$prefix/bin'; # BAD

    set opt(prefix) "/foo/bar"
    set opt(BINDIR) "$opt(prefix)/bin"; # Good
```

----

## Ordering Issues ##

```tb-``` commands have the same status as all other Tcl and NS commands. Thus **the order matters** not only relative to each other but also relative to other commands. One common example of this is that IP commands must be issued *after* the links or LANs are created.

----

## Hardware Commands

### tb-set-hardware
```
tb-set-hardware node type [args]

tb-set-hardware $node3 pc
tb-set-hardware $node4 shark
```

where:

`node` = The name of the node.

`type` = The type of the node.

!!! note
    * Please see the [Node Status](https://www.isi.deterlab.net/nodecontrol_list.php3) page for a list of available types. `pc` is the default type.
    * No current types have any additional arguments.

----

## IP Address Commands 

Each node will be assigned an IP address for each interface that is in use. The following commands will allow you to explicitly set those IP addresses. IP addresses will be automatically generated for all nodes for which you do not explicitly set IP addresses.

In most cases, the IP addresses on either side of a link must be in the same subnet. Likewise, all IP addresses on a LAN should be in the same subnet. Generally the same subnet should not be used for more than one link or LAN in a given experiment, nor should one node have multiple interfaces in the same subnet. Automatically generated IP addresses will conform to these requirements. If part of a link or LAN is explicitly specified with the commands below then the remainder will be automatically generated under the same subnet.

IP address assignment is deterministic and tries to fill lower IP's first, starting at 2. Except in the partial specification case (see above), all automatic IP addresses are in the network `10`.

### tb-set-ip 

```
tb-set-ip node ip

tb-set-ip $node1 142.3.4.5
```

where:

`node` = The node to assign the IP address to

`ip` = The IP address.

!!! note
    * This command should only be used for nodes that have a single link. For nodes with multiple links the following commands should be used. Mixing ```tb-set-ip``` and any other IP command on the same node will result in an error.

### tb-set-ip-link 

```
tb-set-ip-link node link ip

tb-set-ip-link $node0 $link0 142.3.4.6
```

where:

`node` = The node to set the IP for.

`link` = The link to set the IP for.

`ip` = The IP address.

!!! note
    * One way to think of the arguments is a link with the node specifying which side of the link to set the IP for.
    * This command cannot be mixed with ```tb-set-ip``` on the same node.

### tb-set-ip-lan

```
tb-set-ip-lan node lan ip
tb-set-ip-lan $node1 $lan0 142.3.4.6
```

where:

`node` = The node to set the IP for.

`lan` = The lan the IP is on.

`ip` = The IP address.

!!! note
    * One way to think of the arguments is a node with the LAN specifying which port to set the IP address for.
    * This command cannot be mixed with ```tb-set-ip``` on the same node.

### tb-set-ip-interface

```
tb-set-ip-interface node dst ip
tb-set-ip-interface $node2 $node1 142.3.4.6
```

where:

`node` = The node to set the IP for.

`dst` = The destination of the link to set the IP for.

`IP` = The IP address.

!!! note
    * This command cannot be mixed on the same node with ```tb-set-ip```. (See above)
    * In the case of multiple links between the same pair of nodes, there is no way to distinguish which link to the set the IP for. This should be fixed soon.
    * This command is converted internally to either ```tb-set-ip-link``` or ```tb-set-ip-lan```. It is possible that error messages will report either of those commands instead of ```tb-set-ip-interface```.

### tb-set-netmask
```
tb-set-netmask lanlink netmask

tb-set-netmask $link0 "255.255.255.248"
```

where:

`lanlink` = The lan or link to set the netmask for.

`netmask` = The netmask in dotted notation.

!!! note
    * This command sets the netmask for a LAN or link. The mask must be big enough to support all of the nodes on the LAN or link!
    * You may play with the bottom three octets (0xFFFFFXXX) of the mask; attempts to change the upper octets will cause an error.

----

## OS Commands <a name="OS"></a>

### tb-set-node-os
```
tb-set-node-os node os

tb-set-node-os $node1 FBSD-STD
tb-set-node-os $node1 MY_OS
```

where:

`node` = The node to set the OS for.

`os` = The id of the OS for that node.

!!! note
    * The OSID may either by one of the standard OS's we provide or a custom OSID, created via the web interface.
    * If no OS is specified for a node, a default OS is chosen based on the nodes type. This is currently `'Ubuntu1004-STD`' for PCs.
    * The currently available standard OS types are listed in the <a href="/core/os-images/">OS Images</a> page.

### tb-set-node-rpms
```
tb-set-node-rpms node rpms...

tb-set-node-rpms $node0 rpm1 rpm2 rpm3
```

!!! note
    * This command sets which RPMs are to be installed on the node when it first boots after being assigned to an experiment.
    * Each RPM can be either a path to a file or a URL. Paths must be to files that reside in the ```/proj``` or ```/groups``` directory. You are not allowed to place your RPMs in your home directory. ```http(s)://``` and ```ftp://``` URLs will be fetched into the experiment's directory, and re-distributed from there.
    * See the <a href="/core/core-guide/#installing-rpms-automatically">Core Guide</a> for more information.

### tb-set-node-startcmd
```
tb-set-node-startcmd node startupcmd

tb-set-node-startcmd $node0 "mystart.sh -a >& /tmp/node0.log"
```

!!! note
    * Specify a script or program to be run when the node is booted.
    * See the <a href="/core/core-guide/">Core Guide</a> for more information.

### tb-set-node-cmdline
```
tb-set-node-cmdline node cmdline

tb-set-node-cmdline $node0 {???}
```

!!! note
    * Set the commandline to be passed to the `kernel` when it is booted.
    * Currently, this is supported on OSKit kernels only.

### tb-set-node-tarfiles
```
tb-set-node-tarfiles node install-dir1 tarfile1 ...
```

The ```tb-set-node-tarfiles``` command is used to install one or more tar files onto a node's local disk. This command is useful for installing files that are used frequently, but will change very little during the course of your experiments. For example, if your software depends on a third-party library not provided in the standard disk images, you can produce a tarball and have the library ready for use on all the experimental nodes. 

Another example would be the data sets for your software. The benefit of installing files using this method is that they will reside on the node's local disk, so your experimental runs will not be disrupted by NFS traffic. 

!!! note
    Avoid using this command if the files are changing frequently because the tars are only (re)installed when the nodes boot.

Installing individual tar files or RPMs is a midpoint in the spectrum of getting software onto the experimental nodes. At one extreme, you can read everything over NFS, which works well if the files are changing constantly, but can generate a great deal of strain on the control network and disrupt your experiment. The tar files and RPMs are also read over NFS when the nodes initially boot; however, there won't be any extra NFS traffic while you are running your experiment. Finally, if you need a lot of software installed on a large number of nodes, say greater than 20, it might be best to create a <a href="/core/custom-images/">custom disk image</a>. Using a disk image is easier on the control network since it is transferred using multicast, thus greatly reducing the amount of NFS traffic when the experiment is swapped in. 

**Required Parameters:**

  * `node` - The node where the files should be installed. Each node has its own tar file list, which may or may not be different from the others.
  * One or more `install-dir` and `tarfile` pairs are then listed in the order you wish them to be installed:
    * `install-dir` - An existing directory on the node where the tar file should be unarchived (e.g. ```/```, ```/usr```, ```/usr/local```). The ```tar``` command will be run as "root" [#tb-set-node-tarfiles Note1], so all of the node's directories will be accessible to you. If the directory does not exist on the image or was not created by the unarchiving of a previous tar file, the installation will fail [#tb-set-node-tarfiles Note2].
    * `tarfile` - An existing tar file located in a project directory (e.g. ```/proj``` or ```/groups```) or an `http`, `https`, or `ftp` URL. In the case of URLs, they are downloaded when the experiment is swapped in and cached in the experiment's directory for future use. In either case, the tar file name is `required` to have one of the following extensions: .tar, .tar.Z, .tar.gz, or .tgz. Note that the tar file could have been created anywhere; however, if you want the unarchived files to have valid DETERLab user and group id's, you should create the tar file on ```ops``` or an experimental node.

**Example usage:**

```
	# Overwrite files in /bin and /sbin.
	tb-set-node-tarfiles $node0 /bin /proj/foo/mybinmods.tar /sbin /proj/foo/mysbinmods.tar

	# Programmatically generate the list of tarballs.
	set tb [list]
	# Add a tarball located on a web site.
	lappend tb / http://foo.bar/bazzer.tgz
	# Add a tarball located in the DETER NFS space.
	lappend tb /usr/local /proj/foo/tarfiles/bar.tar.gz
	# Use 'eval' to expand the 'tb' list into individual
	# arguments to the tb-set-node-tarfiles command.
	eval tb-set-node-tarfiles $node1 $tb
```

**See also:**

  * <a href="#tb-set-node-rpms">`tb-set-node-rpms`</a>
  * <a href="/core/custom-images/">Custom disk images</a>

!!! note
    * Because the files are installed as root, care must be taken to protect the tar file so it cannot be replaced with a trojan that allowed less privileged users to become root.
    * Currently, you can only tell how/why an installation failed by examining the node's console log on bootup.

----

## Link Loss Commands

This is the NS syntax for creating a link:

```
$ns duplex-link $node1 $node2 100Mb 150ms DropTail
```

!!! note
    This does not allow for specifying link loss rates. DETERLab does, however, support link loss. The following commands can be used to specify link loss rates.

### tb-set-link-loss 
```
tb-set-link-loss src dst loss
tb-set-link-loss link loss

tb-set-link-loss $node1 $node2 0.05
tb-set-link-loss $link1 0.02
```

where:

`src`, `dst` = Two nodes to describe the link.

`link` = The link to set the rate for.

`loss` = The loss rate (between 0 and 1).

!!! note
    * There are two syntaxes available. The first specifies a link by a source/destination pair. The second explicitly specifies the link.
    * The source/destination pair is incapable of describing an individual link in the case of multiple links between two nodes. Use the second syntax for this case.

### tb-set-lan-loss 
```
tb-set-lan-loss lan loss

tb-set-lan-loss $lan1 0.3
```

Where:

`lan` = The lan to set the loss rate for.

`loss` = The loss rate (between 0 and 1).

!!! note
    This command sets the loss rate for the entire LAN.

### tb-set-node-lan-delay
```
tb-set-node-lan-delay node lan delay

tb-set-node-lan-delay $node0 $lan0 40ms
```

Where:

`node` = The node we are modifying the delay for.

`lan` = Which LAN the node is in that we are affecting.

`delay` = The new node to switch delay (see below).

!!! note

    * This command changes the delay between the node and the switch of the LAN. This is only half of the trip a packet must take. The packet will also traverse the switch to the destination node, possibly incurring additional latency from any delay parameters there.
    * If this command is not used to overwrite the delay, then the delay for a given node to switch link is taken as one half of the delay passed to `make-lan`. Thus in a LAN where no ```tb-set-node-delay``` calls are made, the node-to-node latency will be the latency passed to `make-lan`.
    * The behavior of this command is not defined when used with nodes that are in the same LAN multiple times.
    * Delays of less than 2ms (per trip) are too small to be accurately modeled at this time, and will be silently ignored. As a convenience, a delay of 0ms can be used to indicate that you do not want added delay; the two interfaces will be "directly" connected to each other.

### tb-set-node-lan-bandwidth
```
tb-set-node-lan-bandwidth node lan bandwidth

tb-set-node-lan-bandwidth $node0 $lan0 20Mb
```

Where:

`node` = The node we are modifying the bandwidth for.

`lan` = Which LAN the node is in that we are affecting.

`bandwidth` = The new node to switch bandwidth (see below).

!!! note
    * This command changes the bandwidth between the node and the switch of the LAN. This is only half of the trip a packet must take. The packet will also traverse the switch to the destination node which may have a lower bandwidth.
    * If this command is not used to overwrite the bandwidth, then the bandwidth for a given node to switch link is taken directly from the bandwidth passed to `make-lan`.
    * The behavior of this command is not defined when used with nodes that are in the same LAN multiple times.

### tb-set-node-lan-loss

```
tb-set-node-lan-loss node lan loss

tb-set-node-lan-loss $node0 $lan0 0.05
```

Where:

`node` = The node we are modifying the loss for.

`lan` = Which LAN the node is in that we are affecting.

`loss` = The new node to switch loss (see below).

!!! note
    * This command changes the loss probability between the node and the switch of the LAN. This is only half of the trip a packet must take. The packet will also traverse the switch to the destination node which may also have a loss chance. Thus for packet going to switch with loss chance `A` and then going on the destination with loss chance `B`, the node-to-node loss chance is `(1-(1-A)(1-B))`.
    * If this command is not used to overwrite the loss, then the loss for a given node to switch link is taken from the loss rate passed to the `make-lan` command. If a loss rate of `L` is passed to `make-lan` then the node to switch loss rate for each node is set to `(1-sqrt(1-L))`. Because each packet will have two such chances to be lost, the node-to-loss rate comes out as the desired `L`.
    * The behavior of this command is not defined when used with nodes that are in the same LAN multiple times.

### tb-set-node-lan-params

```
tb-set-node-lan-params node lan delay bandwidth loss

tb-set-node-lan-params $node0 $lan0 40ms 20Mb 0.05
```

Where:

`node` = The node we are modifying the loss for.

`lan` = Which LAN the node is in that we are affecting.

`delay` = The new node to switch delay.

`bandwidth` = The new node to switch bandwidth.

`loss` = The new node to switch loss.

!!! note
    This command is exactly equivalent to calling each of the above three commands appropriately. See above for more information.

### tb-set-link-simplex-params

```
tb-set-link-simplex-params link src delay bw loss

tb-set-link-simplex-params $link1 $srcnode 100ms 50Mb 0.2
```

Where:

`link` = The link we are modifying.

`src` = The source, defining which direction we are modifying.

`delay` = The source to destination delay.

`bw` = The source to destination bandwidth.

`loss` = The source to destination loss.

!!! note
    * This commands modifies the delay characteristics of a link in a single direction. The other direction is unchanged.
    * This command only applies to links. Use ```tb-set-lan-simplex-params``` below for LANs.

### tb-set-lan-simplex-params

```
tb-set-lan-simplex-params lan node todelay tobw toloss fromdelay frombw fromloss

tb-set-lan-simplex-params $lan1 $node1 100ms 10Mb 0.1 5ms 100Mb 0
```

Where:

`lan` = The lan we are modifying.

`node` = The member of the lan we are modifying.

`todelay` = Node to lan delay.

`tobw` = Node to lan bandwidth.

`toloss` = Node to lan loss.

`fromdelay` = Lan to node delay.

`frombw` = Lan to node bandwidth.

`fromloss` = Lan to node loss.

!!! note
    This command is exactly like ```tb-set-node-lan-params``` except that it allows the characteristics in each direction to be chosen separately. See all the notes for ```tb-set-node-lan-params```.

### tb-set-endnodeshaping 

````
tb-set-endnodeshaping link-or-lan enable

tb-set-endnodeshaping $link1 1
tb-set-endnodeshaping $lan1 1
````

Where:

`link-or-lan` = The link or LAN we are modifying.

`enable` = Set to 1 to enable, 0 to disable.

!!! note
    * This command specifies whether <a href="/core/link-delays/">end node shaping</a> is used on the specified link or LAN (instead of a delay node).
    * Disabled by default for all links and LANs.
    * Only available when running the standard DETERLab FreeBSD or Linux kernels.
    * See <a href="/core/link-delays/">End Node Traffic Shaping and Multiplexed Links</a> for more details.

### tb-set-noshaping

```
tb-set-noshaping link-or-lan enable

tb-set-noshaping $link1 1
tb-set-noshaping $lan1 1
```

Where:

`link-or-lan` = The link or LAN we are modifying.

`enable` = Set to 1 to disable bandwidth shaping, 0 to enable.


!!! note
    * This command specifies whether link bandwidth shaping should be enforced on the specified link or LAN. When enabled, bandwidth limits indicated for a link or LAN will not be enforced.
    * Disabled by default for all links and LANs. That is, link bandwidth shaping `is` enforced on all links and LANs by default.
    * If the delay and loss values for a ```tb-set-noshaping``` link are zero (the default), then no delay node or end-node delay pipe will be associated with the link or LAN.
    * **This command is a hack.** The primary purpose for this command is to subvert the topology mapper (`assign`). `Assign` always observes the physical bandwidth constraints of the testbed. By using ```tb-set-noshaping```, you can convince `assign` that links are low-bandwidth and thus get your topology mapped, but then not actually have the links shaped.

### tb-use-endnodeshaping

```
tb-use-endnodeshaping enable

tb-use-endnodeshaping 1
```

Where:

`enable` = Set to 1 to enable end-node traffic shaping on all links and LANs.

!!! note
    * This command allows you to use end-node traffic shaping globally, without having to specify per link or LAN with ```tb-set-endnodeshaping```.
    * See <a href="/core/linkdelays/">End Node Traffic Shaping and Multiplexed Links</a> for more details.

### tb-force-endnodeshaping 

```
tb-force-endnodeshaping enable

tb-force-endnodeshaping 1
```

Where:

`enable` = Set to 1 to force end-node traffic shaping on all links and LANs.


!!! note
    * This command allows you to specify non-shaped links and LANs at creation time, but still control the shaping parameters later (e.g., increase delay, decrease bandwidth) after the experiment is swapped in.
    * This command forces allocation of end-node shaping infrastructure for all links. There is no equivalent to force delay node allocation.
    * See <a href="/core/linkdelays/">End Node Traffic Shaping and Multiplexed Links</a> for more details.

### tb-set-multiplexed 

```
tb-set-multiplexed link allow

tb-set-multiplexed $link1 1
```

Where:

`link` = The link we are modifying.

'allow` = Set to 1 to allow multiplexing of the link, 0 to disallow.


!!! note
    * This command allows a link to be multiplexed over a physical link along with other links.
    * Disabled by default for all links.
    * Only available when running the standard DETER FreeBSD (not Linux) and only for links (not LANs).
    * See <a href="/core/linkdelays/">End Node Traffic Shaping and Multiplexed Links</a> for more details.

### tb-set-vlink-emulation

```
tb-set-vlink-emulation style

tb-set-vlink-emulation $link1 vlan
```

Where:

`style` = One of "vlan" or "veth-ne"

!!! note
    It seems to be necessary to set the virtual link emulation style to vlan for multiplexed links to work under linux.

----

## Virtual Type Commands

Virtual Types are a method of defining fuzzy types, i.e. types that can be fulfilled by multiple different physical types. The advantage of virtual types, also known as `'vtypes`', is that all nodes of the same vtype will usually be the same physical type of node. In this way, vtypes allows logical grouping of nodes.

As an example, imagine we have a network with internal routers connecting leaf nodes. We want the routers to all have the same hardware, and the leaf nodes to all have the same hardware, but the specifics do not matter. We have the following fragment in our NS file:

```
...
tb-make-soft-vtype router {pc600 pc850}
tb-make-soft-vtype leaf {pc600 pc850}

tb-set-hardware $router1 router
tb-set-hardware $router2 router
tb-set-hardware $leaf1 leaf
tb-set-hardware $leaf2 leaf
```

Here we have set up two soft (see below) vtypes: router and leaf. Our router nodes are then specified to be of type `router`, and the leaf nodes of type `leaf`. When the experiment is swapped in, the testbed will attempt to make router1 and router2 be of the same type, and similarly, leaf1 and leaf2 of the same type. However, the routers/leafs may be pc600s or they may be pc850s, whichever is easier to fit in to the available resources.

As a basic use, vtypes can be used to request nodes that are all the same type, but can be of any available type:

```
...
tb-make-soft-vtype N {pc600 pc850}

tb-set-hardware $node1 N
tb-set-hardware $node2 N
```

Vtypes come in two varieties: hard and soft. 
* `'Soft`' - With soft vtypes, the testbed will try to make all nodes of that vtype the same physical type, but may do otherwise if resources are tight. 
* `'Hard`' - Hard vtypes behave just like soft vtypes except that the testbed will give higher priority to vtype consistency and swapping in will fail if the vtypes cannot be satisfied. 

Therefore, if you use soft vtypes you are more likely to swap in but there is a chance your node of a specific vtype will not all be the same. If you use hard vtypes, all nodes of a given vtype will be the same, but swapping in may fail.

Further, you can have weighted soft vtypes. Here you assign a weight from 0 to 1 exclusive to your vtype. The testbed will give higher priority to consistency in the higher weighted vtypes. The primary use of this is to rank multiple vtypes by importance of consistency. Soft vtypes have a weight of 0.5 by default.

As a final note, when specifying the types of a vtype, use the most specific type possible. For example, the following command is not very useful: 

```
tb-make-soft-vtype router {pc pc600}
```

This is because pc600 is a sub type of pc. You may very well end up with two routers as type pc with different hardware, as pc covers multiple types of hardware.

### tb-make-soft-vtype ###

```
tb-make-soft-vtype vtype {types}
tb-make-hard-vtype vtype {types}
tb-make-weighted-vtype vtype weight {types}

tb-make-soft-vtype router {pc600 pc850}
tb-make-hard-vtype leaf {pc600 pc850}
tb-make-weighted-vtype A 0.1 {pc600 pc850}
```

Where:

`vtype` = The name of the vtype to create.

`types` = One or more physical types.

`weight` = The weight of the vtype, 0 < `weight` < 1.


!!! note
    * These commands create vtypes. See notes above for a description of vtypes and the difference between soft and hard.
    * ```tb-make-soft-vtype``` creates vtypes with weight 0.5.
    * vtype commands must appear before ```tb-set-hardware``` commands that use them.
    * Do not use ```tb-fix-node``` with nodes that have a vtype.

## Misc. Commands ##

### tb-fix-node ###

```
tb-fix-node vnode pnode

tb-fix-node $node0 pc42
```

Where:

`vnode` = The node we are fixing.

`pnode` = The physical node we want used.


!!! note
    * This command forces the virtual node to be mapped to the specified physical node. Swap in will fail if this cannot be done.
    * Do not use this command on nodes that are a virtual type.

### tb-fix-interface 

```
tb-fix-interface vnode vlink iface 

tb-fix-interface $node0 $link0 "eth0"
```

Where:

`vnode` = The node we are fixing.

`vlink` = The link connecting to that node that we want to set.

`iface` = The DETERLab name for the interface that is to be used.

!!! note
    * The interface names used are the ones in the DETERLab database - we can make no guarantee that the OS image that boots on the node assigns the same name.
    * Different types of nodes have different sets of interfaces, so this command is most useful if you are also using ```tb-fix-node``` and/or ```tb-set-hardware``` on the `vnode`.

### tb-set-uselatestwadata 

```
tb-set-uselatestwadata 0
tb-set-uselatestwadata 1
```

!!! note
    * This command indicates which widearea data to use when mapping widearea nodes to links. The default is 0, which says to use the aged data. Setting it to 1 says to use the most recent data.

### tb-set-wasolver-weights

```
tb-set-wasolver-weights delay bw plr

tb-set-wasolver-weights 1 10 500
```

Where:

`delay` = The weight to give delay when solving.

`bw` = The weight to give bandwidth when solving.

`plr` = The weight to give lossrate when solving.


!!! note
    * This command sets the relative weights to use when assigning widearea nodes to links. Specifying a zero says to ignore that particular metric when doing the assignment. Setting all three to zero results in an essentially random selection.

### tb-set-node-failure-action 

```
tb-set-node-failure-action node action

tb-set-node-failure-action $nodeA "fatal"
tb-set-node-failure-action $nodeB "nonfatal"
```

Where:

`node` = The node name.

`action` = One of "fatal" or "nonfatal".


!!! note
    This command sets the failure mode for a node. When an experiment is swapped in, the default action is to abort the swapin if any nodes fail to come up normally. This is the "fatal" mode. You may also set a node to "nonfatal" which will cause node bootup failures to be reported, but otherwise ignored during swapin. Note that this can result in your experiment not working properly if a dependent node fails, but typically you can arrange your software to deal with this.