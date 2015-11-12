[[TOC]]

#!html
	<p style="text-align: center; background-color: #fcf8e3; font-weight: bold;">
	IMPORTANT: This page is outdated. Updated information is coming soon.
	</p>
	

It is important to understand how DETER is setup in order to properly use the testbed.  We will start with a rather busy overview of how the network is setup at DETER.  

# Operational Network Diagram

[[Image(wiki:DETERTopology:Infrastructure.png, 800px)]]

## Networks

### Control Network

This is a special network for testbed nodes.  Each node is assigned an IP address on this network.  All network booting, filesystem traffic, imaging traffic, and user interaction goes over this network.

[[Image(control.png)]]

A picture of two of our control network switches.

### Experimental Network

All network interfaces aside from the control network interface are connected into the experimental network.  This network is dynamically configured.

[[Image(experimental network.png)]]

## Control Hardware Network

Switches and power controllers are accessed, typically via SNMP, over this network.

## The transparent ISI to UCB Connection

Since DETER is actually in two different locations (see [wiki:ISIUCB ISI and UCB]), we need a way to make them appear as a single testbed.  In order to accomplish this, we have a pair of transparent bridges, one for experimental traffic and another for control traffic, at both sites connected by a 1Gbit high performance network link.

[[Image(gateways.png)]]

bgwe and bgwc, the control and experimental gateways at ISI.

## Servers and Network equipment

### Boss #boss

boss.isi.deterlab.net is the main testbed server it is the brains of the operation.  Testbed users are not allowed to 
log into boss.  Here are a few of the things boss does:

* Runs the web interface for the testbed as www.isi.deterlab.net.
* Runs the database for the testbed.
* Serves operating system images and acts as a network boot server for testbed nodes.
* Maps NS files to physical switches.

### Users #users

users.isi.deterlab.net is our file server and serves as a shell host for testbed users.

[[Image(boss and users.png)]]

Gatekeeper, router, boss, and users.

### Router #router

Router is pretty much transparent.  It does run a firewall that prevents testbed nodes from accessing boss and users in 
ways that are prohibited (for example, you can ssh from users to a testbed node, but not the other way around).

### Testbed Nodes

A node is a machine that is available for allocation by experimenters.  We currently have around 400 nodes for experimental use.  These nodes are split pretty evenly between [wiki:ISIUCB ISI and UCB].

[[Image(pc3000.png)]]

Here is an image of some of the pc3000 class machines at [wiki:ISIUCB ISI].

### Gatekeeper #gatekeeper

Gatekeeper is a bridging firewall.  It protects the internet facing side of the testbed and serves as a NAT machine for the Private Internet Network.

### Scratch #scratch

Scratch serves as our local Ubuntu, CentOS, and FreeBSD mirror.  All supported operating system images should be configured to fetch packages from scratch.

[[Image(scratch.png)]]

scratch

## Serial Console Servers #serialserver

Each node is setup to use the serial port as the console.  This allows testbed users to easily get on the console of a node by logging into users.

[[Image(serial.png)]]

Here is one of our serial servers.  It consists of an older IBM X330 server with a Cyclades serial controller.  The beige
boxes are chained off this controller giving the machine a very large number of serial ports.

## Power Controllers #powercontroller

Each node is connected to a power controller which in turn is connected to the control network.  This allows you to power cycle a node if it becomes stuck.  

[[Image(APC.png)]]

One of the power controllers we use is the APC 7902.



