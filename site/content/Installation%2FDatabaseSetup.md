[[TOC]]

# Setting up your Switch

## Location for Setup

All the configuration on this page takes place on the *boss_' node. Boss hosts the MySQL database that the testbed uses and the default database name is '_tbdb*.  You should be able to connect to the database simply by logging into boss and doing:

	
	[deterbuild@boss ~]$ mysql tbdb
	Reading table information for completion of table and column names
	You can turn off this feature to get a quicker startup with -A
	
	Welcome to the MySQL monitor.  Commands end with ; or \g.
	Your MySQL connection id is 58266
	Server version: 5.5.29-log Source distribution
	
	Copyright (c) 2000, 2012, Oracle and/or its affiliates. All rights reserved.
	
	Oracle is a registered trademark of Oracle Corporation and/or its
	affiliates. Other names may be trademarks of their respective
	owners.
	
	Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
	
	mysql>
	

## Adding your switch to DNS

Your switch needs a name that resolves.  You must add it either to /etc/hosts or to the name server running on boss.

To add it to the name server, add it into /etc/namedb/<yoursitename>.internal.db.head.  
You then refresh the DNS server by running /usr/testbed/sbin/named_setup.  

For example, on mini-isi.deterlab.net we have our switch that we will name hp1 at 192.168.254.1 on the HARDWARE_CONTROL network.  So we add it to DNS as follows:

	
	[jhickey@boss ~]$ sudo su -
	boss# echo "hp1    IN A 192.168.254.1" >> /etc/namedb/mini-isi.deterlab.net.internal.db.head 
	boss# logout
	[jhickey@boss ~]$ /usr/testbed/sbin/named_setup 
	[jhickey@boss ~]$ ping -c 1 hp1
	PING hp1.mini-isi.deterlab.net (192.168.254.1): 56 data bytes
	64 bytes from 192.168.254.1: icmp_seq=0 ttl=63 time=3.496 ms
	
	--- hp1.mini-isi.deterlab.net ping statistics ---
	1 packets transmitted, 1 packets received, 0.0% packet loss
	round-trip min/avg/max/stddev = 3.496/3.496/3.496/0.000 ms
	[jhickey@boss ~]$ 
	


## Adding in your switches to the database

Using the hostname you have given your switch, insert a line in the the nodes table in the database.   If you are connecting both experimental and control ports to your switch, the role should be ‘testswitch.’  This will be the most common setting for small sites.  If you are using dedicated control network switches and separate experimental switches, the control network switches should be set to ‘ctrlswitch’ and the experimental switches should be set to ‘testswitch’.  If you are unsure what all this is about, please reread the [wiki:Hardware Network Switches section of the Hardware page].

Also, make sure the type is in the database.  Please contact us if your switch is not similar to a hp2810 or hp5412.  For example, use hp5412 if you actually have a HP 5406, since the management firmware is the same.

	
	insert into nodes set node_id='hp1',phys_nodeid='hp1',type='hp2810',role='testswitch';
	

## Switch Interconnects

If your installation has more than one switch, we need to tell the database about it so that vlan trunking can be enabled and so that it doesn't try to oversubscribe the link.  We created interface types earlier in this document.  Let's say we have hp1 and hp2 which are connected by a single 1GbE link.  hp2 module A, port 5 is connected to hp1 module B, port 23.  We need to add two lines to the interfaces table (note that current_speed is in Mbits now):

	
	insert into interfaces set
	          node_id='hp1',card=2,port=23,mac='000000000000',iface='B/23',role='other',
	          current_speed='1000',interface_type='trunk_1GbE',uuid=UUID();
	insert into interfaces set
	          node_id='hp2',card=1,port=5,mac='000000000000',iface='A/5',role='other',
	          current_speed='1000',interface_type='trunk_1GbE',uuid=UUID();
	

We also need to add an entry to the wires table for these two switches:

	
	insert into wires set
	          node_id1='hp1',card1=2,port1=23,
		  node_id2='hp2',card2=1,port2=5,
	          type='Trunk';
	

Also, make sure to set the interface state to up and trunked:

	
	insert into interface_state set
	        node_id='hp1', card=2, port=23,
	        iface='B/23', enabled=1, tagged=1;
	
	insert into interface_state set
	        node_id='hp2', card=1, port=5,
	        iface='A/5', enabled=1, tagged=1;
	

*Note:* For switches that are not modular, set card to 1.  For Ethernet interfaces, card starts at (and typically is) 0.

## Setting up Switch Stacks

The idea of switch stacks comes from sites that run separate control and experimental networks.  In this scenario, it does not make sense to create experimental vlans on switches that function only as control network switches and vice versa.  The typical DETER deployment scenario will be a switch that handles both.  In this case, we add the same switch to the two different stacks ('Experiment' and 'Control' which we also have to setup in switch_stack_types).  We also make sure that is_primary is set to 1 for the Experimental stack line and 0 for the Control stack line (I assume so that we only try creating vlans once per switch).

