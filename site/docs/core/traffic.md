# Core Guide

In this tutorial we begin with a small 3-5 node experiment, so that you will become familiar with NS syntax and the practical aspects of DETERLab operation. Usually, you will want to incorporate another system such as the
[MAGI Orchestrator](/orchestrator/orchestrator-quickstart/) for more fully fleshed out experiments. But this is a good starting point for those new to DETERLab.

!!! note
    If you are a student, go to the <http://education.deterlab.net> site for classroom-specific instructions.

## Node Use Policy
Please make sure to read our <a href="/usage-policy/">guidelines for using nodes in DETERLab</a>. These guidelines help keep DETERLab an effective environment for all users.


## DETERLab Environment

Your experiment is made up of one or more machines on the internal DETERLab network, which is behind a firewall. 

`users.deterlab.net` (or `users` for short) is the "control server" for DETERLab. From `users`, you can contact all your nodes, reboot them, connect to their serial ports, etc. Each user has a home directory on this server and you may SSH into it with your username and password for your DETERLab account.

`myboss.isi.deterlab.net` ( or `boss` for short) is the main testbed server that runs DETERLab. Users are not allowed to log directly into it.

## Basic Tutorial ##

### Getting Started ###

Work in DETERLab is organized by **experiments** within **projects**. Each project is created and managed by a leader - usually the Principal Investigator (PI) of a research project or the instructor of a class on cybersecurity. The project leader then invites members to join by providing them with the project name and sending them the link to the 'Join a Project' page.

Before you can take the following tutorial, you need an active account in a project in DETERLab. See <a href="https://trac.deterlab.net/wiki/GettingStarted">How to Register</a> to make sure if you're qualified, and then follow the directions to create a project or ask to join an existing project - if you go through either process for the first time, your account is created as a result. 

If you already have an account, proceed to the next step.

### Step 1: Design the topology

Part of DETERLab's power lies in its ability to assume many different topologies; the description of a such a topology is a necessary part
of an experiment.  Before you can start your experiment, you must model the elements of the experiment's network with a topology. 

**For this basic tutorial, use this <a href="/downloads/basic.ns">NS file</a> which includes a simple topology and save it to a directory called *basicExp* in your local directory on `users.deterlab.net`.** 

The rest of this section describes NS format and walks you through the different parts of the sample file.

#### NS Format 

