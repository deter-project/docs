# Using Your Nodes

## Know your DETER servers
Here are the most important things to know.

 * `www.isi.deterlab.net` is the primary web interface for the testbed.
 * `users.deterlab.net` is the host through which the testbed nodes are accessed and it is primary file server.
 * `scratch` is the local package mirror for CentOS, Ubuntu, and FreeBSD.


## Hostnames for your nodes

We set up names for your nodes in DNS and `/etc/hosts` files for use on the nodes in the experiment. Since our nodes have multiple interfaces (the control network, and, depending on the experiment, possibly several experimental interfaces) determining which name refers to which interface can be somewhat confusing. The rules below should help you figure this out.

  * **From users.deterlab.net** - We set up names in the form of `node.expt.proj.isi.deterlab.net` in DNS, so that they are visible anywhere on the Internet. This name always refers to the node's control network interface, which is the only one reachable from `users.deterlab.net`. You can use `node.expt.proj` as a shorthand.
  * **On the nodes themselves** - There are three basic ways to refer to the interfaces of a node. The first is stored in DNS, and the second two are stored on the node in the `/etc/hosts` file.
    1. *Fully-qualified hostnames* - These names are the same ones visible from the outside world, and referred to by attaching the full domain name: ie. `node.expt.proj.isi.deterlab.net`. (Note that, since we put *.isi.deterlab.net* in the nodes' domain search paths, you can use `node.expt.proj` as a shorthand.) This name always refers to the control network.
    1. *node-link form* - You can refer to an individual experimental interface by suffixing it with the name of the link or LAN (as defined in your NS file) that it is a member of. For example, `nodeA-link0` or `server-serverLAN`. This is the preferred way to refer to experimental interfaces, since it uniquely and unambiguously identifies an interface.
    1. *Short form* - If a node is directly connected to the node you're on, you can refer to that node simply with its name (eg. `nodeA`.) Note that this differs from the fully- qualified name in that no domain is given. We also create short names for nodes you are not directly connected to. However, if two nodes are connected with more than one interface, or there is more than one route between them, there is no guarantee that the short name has been associated with the one is on the best (ie. shortest or highest bandwidth) path - so, if there is ambiguity, we strongly suggest that you use the *node-link* form.

!!! note
    It is a bad idea to pick virtual node names in your topology that clash with the physical node names in the testbed, such as "pc45".

## Logging into your Node

  By the time you receive the email message listing your nodes, the DETER configuration system will have ensured that your nodes are fully configured and ready to use. If you have selected one of the DETER-supported operating system images <a href="/core/os-images/">see supported images</a>), this configuration process includes:
    * loading fresh disk images so that each node is in a known clean state;
    * rebooting each node so that it is running the OS specified in the NS script;
    * configuring each of the network interfaces so that each one is "up" and talking to its virtual LAN (VLAN);
    * creating user accounts for each of the project members;
    * mounting the projects NFS directory in /proj so that project files are easily shared amongst all the nodes in the experiment;
    * creating a /etc/hosts file on each node so that you may refer to the experimental interfaces of other nodes by name instead of IP number;
    * configuring all of the delay parameters;
    * configuring the serial console lines so that project members may access the console ports from users.deterlab.net.

As this point you may log into any of the nodes in your experiment. You will need to use <a href="/core/DETERSSH/">Secure Shell (ssh)</a> to log into `users.deterlab.net`
Your login name and password will be the same as your Web Interface login and password.  

!!! note
    Although you can log into the web interface using your email address instead of your login name, you must use your login name when logging into `users.deterlab.net`.