First, create our switch_stack_types.  For our mini-isi setup, we have the two types:

	
	insert into switch_stack_types (stack_id, stack_type, snmp_community, min_vlan, max_vlan, leader) values ('Control', 'generic', 'private', 2, 997, 'hp1');
	insert into switch_stack_types (stack_id, stack_type, snmp_community, min_vlan, max_vlan, leader) values ('Experiment', 'generic', 'private', 2, 997, 'hp1');
	

So in our mini-isi example, we need to add in two entries for our switch hp1:

	
	insert into switch_stacks (node_id,stack_id,is_primary) 
	values 
	('hp1','Experiment',1),
	('hp1','Control',0);
	

## Testing your switch stack

On boss, run *wap snmpit -l -l* to list all vlans.  For example, your output should look something like this (right now there might be some MIB warnings):

	
	
	[jhickey@boss ~]$ wap snmpit -l -l
	VLAN     Project/Experiment VName     Members
	--------------------------------------------------------------------------------
	CONTROLH                    CONTROLHW hp1.1/3 hp1.1/4 hp1.1/5
	CONTROL                     CONTROL   hp1.1/3 hp1.1/6 hp1.1/7 hp1.1/8 hp1.1/9
	                                      hp1.1/10 hp1.1/11 hp1.1/12
	INTERNET                    INTERNET  hp1.1/1 hp1.1/2 hp1.1/3
	BOSS                        BOSS      hp1.1/3
	[jhickey@boss ~]$
	


# Setting up your power controller

## Adding the power controller to DNS

This is pretty much the same as with the switch above.  Technically, you can get away without this step since the IP address will also be in the database, but it is good housekeeping.

