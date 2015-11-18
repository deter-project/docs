The following commands are available from the commandline on `users.isi.deterlab.net`. 

!!! note
    Commands should be pre-pended with the path: `/usr/testbed/bin`.

For example, to start an experiment, you would use:
`
/usr/testbed/bin/startexp [options]
`

## Transport Layers

The DETERLab XMLRPC server can be accessed via two different transport layers: SSH and SSL.

**How to use SSH keys**
Follow [these directions](/core/DETERSSH/) if you are unfamiliar with using SSH.

**How to use SSL**
You need to request a certificate from the [DETERLab website](https://www.isi.deterlab.net/index.php3) in order to use the SSL based server. 

* Click the ''My DETERLab'' menu item in the navbar, click the ''Profile'' tab on the page and then click on the ''Generate SSL Certificate'' link. 
* Enter a passphrase to use to encrypt the private key. 
* Once the key has been created, you will be given a link to download a text version (in PEM format). Simply provide this certificate as an input to your SSL client. 

## Operational Commands

### `startexp`: Start an DETERLab experiment <a name="startexp"></a>

```
startexp [-q] [-i [-w]] [-f] [-N] [-E description] [-g gid]
         [-S reason] [-L reason] [-a <time>] [-l <time>]
         -p <pid> -e <eid> <nsfile>
```

**Options:**

`-i` Swapin immediately; by default, the experiment is batched.

`-w` Wait for non-batchmode experiment to preload or swapin.

`-f` Preload experiment (do not swapin or queue yet).

`-q` Be less verbose.

`-S` Experiment cannot be swapped; must provide reason.

`-L` Experiment cannot be IDLE swapped; must provide reason.

`-a` Auto swapout NN minutes after experiment is swapped in.

`-l` Auto swapout NN minutes after experiment goes idle.

`-E` A concise sentence describing your experiment.

`-g` The subgroup in which to create the experiment.

`-p` The project in which to create the experiment.

`-e` The experiment name (unique, alphanumeric, no blanks).

`-N` Suppress most email to the user and testbed-ops.

`nsfile` NS file to parse for experiment

----
### `batchexp`: Synonym for startexp <a name="batchexp"></a>

This is a legacy command. See command description for startexp.

----
### `endexp`: Terminate an experiment <a name="endexp"></a>

```
endexp [-w] [-N] -e pid,eid
endexp [-w] [-N] pid eid
```

**Options:**

`-w`  Wait for experiment to finish terminating.

`-e`  Project and Experiment ID.

`-N`  Suppress most email to the user and testbed-ops.
 

!!! note
    * **Use with caution!** This will tear down your experiment and you will not be able to swap it back in.
    * By default, `endexp` runs in the background, sending you email when the transition has completed. Use the `-w` option to wait in the foreground, returning exit status. Email is still sent.
    * The experiment may be terminated when it is currently swapped in ''or'' swapped out.

----
### `delay_config`: Change the link shaping characteristics for a link or LAN <a name="delay_config"></a>

```
delay_config [options] -e pid,eid link PARAM#value ...
delay_config [options] pid eid link PARAM#value ...
```

**Options:**

`-m` Modify virtual experiment as well as current state.

`-s` Select the source of the link to change.

`-e` Project and Experiment ID to operate on.

`link` Name of link from your NS file (ie: `link1`).

**Parameters:**

`BANDWIDTH#NNN` N#bandwidth (10-100000 Kbits per second)

`PLR#NNN` N#lossrate (0 <# plr < 1)

`DELAY#NNN` N#delay (one-way delay in milliseconds > 0)

`LIMIT#NNN` The queue size in bytes or packets

`QUEUE-IN-BYTES#N` 0 means in packets, 1 means in bytes

**RED/GRED Options:** (only if link was specified as RED/GRED)

`MAXTHRESH#NNN` Maximum threshold for the average Q size

`THRESH#NNN` Minimum threshold for the average Q size

`LINTERM#NNN` Packet dropping probability

`Q_WEIGHT#NNN` For calculating the average queue size

----
### `modexp`: Modify experiment <a name="modexp"></a>

```
modexp [-r] [-s] [-w] [-N] -e pid,eid nsfile
modexp [-r] [-s] [-w] [-N] pid eid nsfile
```

**Options:**

`-w` Wait for experiment to finish swapping.

`-e` Project and Experiment ID.

`-r` Reboot nodes (when experiment is active).

`-s` Restart event scheduler (when experiment is active).

`-N` Suppress most email to the user and testbed-ops

!!! note
    * By default, `modexp` runs in the background, sending you email when the transition has completed. Use the `-w` option to wait in the foreground, returning exit status. Email is still sent.
    * The experiment can be either swapped in ''or'' swapped out.
        * If the experiment is swapped out, the new NS file replaces the existing NS file (the virtual topology is updated). 
        * If the experiment is swapped in (active), the physical topology is also updated, subject to the `-r` and `-s` options above.


----
### `swapexp`: Swap experiment in or out <a name="swapexp"></a>

```
swapexp -e pid,eid in|out
swapexp pid eid in|out
```

**Options:**

`-w` Wait for experiment to finish swapping.

`-e` Project and Experiment ID.

`-N` Suppress most email to the user and testbed-ops.

`in` Swap experiment in  (must currently be swapped out).

`out` Swap experiment out (must currently be swapped in)

!!! note
    * By default, `swapexp` runs in the background, sending you email when the transition has completed. Use the `-w` option to wait in the foreground, returning exit status. Email is still sent.


----
### `create_image`: Create a disk image from a node <a name="create_image"></a>

```
create_image [options] imageid node
```

**Options:**

`-w` Wait for image to be created.

`-p` Project ID of imageid.

`imageid` Name of the image.

`node` Node to create image from (pcXXX).

**Example:**

The following command creates or re-creates an image for a particular project:

```
create_image -p <proj> <imageid> <node>
```
----
### `eventsys_control`: Start/Stop/Restart the event system <a name="eventsys_control"></a>

```
eventsys_control -e pid,eid start|stop|replay
eventsys_control pid eid start|stop|replay
```

**Options:**

`-e` Project and Experiment ID.

`stop` Stop the event scheduler.

`start` Start the event stream from time index 0.

`replay` Replay the event stream from time index 0

----
### `loghole`: Downloads and manages an experiment's log files <a name="loghole"></a>

This utility downloads log files from certain directories on the experimental nodes (e.g. `/local/logs`) to the DETERLab `users` machine. After downloading, it can also be used to produce and manage archives of the log files.

Using this utility to manage an experiment's log files is encouraged because it will transfer the logs in a network-friendly manner and is already integrated with the rest of DETERLab. For example, any programs executed using the DETERLab event-system will have their standard output/error automatically placed in the `/local/logs` directory. The tool can also be used to preserve multiple trials of an experiment by producing and managing zip archives of the logs. 

```
loghole [-hVdqva] [-e pid/eid] [-s server] [-P port] action [...]

loghole sync [-nPs] [-r remotedir] [-l localdir] [node1 node2 ...]

loghole validate

loghole  archive [-k (i-delete|space-is-needed)] [-a days] [-c comment]
    [-d] [archive-name]

loghole change [-k (i-delete|space-is-needed)] [-a days]  [-c  comment]
    archive-name1 [archive-name2 ...]

loghole list [-O1!Xo] [-m atmost] [-s megabytes]

loghole show [archive-name]

loghole clean [-fne] [node1 node2 ...]

loghole gc [-n] [-m atmost] [-s megabytes]
```

**Options:**

`-h, --help` Print  the  usage message for the loghole utility as a whole or, if an action is given, the usage message for that action.

`-V, --version` Print out version information and exit.

`-d, --debug` Output debugging messages.

`-q, --quiet` Decrease the level of verbosity, this is subtractive, so multiple uses of this option will make the utility quieter and quieter. The default level of verbosity is human-readable, below that is machine-readable, and below that is silent. For example, the default output from the "list" action looks like:

```
  [ ] foobar.1.zip   10/15
  [!] foobar.0.zip   10/13
``` 

Using a single `-q` option changes the output to look like: 

```
          foobar.1.zip
          foobar.0.zip
```

`-e, --experiment#PID/EID` Specify the experiment(s) to operate on using the Project ID (or project name) and Experiment ID (or experiment name).  If multiple `-e` options are  given,  the  action will apply to all of them.  This option overrides the default behavior of inferring the experiment  from (Note: this sentence was cut off in the Emulab documentation).

**Examples:**

To synchronize the log directory for experiment `neptune/myexp` with the log holes on the experimental nodes:
```
[vmars@users ~] loghole -e neptune/myexp sync
```

To archive the newly recovered logs and print out just the name of the new log file:
```
[vmars@users ~] loghole -e neptune/myexp -q archive
```

**More information:**

To see the detailed documentation of `loghole`, view the man page on `users`:
```
loghole man
```

----
### `os_load`: Reload disks on selected nodes or all nodes in an experiment <a name="os_load"></a>

```
os_load [options] node [node ...]
os_load [options] -e pid,eid
```

**Options:**

`-i` Specify image name; otherwise load default image.

`-p` Specify project for finding image name (`-i`).

`-s` Do *not* wait for nodes to finish reloading.

`-m` Specify internal image id (instead of `-i` and `-p`).

`-r` Do *not* reboot nodes; do that yourself.

`-e` Reboot all nodes in an experiment.

`node` Node to reboot (pcXXX).

----
### `portstats`: Get portstats from the switches <a name="portstats"></a>

```
portstats <-p | pid eid> [vname ...] [vname:port ...]
```

**Options:**

`-e` Show only error counters.

`-a` Show all stats.

`-z` Zero out counts for selected counters after printing.

`-q` Quiet: don't actually print counts - useful with `-z`.

`-c` Print absolute, rather than relative, counts.

`-p` The machines given are physical, not virtual, node IDs. **No pid and eid should be given with this option.**

!!! warning
    If only the pid and eid are given, this command prints out information about all ports in the experiment. Otherwise, output is limited to the nodes and/or ports given.

!!! note
    * Statistics are reported from the switch's perspective. This means that ''In'' packets are those sent FROM the node, and ''Out'' packets are those sent TO the node.
    * In the output, packets described as 'NUnicast' or 'NUcast' are non-unicast (broadcast or multicast) packets.

----
### `node_reboot`: Reboot selected nodes or all nodes in an experiment <a name="node_reboot"></a>

Use this if you need to powercycle a node.

```
node_reboot [options] node [node ...]
node_reboot [options] -e pid,eid
```

**Options:**

`-w` Wait for nodes is come back up.

`-c` Reconfigure nodes instead of rebooting.

`-f` Power cycle nodes (skip reboot!)

`-e` Reboot all nodes in an experiment.

`node` Node to reboot (pcXXX).

!!! note
    * You may provide more than one node on the command line. 
    * Be aware that you may power cycle only nodes in projects that you are member of. 
    * `node_reboot` does its very best to perform a clean reboot before resorting to cycling the power to the node. This is to prevent the damage that can occur from constant power cycling over a long period of time. For this reason, `node_reboot` may delay a minute or two if it detects that the machine is still responsive to network transmission. In any event, please try to reboot your nodes first (see above). 
    * You may reboot all the nodes in an experiment by using the `-e` option to specify the project and experiment names. This option is provided as a shorthand method for rebooting large groups of nodes. 

**Example:**

The following command will reboot all of the nodes reserved in the "multicast" experiment in the "testbed" project. 

```
    node_reboot -e testbed,multicast
```
----
### `expwait`: Wait for experiment to reach a state <a name="expwait"></a>

```
expwait [-t timeout] -e pid,eid state
expwait [-t timeout] pid eid state
```

**Options:**

`-e` Project and Experiment ID in format `<projectID>/<experimentID>`.

`-t` Maximum time to wait (in seconds).


## Informational Commands ##

### `node_list`: Print physical mapping of nodes in an experiment <a name="node_list"></a>

```
node_list [options] -e pid,eid
```

**Options:**

`-e` Project and Experiment ID to list.

`-p` Print physical (DETER database) names (default).

`-P` Like `-p`, but include node type.

`-v` Print virtual (experiment assigned) names.

`-h` Print physical name of host for virtual nodes.

`-c` Print container VMs and physical nodes.

!!! note
    * This command now queries the XMLRPC interface as it used to do. Users who had been using `script_wrapper.py node_list` to access this function should use `/usr/testbed/bin/node_list` instead.
    * The `-c` flag that outputs containerized node names has been modified in two ways. 
        * Names are produced without the DNS qualifiers as node names provided by other options of this command are. A node in a VM container named `a` will be reported as `a` not `a.exp.proj` as earlier versions of this feature did.
        * This option now reports embedded_pnode containers as well (physical machines). If no containers VMs are present in an experiment, `node_list -c` and `node_list -v` produce identical output.
    * The `node_list` command is now available as `node_summary`.

----
### `expinfo`: Get information about an experiment <a name="expinfo"></a>

```
expinfo [-n] [-m] [-l] [-d] [-a] -e pid,eid
expinfo [-n] [-m] [-l] [-d] [-a] pid eid
```

**Options:**

`-e` Project and Experiment ID.

`-n` Show node information.

`-m` Show node mapping.

`-l` Show link information.

`-a` Show all of the above.

----
### `node_avail`: Print free node counts <a name="node_avail"></a>

```
node_avail [-p project] [-c class] [-t type]
```

**Options:**

`-p project` Specify project credentials for node types that are restricted.

`-c class` The node class (Default: pc).

`-t type` The node type.

**Example:**

The following command will print free nodes on pc850 nodes:
```
    $ node_avail -t pc850
```

----
### `node_avail_list`: Print physical node_ids of available nodes <a name="node_avail_list"></a>

```
node_avail_list [-p project] [-c class] [-t type] [-n nodes]
```

**Options:**

`-p project` Specify project credentials for node types that are restricted.

`-c class` The node class (Default: pc).

`-t type` The node type.

`-n pcX,pcY,...,pcZ` A list of physical node_ids.

**Example:**

The following command will print the physical node_ids for available pc850 nodes:
```
    $ node_avail_list -t pc850
```

----
### `nscheck`: Check and NS file for parser errors <a name="nscheck"></a>

```
nscheck nsfile
```

**Option:**

`nsfile` Path to NS file you to wish check for parse errors.