DETERLab uses the "NS" ("Network Simulator") format to describe network topologies. This is substantially the same <a href="http://www.scriptics.com/software/tcltk/">Tcl-based format</a> used by [ns-2](http://www.isi.edu/nsnam/ns/). Since DETERLab offers emulation, rather than simulation, these files are interpreted in a somewhat different manner than ns-2. Therefore, some ns-2 functionality may work differently than you expect, or may not be implemented at all. Please look for warnings of the form: 

    *** WARNING: Unsupported NS Statement!
  	    Link type BAZ, using DropTail!

If you feel there is useful functionality missing, please <a href="https://trac.deterlab.net/wiki/GettingHelp">let us know</a>. Also, some <a href="/core/ns-commands/">testbed-specific syntax</a> has been added, which, with the inclusion of the compatibility module `tb_compat.tcl`, will be ignored by the NS simulator. This allows the same NS file to work on both DETERLab and ns-2, most of the time.

#### NS Example ####

In our example, we are creating a test network which looks like the following:

![Diagram of simple network](/img/abcd.png)

*Figure 1: A is connected to B, and B to C and D with a LAN.*

Here's how to describe this topology:

**Declare a simulator and include a file that allows you to use the special `tb-` commands.**
First off, all NS files start with a simple prologue, declaring a simulator and including a file that allows you to use the special `tb-` commands:

```
  	# This is a simple ns script. Comments start with #.
  	set ns [new Simulator]
        source tb_compat.tcl
```

**Define the 4 nodes in the topology.**
```
  	set nodeA [$ns node]
  	set nodeB [$ns node]
  	set nodeC [$ns node]
  	set nodeD [$ns node]
```

`nodeA` and so on are the virtual names (*vnames*) of the nodes in your topology. When your experiment is swapped in (has allocated resources), they will be assigned to physical node names like *pc45*, probably different ones each time. 

**NOTE:** Avoid vnames that clash with the physical node names in the testbed.**

**Define the link and the LAN that connect the nodes.**

NS syntax permits you to specify the bandwidth, latency, and queue type. Note that since NS can't impose artificial losses like DETERLab can, we use a separate `tb-` command to add loss on a link. For our example, we will define a full speed LAN between B, C, and D, and a shaped link from node A to B.
```
  	set link0 [$ns duplex-link $nodeB $nodeA 30Mb 50ms DropTail]
  	tb-set-link-loss $link0 0.01
  	set lan0 [$ns make-lan "$nodeD $nodeC $nodeB " 100Mb 0ms]
```
In addition to the standard NS syntax above, a number of <a href="/core/ns-commands/">extensions</a> are available in DETERLab that allow you to better control your experiment.

For example, you may specify what Operating System is booted on your nodes. For the versions of FreeBSD, Linux, and Windows we currently support, please refer to the <a href="/core/os-images/">Operating System Images</a> page.

Click <a href="https://www.isi.deterlab.net/showosid_list.php3">List ImageIDs</a> in the DETERLab web interface *Interaction* pane to see the current list of DETERLab-supplied operating systems. By default, our most recent Linux image is selected.
```
  	tb-set-node-os $nodeA FBSD11-STD
  	tb-set-node-os $nodeC Ubuntu1604-STD
  	tb-set-node-os $nodeC WINXP-UPDATE
```

**Enable routing.**

In a topology like this, you will likely want to communicate between all the nodes, including nodes that aren't directly connected, like `A` and `C`. In order for that to happen, we must enable routing in our experiment, so `B` can route packets for the other nodes. 

The typical way to do this is with Static routing. (Other options are detailed in the <a href="#Routing">*Routing* section below</a>).
```
  	$ns rtproto Static
```

**End with an epilogue that instructs the simulator to start.**
```
 	# Go!
  	$ns run
```


### Step 2: Create a new experiment

For this tutorial, we will use the web interface to create a new experiment. You could also use the <a href="/core/deterlab-commands/">DETERLab Shell Commands</a>.

1. Log into <a href="https://www.isi.deterlab.net">DETERLab</a> with your account credentials (see <a href="https://trac.deterlab.net/wiki/GettingStarted">How to Register</a>).
2. Click the *Experimentation* menu item, then click *Begin an Experiment*.
3. Click *Select Project* and choose your project. This is also know as your **project name** or Project ID (PID). This is used as an argument in many commands. Most people will be a member of just one project, and will not have a choice. If you are a member of multiple projects, be sure to select the correct project from the menu. In this example, we will refer to the project as *DeterTest*.
4. Leave the *Group* field set to *Default Group* unless otherwise instructed.
5. Enter the *Name* field with an easily identifiable name for the experiment. The Name should be a single word (no spaces) identifier. For this tutorial, use *basic-experiment*. This is also known as your **experiment name** or Experiment ID (EID) and is used as an argument in many commands.
6. Enter the *Description* field with a brief description of the experiment.
7. In the **Your NS File** field, enter the local path to the basic.ns file you downloaded. This file will be uploaded through your browser when you choose "Submit."
     The rest of the settings depend on the goals of your experiment. In this case, you may simply set the *Idle Swap* field to *1 h* and leave the rest of the settings for *Swapping*, *Linktest Option*, and *BatchMode* at their default for now.
8. Check the *Swap In Immediately* box to start your lab now. If you did not check this box, you would follow the directions for [starting an experiment] to allocate resources later.
9. Click *Submit*.  

After submission, DETERLab will begin processing your request. This process can take several minutes, depending on how large your topology is, and what other features (such as delay nodes and bandwidth limits) you are using. While you are waiting, you may watch the swap in process displayed in your web browser.

Assuming all goes well, you will receive an email message indicating success or failure, and if successful, a listing of the nodes and IP address that were allocated to your experiment.

For the NS file in this example, you should receive a listing that looks similar to this:

```
Experiment: DeterTest/basic-experiment
State: swapped

Virtual Node Info:
ID              Type         OS              Qualified Name
--------------- ------------ --------------- --------------------
nodeA           pc           FBSD11-STD      nodeA.basic-experiment.DeterTest.isi.deterlab.net
nodeB           pc                           nodeB.basic-experiment.DeterTest.isi.deterlab.net
nodeC           pc           Ubuntu1604-STD  nodeC.basic-experiment.DeterTest.isi.deterlab.net
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
```

Here is a breakdown of the results:
    * A single delay node was allocated and inserted into the link between *nodeA* and *nodeB*. This link is invisible from your perspective, except for the fact that it adds latency, error, or reduced bandwidth. However, the information for the delay links are included so that you can modify the delay parameters after the experiment has been created (Note that you cannot convert a non-shaped link into a shaped link; you can only modify the traffic shaping parameters of a link that is already being shaped). [[BR]]
    * Delays of less than 2ms (per trip) are too small to be accurately modeled at this time, and will be silently ignored. A delay of 0ms can be used to indicate that you do not want added delay; the two interfaces will be "directly" connected to each other. [[BR]]
    * Each link in the *Virtual Lan/Link* section has its delay, etc., split between two entries. One is for traffic coming into the link from the node, and the other is for traffic leaving the link to the node. In the case of links, the four entries often get optimized to two entries in a *Physical Lan/Link* section. [[BR]]
    * The names in the *Qualified Name* column refer to the control network interfaces for each of your allocated nodes. These names are added to the DETERLab nameserver map on the fly, and are immediately available for you to use so that you do not have to worry about the actual physical node names that were chosen. In the names listed above, **DeterTest** is the name of the project that you chose to work in, and **basic-experiment** is the name of the experiment that you provided on the *Begin an Experiment* page. [[BR]]
    * Please don't use the *Qualified Name* from within nodes in your experiment, since it will contact them over the control network, bypassing the link shaping we configured.

#### Starting an experiment (Swap-in)

If you want to go back to an existing experiment to start it and swap-in (allocate resources):

1. Go to your dashboard by clicking the *My DETERLab* link in the top menu.
2. In the *Current Experiments* table, click on the EID (Experiment ID) of the experiment you want to start.
3. In the left sidebar, click *Swap Experiment In*, then click *Confirm*. 

The swap in process will take 5 to 10 minutes; you will receive an email notification when it is complete. While you are waiting, you can watch the swap in process displayed in your web browser.


### Step 3: Access nodes in your lab environment

To access your experimental nodes, you'll need to first [SSH](/core/DETERSSH/) into `users.deterlab.net` using your DETERLab username and password.

Once you log in to `users`, you'll need to SSH again to your actual experimental nodes. Since your nodes addresses may change every time you swap them in, it's best to SSH to the permanent network names of the nodes. 

As we mentioned in the previous step, the Qualified Names are included in the output after the experiment is swapped in. Here is another way to find them after swap-in:

a. **Navigate to the experiment you just created in the web interface**.  This location is usually called the *experiment page*.
     * If you just swapped in your experiment, the quickest way to find your node names is to click on the experiment name in the table under *Swap Control*.
     * You can also get there by clicking *My DETERLab* in the top navigation. Your experiment is listed as "active" in the *State* column. Click on the experiment's name in the *EID* column to display the experiment page.. 
b. **Click on the *Details* tab**. 
     * Your nodes' network names are listed under the heading *Qualified Name*. For example, `node1.basic-experiment.DeterTest.isi.deterlab.net`. 
     * You should familiarize yourself with the information available on this page, but for now we just need to know the long DNS qualified name(s) node(s) you just swapped in. 
     * If you are curious, you should also look at the *Settings* (generic info), *Visualization*, and *NS File* tabs. (The topology mapplet may be disabled for some labs, so these last two may not be visible). 
c. **SSH from `users` to your experimental nodes by running a command with the following syntax**: 
```
ssh node1.ExperimentName.ProjectName.isi.deterlab.net
```
     * You will not need to re-authenticate.
     * You may need to wait a few more minutes. Once DETERLab is finished setting up the experiment, the nodes still need a minute or two to boot and complete their configuration. If you get a message about "server configuration" when you try to log in, wait a few minutes and try again.
d. If you need to create new users on your experimental nodes, you may log in as them by running the following from the experimental node:
  ```
  ssh newuser@node1.basicExp.ProjectName.isi.deterlab.net
  ```
  or
  ```
  ssh newuser@localhost
  ```

### Step 4: View results and modify the experiment

You can visualize the experiment by going to your experiment page (from My DETERLab, click the EID link for your experiment) and clicking the *Visualization* tab. From this page you can also change the NS file by clicking on the *NS File* tab or modify parameters by clicking *Modify Traffic Shaping* in the left sidebar.

An alternative method is to log into `users.deterlab.net` and use the <a href="/core/deterlab-commands/#delay_config:ChangethelinkshapingcharacteristicsforalinkorLAN">delay_config</a> program. This program requires that you know the symbolic names of the individual links. This information is available on the experiment page. 

### Step 5: Configure and run your experiment.

Once you have all link modifications to your liking, you now need to install any additional tools you need (tools not included in the OS images you chose in Step 1), configure your tools and coordinate these tools to create events in your experiment.

For simple experiments, installation, configuration and triggering events can be done by hand or through small scripts. To accomplish this, log into your machines (see Step 3), perform the OS-specific steps needed to install and configure your tools, and run these tools by hand or through scripts, such as shell scripts or remote scripts such as Fabric-based scripts <http://www.fabfile.org>.

For more complicated experiments, you may need more automated ways to install and configure tools as well as coordinate events within your experiment. For fine-grained control over events and event triggers, see the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>.

A large part of many experiments is traffic generation: the generation and modulation of packets on experiment links. Tools for such generation include the MAGI Orchestrator and <a href="/core/generating-traffic/">LegoTG</a>, as well as <a href="/core/legacy-tools/#legitimate-traffic-generators">many other possibilities</a>.

### Step 6: Save your work and swap-out (release resources)

When you are done working with your nodes, it is best practice to save your work and swap out the experiment so that other users have access to the physical machines.

#### Saving and securing your files on DETERLab

Every user on DETERLab has a home directory on `users.deterlab.net` which is mounted via NFS to experimental nodes. This means that anything you place in your home directory on one experimental node (or the `users` machine) is visible in your home directory on your other experimental nodes. Your home directory is private and will not be overwritten, so you may save your work in that directory. **However, everything else on experimental nodes is permanently lost when an experiment is swapped out.**

**Remember: Make sure you save your work in your home directory before swapping out your experiment!**

Another place you may save your files would be `/proj/YourProject`. This directory is also NFS-mounted to all experimental nodes, so the same rules apply about writing to it a lot, as for your home directory. It is shared by all members of your project/class.

**Again, on DETERLab, files ARE NOT SAVED between swap-ins. Additionally, experiments may be forcibly swapped out after a certain number of idle hours (or some maximum amount of time).**

You must manually save copies of any files you want to keep in your home directory. Any files left elsewhere on the experimental nodes will be erased and lost forever. This means that if you want to store progress for a lab and come back to it later, you will need to put it in your home directory before swapping out the experiment.

#### Swap Out vs Terminate

**When to Swap Out**
When you are done with your experiment for the time being, make sure you save your work into an appropriate location and then swap out your experiment. Swapping out is the equivalent of temporarily stopping the experiment and relinquishing the testbed resources. Swapping out is what you want to do when you are taking a break from the work, but coming back later. 

To do this, click *Swap Experiment Out* link on the experiment page. This allows the resources to be de-allocated so that someone else can use them.

**When to Terminate**
When you are completely finished with your experiment and have no intention of running it again, use the *Terminate Experiment* link in the sidebar of the experiment page. Be careful: **termination will erase the experiment** and you won't be able to swap it back in without recreating it. DETERLab will then tear down your experiment, and send you an email message when the process is complete. At this point you are allowed to reuse the experiment name (say, if you wanted to create a similar experiment with different parameters).

Terminating says "I won't need this experiment ever again." Just remember to Swap In/Out, and never "Terminate" unless you're sure you're completely done with the experiment. If you do end up terminating an experiment, you can always go back and recreate it.

#### <a name="Halting"></a>Scheduling experiment swapout/termination

If you expect that your experiment should run for a set period of time, but you will not be around to terminate or swap the experiment out, then you should use the scheduled swapout/termination feature. This allows you to specify a maximum running time in your NS file so that you will not hold scarce resources when you are offline. To schedule a swapout or termination in your NS file:
```
     $ns at 2000.0 "$ns terminate"
```
   or
```
     $ns at 2000.0 "$ns swapout"
```

This will cause your experiment to either be terminated or swapped out after 2000 seconds of wallclock time.

## Why can't I log in to DETERLab?
DETERLab has an automatic blacklist mechanism. If you enter the wrong username and password combination too many times, your account will no longer be accessible from your current IP address. 

If you think that this has happened to you, try logging in from another address (if you know how), or create an issue (see <a href="https://trac.deterlab.net/wiki/GettingHelp">Getting Help</a>), which will relay the request to the *testbed-ops* group that this specific blacklist entry should be erased.
  
## Installing RPMs automatically ##

The DETERLab NS extension `tb-set-node-rpms` allows you to specify a (space-separated) list of RPMs to install on each of your nodes when it boots:
```
  tb-set-node-rpms $nodeA /proj/myproj/rpms/silly-freebsd.rpm
  tb-set-node-rpms $nodeB /proj/myproj/rpms/silly-linux.rpm
  tb-set-node-rpms $nodeC /proj/myproj/rpms/silly-windows.rpm
```
The above NS code says to install the `silly-freebsd.rpm` file on `nodeA`, the `silly-linux.rpm` on `nodeB`, and the `silly-windows.rpm` on `nodeC`. RPMs are installed as root, and must reside in either the project's `/proj` directory, or if the experiment has been created in a subgroup, in the `/groups` directory. You may not place your RPMs in your home directory.
   
## Installing TAR files automatically

The DETERLab NS extension <a href="/core/ns-commands/#tb-set-node-tarfiles">tb-set-node-tarfiles</a> allows you to specify a set of tarfiles to install on each of your nodes when it boots. 

While similar to the <a href="/core/ns-commands/#tb-set-node-rpms">tb-set-node-rpms</a> command, the format of this command is slightly different in that you must specify a directory in which to unpack the tar file. This avoids problems with having to specify absolute pathnames in your tarfile, which many modern tar programs balk at.
```
  tb-set-node-tarfiles $nodeA /usr/site /proj/projectName/tarfiles/silly.tar.gz
```
The above NS code says to install the `silly.tar.gz` tar file on `nodeA` from the working directory `/usr/site` when the node first boots. The tarfile must reside in either the project's `/proj` directory, or if the experiment has been created in a subgroup, in the `/groups` directory. You may not place your tarfiles in your home directory. You may specify as many tarfiles as you wish, as long as each one is preceded by the directory it should be unpacked in, all separated by spaces.
   
## Starting your application automatically

You may start your application automatically when your nodes boot for the first time (when an experiment is started or swapped in) by using the `tb-set-node-startcmd` NS extension. The argument is a command string (pathname of a script or program, plus arguments) that is run as the `UID` of the experiment creator, after the node has reached multiuser mode. 

The command is invoked using `/bin/csh`, and the working directory is undefined (your script should `cd` to the directory you need). You can specify the same program for each node, or a different program. For example:
```
  tb-set-node-startcmd $nodeA "/proj/projectName/runme.nodeA"
  tb-set-node-startcmd $nodeB "/proj/projectName/runme.nodeB"
```
will run `/proj/projectName/runme.nodeA` on nodeA and `/proj/projectName/runme.nodeB` on nodeB. The programs must reside on the node's local filesystem, or in a directory that can be reached via NFS. This is either the project's `/proj` directory, in the `/groups` directory if the experiment has been created in a subgroup, or a project member's home directory in `/users`. 

If you need to see the output of your command, be sure to redirect the output into a file. You may place the file on the local node, or in one of the NFS mounted directories mentioned above. For example:
```
     tb-set-node-startcmd $nodeB "/proj/myproj/runme >& /tmp/foo.log"
```
Note that the syntax and function of `/bin/csh` differs from other shells (including bash), specifically in redirection syntax.  Be sure to use `csh` syntax or your start command will fail silently.

The exit value of the start command is reported back to the Web Interface, and is made available to you via the experiment page. There is a listing for all of the nodes in the experiment, and the exit value is recorded in this listing. The special symbol `none` indicates that the node is still running the start command.
   
## Notifying the start program when all other nodes have started

It is often necessary for your start program to determine when all of the other nodes in the experiment have started, and are ready to proceed. Sometimes called a *barrier*, this allows programs to wait at a specific point, and then all proceed at once. DETERLab provides a simple form of this mechanism using a synchronization server that runs on a node of your choice. 

Specify the node in your NS file:

```
    tb-set-sync-server $nodeB
```

When nodeB boots, the synchronization server will automatically start. Your software can then synchronize using the `emulab-sync` program that is installed on your nodes. For example, your node start command might look like this:

```
   #!/bin/sh
   if [ "$1" = "master" ]; then
       /usr/testbed/bin/emulab-sync -i 4
   else
       /usr/testbed/bin/emulab-sync fi /usr/site/bin/dosilly
```

In this example, there are five nodes in the experiment, one of which must be configured to operate as the master, initializing the barrier to the number of clients (four in the above example) that are expected to rendezvous at the barrier. The master will by default wait for all of the clients to reach the barrier. Each client of the barrier also waits until all of the clients have reached the barrier (and of course, until the master initializes the barrier to the proper count). Any number of clients may be specified (any subset of nodes in your experiment can wait). If the master does not need to wait for the clients, you may use the *async* option which releases the master immediately:
```
    /usr/testbed/bin/emulab-sync -a -i 4
```
You may also specify the *name* of the barrier.
```
    /usr/testbed/bin/emulab-sync -a -i 4 -n mybarrier
```

This allows multiple barriers to be in use at the same time. Scripts on nodeA and nodeB can be waiting on a barrier named "foo" while (other) scripts on nodeA and nodeC can be waiting on a barrier named "bar." You may reuse an existing barrier (including the default barrier) once it has been released (all clients arrived and woken up).
   
## <a name="Routing"></a> Setting up IP routing between nodes

As DETER strives to make all aspects of the network controllable by the user, we do not attempt to impose any IP routing architecture or protocol by default. However, many users are more interested in end-to-end aspects and don't want to be bothered with setting up routes. For those users we provide an option to automatically set up routes on nodes which run one of our provided FreeBSD, Linux or <a href="/core/windows/">Windows XP</a> disk images.

You can use the NS `rtproto` syntax in your NS file to enable routing:

```
    $ns rtproto protocolOption
```

where the `protocolOption` is limited to one of *Session*, *Static*, *Static-old*, or *Manual*.

* **Session** routing provides fully automated routing support, and is implemented by enabling `gated` running of the OSPF protocol on all nodes in the experiment. This is not supported on <a href="/core/windows/#Routing">Windows XP</a> nodes.
* **Static** routing also provides automatic routing support, but rather than computing the routes dynamically, the routes are precomputed by a distributed route computation algorithm running in parallel on the experiment nodes.
* **Static-old** specifies use of the older centralized route computation algorithm, precomputing the nodes when the experiment is created, and then loading them onto each node when it boots.
* **Manual** routing allows you to explicitly specify per-node routing information in the NS file. To do this, use the `Manual` routing option to `rtproto`, followed by a list of routes using the `add-route` command:

```
    $node add-route $dst $nexthop
```

where the `dst` can be either a node, a link, or a LAN. For example:

```
    $client add-route $server $router
    $client add-route [$ns link $server $router] $router
    $client add-route $serverlan $router
```

Note that you would need a separate `add-route` command to establish a route for the reverse direction; thus allowing you to specify differing forward and reverse routes if so desired. These statements are converted into appropriate `route(8)` commands on your experimental nodes when they boot.

In the above examples, the first form says to set up a manual route between `$client` and `$server`, using `$router` as the nexthop; `$client` and `$router` should be directly connected, and the interface on `$server` should be unambiguous; either directly connected to the router, or an edge node that has just a single interface.

![Example of routing](/img/routing.png)

If the destination has multiple interfaces configured, and it is not connected directly to the nexthop, the interface that you are intending to route to is ambiguous. In the topology shown to the right, `$nodeD` has two interfaces configured. If you attempted to set up a route like this:
```
    $nodeA add-route $nodeD $nodeB
```

you would receive an error since DETERLab staff would not easily be able to determine which of the two links on `$nodeD` you are referring to. Fortunately, there is an easy solution. Instead of a node, specify the link directly:

```
    $nodeA add-route [$ns link $nodeD $nodeC] $nodeB
```

This tells us exactly which link you mean, enabling us to convert that information into a proper `route` command on `$nodeA`.

The last form of the `add-route` command is used when adding a route to an entire LAN. It would be tedious and error prone to specify a route to each node in a LAN by hand. Instead, just route to the entire network:

```
    set clientlan [$ns make-lan "$nodeE $nodeF $nodeG" 100Mb 0ms]
    $nodeA add-route $clientlan $nodeB
```

In general, it is still best practice to use either *Session* or *Static* routing for all but small, simple topologies. Explicitly setting up all the routes in even a moderately-sized experiment is extremely error prone. Consider this: a recently created experiment with 17 nodes and 10 subnets **required 140 hand-created routes in the NS file**.

Two final, cautionary notes on routing:
    * The default route *must* be set to use the control network interface. You might be tempted to set the default route on your nodes to reduce the number of explicit routes used. **Please avoid this.** That would prevent nodes from contacting the outside world, i.e., you. 
    * If you use your own routing daemon, you must avoid using the control network interface in the configuration. Since every node in the testbed is directly connected to the control network LAN, a naive routing daemon configuration will discover that any node is just one hop away, via the control network, from any other node and *all* inter-node traffic will be routed via that interface.