Once logged into users you can then SSH to your nodes.  You should use the `qualified name' from the nodes mapping table so that you do not form dependencies on any particular physical node.  For more information on using SSH with DETER, please take a look at the <a href="/core/DETERSSH/">DETER SSH</a> wiki page.

## How do I install software onto my node?

Each <a href="/core/os-images/">supported operating system</a> has packages mirrored on a host called scratch and each operating system is configured to use this system to fetch packages from.  Information for specific operating systems is documented there.

## How do I copy files onto my node?

Your home directory on users is automatically mounted via NFS on every node in your experiment.  As are your project directory in `/proj` and a special filesystem called `/share`.

## I need **root** access!

If you need to customize the configuration, or perhaps reboot nodes, you can use the "sudo" command, located in `/usr/local/bin` on FreeBSD and `/usr/bin` Linux. All users are added to the Administrators group on <a href="/core/windows/">Windows XP</a> nodes. Our policy is very liberal; you can customize the configuration in any way you like, provided it does not interfere with the operation of the testbed. As as example, to reboot a node that is running FreeBSD:

  	/usr/local/bin/sudo reboot

Also, every testbed node has an automatically generated root password.  Simply click on a node in the "Reserved Nodes" for your experiment and look at the `root_password` attribute.

## <a name="SerialConsole"></a>Can I access the nodes console?

Yes. Each of the PCs has its own serial console line connected to a <a href="/core/dell-serial-console/">serial server</a>.  You can connect to a nodes serial console through the `users` machine, using our `console` program located in '/usr/testbed/bin'. For example, to connect over serial line to "pc001" in your experiment, SSH into `users.deterlab.net`, and then type `console pc001` at the Unix prompt. You may then interact with the serial console (hit "enter" to elicit output from the target machine).

To exit the console program, type `Ctrl-]`; it's just a telnet session.

In any case, all console output from each node is saved so that you may look at it it later. For each node, the console log is stored as `/var/log/tiplogs/pcXXX.run`. This *run* file is created when nodes are first allocated to an experiment, and the Unix permissions of the run files permit only members of the project to view them. When the nodes are deallocated, the run files are cleared, so if you want to save them, you must do so before terminating the experiment.

In addition, you can view the console logs from the web interface, on the Show Experiment page. Of course, you may not interact with the console, but you can at least view the current log.

Escape codes for Dell serial consoles are documented <a href="/core/dell-serial-console/">here</a>.
  
## My node is wedged!

Power cycling a node is easy since every node on the testbed is connected to a power controller.  If you need to power cycle a node, log on to users.deterlab.net and use the "node_reboot" command:

  	node_reboot <node> [node ... ]

where `node` is the physical name, as listed in the node mapping table. You may provide more than one node on the command line. Be aware that you may power cycle only nodes in projects that you are member of. Also, `node_reboot` does its very best to perform a clean reboot before resorting to cycling the power to the node. This is to prevent the damage that can occur from constant power cycling over a long period of time. For this reason, `node_reboot` may delay a minute or two if it detects that the machine is still responsive to network transmission. In any event, please try to reboot your nodes first (see above).
You may also reboot all the nodes in an experiment by using the `-e` option to specify the project and experiment names. For example:

  	node_reboot -e testbed,multicast

will reboot all of the nodes reserved in the "multicast" experiment in the "testbed" project. This option is provided as a shorthand method for rebooting large groups of nodes.
   
## I want to load a fresh operating system on my node ##

Scrogging your disk is certainly not as common, but it does happen. You can either swap your experiment out and then back in (which will allocate another group of nodes), or if you prefer you can reload the disk image yourself. You will of course lose anything you have stored on that disk; it is a good idea to store only data that can be easily recreated, or else store it in your project directory in `/proj`. 

Reloading your disk with a fresh copy of an image is easy, and requires no intervention by DETER staff:

  	os_load [-i ImageName] [-p Project] <node> [node ... ]

If you do not specify an image name, the default image for that node type will be loaded (typically Ubuntu1004-STD).  For testbed wide images, you do not have to specify a project.  The os_load command will wait (not exit) until the nodes have been reloaded, so that you do not need to check the console lines of each node to determine when the load is done.

For example, to load the image 'testpc167' which is in the project 'DeterTest' onto pc167, we type:

	users > os_load -i testpc167 -p DeterTest pc167
	osload (pc167): Changing default OS to [OS 998: DeterTest,testpc167]
	osload: Updating image signature.
	Setting up reload for pc167 (mode: Frisbee)
	osload: Issuing reboot for pc167 and then waiting ...
	reboot (pc167): Attempting to reboot ...
	reboot (pc167): Successful!
	reboot: Done. There were 0 failures.
	reboot (pc167): child returned 0 status.
	osload (pc167): still waiting; it has been 1 minute(s)
	osload (pc167): still waiting; it has been 2 minute(s)
	osload (pc167): still waiting; it has been 3 minute(s)
	osload (pc167): still waiting; it has been 4 minute(s)
	osload: Done! There were 0 failures.
	users >

## I only want certain types of nodes for my experiment

The NS command **tb-set-hardware** only lets you pick one type of hardware.  If you are fine with a couple of different kinds of hardware, say you just want nodes that are at ISI part of the testbed, you can define a virtual node type in your NS file.  For more information on virtual types, please refer to the <a href="/core/ns-commands/#virtual-type-commands">Virtual Type Commands</a> section of the NS command reference.  Here is a quick example:

	tb-make-soft-vtype ISI {pc2133 pc3000 pc3060 pc3100} 
	tb-make-soft-vtype UCB {bpc2133 bpc3000 bpc3060}

	tb-set-hardware $atISI ISI
	tb-set-hardware $atUCB UCB
