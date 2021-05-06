# Frequently Asked Questions

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

If you do not specify an image name, the default image for that node type will be loaded (typically Ubuntu1604-STD).  For testbed wide images, you do not have to specify a project.  The os_load command will wait (not exit) until the nodes have been reloaded, so that you do not need to check the console lines of each node to determine when the load is done.

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
