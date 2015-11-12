[[TOC]]

This page documents the January 2011 demo.

Ted and Mike are rehashing the CATCH demo to demonstrate some of the new virtualization infrastructure. We will embed processes inside qemu virtual machines inside physical machines.

# The Demo

q9bot and the IRC server(s) will run inside processes embedded in qemu virtual machines. The intermediate routers on the network will probably be inside processes as well. The target machine may be a process, virtual machine, or physical machine.


# New Virtualization Containers

## QEMU virtual machine

This is very similar to an OpenVZ virtual machines. It runs a very vanilla Ubuntu 10.10 without most of the usual testbed facilities.

* Ordinary control interface
* Normal testbed file systems (/home, /proj, /groups, /share)
* Testbed user accounts
* *No TMCD support*
  * None of the files in /var/emulab/boot

It is hosted by a physical node running Ubuntu1004-STD. The only major change to the host node is that the control interface is bridged with the control interfaces of the vnodes it contains.

## Processes

This is an extremely lightweight container.

* Has a full network stack
* Access to all the file systems on the pnode/vnode that hosts it
* *No control interface*
* *No TMCD*

A process can be embedded inside a physical machine or a virtual machine ([yo dawg!](http://i.imgur.com/F63mB.jpg)).

## Virtual vs. Physical Topology

It is useful to make a distinction between physical topo and virtual topo (ptopo and vtopo). The vtopo is the network topology as presented to the experimenter. It is some interconnected network of processes, virtual machines, and physical machines that all talk to each other over IP and form an experiment. The ptopo is the network of physical and virtual machines that host virtual elements. The ptopo should be invisible to the experiment.

Example: a vtopo containing two processes and a qemu virtual machine in a LAN. This can be physically (ptopo) realized in the following ways:

* One pnode vhost which runs the processes and virtual machine
* One pnode vhost running two vnodes, one is the virtual machine and the other is a vhost which runs the processes
* Two pnode vhosts, one running the virtual machine and another hosting the processes
  * The virtual LAN between the vnode and the processes is realized in a UDP multicast socket between the vhosts on the emulab experiment network

In all three cases the vtopo is the same but the ptopo varies.

# SEER support

The biggest issue we face is that we have some machines which are vhosts and others which need to be presented in the vtopo.

## pnodes

The physical machines hosting qemu should be a small effort; they run ordinary Ubuntu1004-STD images. Most (all?) of these will be vhosts.

As noted above, the control interface is replaced with a bridged interface (named control0).

## vnodes

The qemu machines will need some work. SEER depends on some of the files in /var/emulab/boot. We will probably want packet counter support in these.

Most/all of these nodes will be vhosts. Some may be ordinary vtopo elements.

## processes

These guys are strange. It doesn't make sense to run a separate daemon as a part of the process, so I imagine these elements will piggy-back on the SEER running in the vnode/pnode hosting them. As they have access to the host file system, they can write to files/pipes/etc that the SEER daemon watches. I can instrument further communication mechanisms if desired.

If necessary we can run a separate SEER process in the virtualized environment. This will necessitate adding a control interface. It can be done for this demo, but keep in mind that we intend to eventually support virtualized environments in which this does not make sense.