For example, on mini-isi.deterlab.net we have our switch that we will name apc1 at 192.168.254.10 on the HARDWARE_CONTROL network (the IP address isn't important, just that the APC is on hardware control network).  So we add it to DNS as follows:

	
	[jhickey@boss ~]$ sudo su -
	boss# echo "apc1    IN A 192.168.254.10" >> /etc/namedb/mini-isi.deterlab.net.internal.db.head
	boss# logout
	[jhickey@boss ~]$ /usr/testbed/sbin/named_setup 
	[jhickey@boss ~]$ ping -c 1 apc1
	PING apc1.mini-isi.deterlab.net (192.168.254.10): 56 data bytes
	64 bytes from 192.168.254.10: icmp_seq=0 ttl=254 time=3.476 ms
	
	--- apc1.mini-isi.deterlab.net ping statistics ---
	1 packets transmitted, 1 packets received, 0.0% packet loss
	round-trip min/avg/max/stddev = 3.476/3.476/3.476/0.000 ms
	

## Adding the power controller to the database

We assume you are using an APC 7902 networked power controller.  The default node_type for this is 'APC'.

Now add in a node entry for the power controller.  For mini-isi, our power controller is named apc1:

	
	insert into nodes set node_id='apc1', phys_nodeid='apc1', type='APC', role='powerctrl';
	

Now add a line to the interfaces table.  For mini-isi, the power controller is at 192.168.254.10:

	
	insert into interfaces set node_id='apc1',
	                           IP='192.168.254.10', mask='255.255.255.0',
	                           interface_type='fxp', iface='eth0', role='other';
	

Now, finally we need a wires table entry:

	
	insert into wires set node_id1='apc1', card1=0, port1=1, 
	                      node_id2='hp1', card2=1, port2=4,
	                      type='Control';
	

## Telling the database about the power controller ports

This is jumping the gun since we have not gotten to the point of adding PC type nodes to the testbed yet, but when we do, they will go in the *outlets* table.

	
	mysql> describe outlets;
	+------------+---------------------+------+-----+-------------------+-------+
	| Field      | Type                | Null | Key | Default           | Extra |
	+------------+---------------------+------+-----+-------------------+-------+
	| node_id    | varchar(32)         | NO   | PRI |                   |       | 
	| power_id   | varchar(32)         | NO   |     |                   |       | 
	| outlet     | tinyint(1) unsigned | NO   |     | 0                 |       | 
	| last_power | timestamp           | NO   |     | CURRENT_TIMESTAMP |       | 
	+------------+---------------------+------+-----+-------------------+-------+
	4 rows in set (0.00 sec)
	

So to add, say pc001 which is on apc1 port 1, we would do:

	
	insert into outlets set node_id='pc001', power_id='apc1', outlet=1;
	

You can add in a dummy entry and test if you like.

# Setting up your serial server

This section is a work in progress.  Here are some notes:

We have VMware images for both DIGI Etherlite serial boxes and IPMI based serial ports.

You will need to make sure that root from your boss node can log into the serial server.  This is so that groups can be added to the group file when new projects are created.  

Copy your ssh keys to the new serial server:

	
	[jhickey@boss.isi.deterlab.net:~] > sudo scp ~root/.ssh/id_rsa.pub root@capture2digi:.ssh/authorized_keys
	

If you have trouble logging in automatically and you are using a CentOS VM, you may have to manually log in and issue:

	
	restorecon -R -v /root/.ssh
	

Test out that you can ssh as root to the serial server VM:

	
	[jhickey@boss.isi.deterlab.net:~] > sudo ssh capture2digi
	Last login: Tue Dec 18 22:07:23 2012 from 192.168.252.1
	[root@capture2digi ~]#
	

Now add the serial server to the database:

	
	[jhickey@boss.isi.deterlab.net:~] > mysql tbdb
	Reading table information for completion of table and column names
	You can turn off this feature to get a quicker startup with -A
	
	Welcome to the MySQL monitor.  Commands end with ; or \g.
	Your MySQL connection id is 15870862
	Server version: 5.0.92-log FreeBSD port: mysql-server-5.0.92
	
	Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
	
	mysql> insert into tipservers set server='capture2digi';
	

# Setting up IPMI

On the main DETER site, all IPMI controllers are placed on a special VLAN 2007.  This VLAN is accessible by only boss and a dedicated console server.  For smaller DETER installations, it is easiest to just use the Control Hardware VLAN for IPMI controllers.  Boss is able to act as the console server and comes pre-configured for direct access to the subnet on VLAN 2004.

## IPMI Nodes

First, IPMI must exist as a type in the node_types table.

	
	insert into node_types set class='power', type='IPMI';
	

Then, each IPMI controller is treated as special node in the database.
Each IPMI controller must be inserted into the nodes table, the interfaces table, and the wires table.  

	
	insert into nodes set node_id='cpc5-ipmi', phys_nodeid='cpc5-ipmi', type='IPMI', role='powerctrl';
	insert into interfaces set node_id='cpc5-ipmi', IP='192.168.254.5', mask='255.255.240.0', mac='002590761bf0',interface_type='fxp', iface='eth0', role='ctrl';
	insert into wires set node_id1='cpc5-ipmi', card1=0, port1=1, node_id2='hp1', card2=1, port2=12, type='Control';
	

You can statically assign IP addresses to your IPMI controllers, or you can try setting up DHCP for them.  For small testbeds, static IP addresses are probably the easiest way to go.
The node type IPMI will have to be added to /usr/local/etc/dhcpd.conf.template and then 'dhcpd_makeconf -ir' should be run.  Also, you will need to make sure that DHCP is being relayed to the CONTROLHW subnet on router.

	
	#
	# IPMI Network
	#
	subnet 192.168.254.0 netmask 255.255.255.0 {
	        option subnet-mask              255.255.255.0;
	        option domain-name-servers      192.168.252.1;
	        option domain-name              "isi.deterlab.net";
	
	        group {
	                %%nodetype=IPMI
	        }
	}
	

Make sure to run /usr/testbed/sbin/named_setup after adding the IPMI nodes to the database and check that their host names resolve and you can ping them.

## IPMI Power Control

In the outlets table, simply use the IPMI node for the associated testbed node. Last_power is left blank when the entries are inserted.

	
	mysql> insert into outlets set node_id='cpc5', power_id='cpc5-ipmi', outlet='1';
	

After the nodes have been active, last_power will be populated.

	
	mysql> select * from outlets where node_id='cpc5'; 
	+---------+-----------+--------+---------------------+
	| node_id | power_id  | outlet | last_power          |
	+---------+-----------+--------+---------------------+
	| cpc5    | cpc5-ipmi |      1 | 2013-01-22 06:01:04 | 
	+---------+-----------+--------+---------------------+
	1 row in set (0.00 sec)
	

Automating the process.  The very simple script *testbed/utils/enumerate_ipmi_macs.py* was used to automate the creation of IPMI nodes and outlet table entries.  It will need to be modified for your site, but should provide an easy starting point.

## IPMI Serial Console

For small sites, you can run ipmitool from boss for serial console.

Customize testbed/capture/capture2ipmi/ipmi2console.sh
Install ipmi2console.sh in /usr/local/etc/rc.d and make sure it is executable.

Add boss into the tipservers table in the database:

	
	insert into tipservers values ('boss');
	

Restart the capserver process:

	
	sudo killall capserver
	sudo /usr/testbed/sbin/capserver
	

Add in the tip lines for your machines:

	
	for i in {1..16} ; do echo "insert into tiplines (tipname, node_id, server) values ('pc$i', 'pc$i', 'boss');" ; done
	

Run

/usr/local/etc/rc.d/ipmi2console.sh start