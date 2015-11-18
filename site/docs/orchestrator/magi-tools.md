The following tools are available for MAGI experiments in DETERLab:

<ul>
  <li><a href="#magi_bootstrap.py">magi_bootstrap.py</a></li>
  <li><a href="#magi_graph.py">magi_graph.py</a></li>
  <li><a href="#magi_orchestrator.py">magi_orchestrator.py</a></li>
  <li><a href="#magi_status.py">magi_status.py</a></li>
</ul>

## <a id="magi_bootstrap.py"></a>```magi_bootstrap.py```: Install MAGI
Used with the testbed start command, ```magi_bootstrap.py``` installs MAGI and supporting tools on all nodes at startup.

In the topology file of the desired experiment, include the following command:
```
tb-set-node-startcmd $NodeName "sudo python /share/magi/current/magi_bootstrap.py"
```
where ```$NodeName``` is the control node. 

## <a id="magi_graph.py"></a>```magi_graph.py```: Create graphs for a MAGI experiment

```magi_graph.py``` is a graph generator for experiments executed on DETERLab using MAGI. The tool fetches the required data using MAGI’s data management layer and generates a graph in PNG format. This tool may be executed from either the Deter Ops machine or a remote computer with access to internet. The data to be plotted and other graph features are configurable.

The various command line options are as follows:

```
  Usage: magi_graph.py [options]

  Plots the graph for an experiment based on parameters provided.
  Experiment Configuration File OR Project and Experiment Name
  needs to be provided to be able to connect to the experiment.
  Need to provide build a graph specific configuration for plotting.

  Options:
   -h, --help            show this help message and exit
   -e EXPERIMENT, --experiment=EXPERIMENT
                       Experiment name
   -p PROJECT, --project=PROJECT
                       Project name
   -x EXPERIMENTCONFIG, --experimentConfig=EXPERIMENTCONFIG
                       Experiment configuration file
   -c CONFIG, --config=CONFIG
                       Graph configuration file
   -a AGENT, --agent=AGENT
                       Agent name. This is used to fetch available database
                       fields
   -l AAL, --aal=AAL     AAL (experiment procedure) file. This is also used to
                       fetch available database fields
   -o OUTPUT, --output=OUTPUT
                       Output graph file. Default: graph.png
   -t, --tunnel          Tell the tool to tunnel request through Deter Ops
                       (users.deterlab.net).
   -u USERNAME, --username=USERNAME
                       Username for creating tunnel. Required only if
                       different from current shell username.
```

This tool expects the user to provide a configuration file. The format of the configuration file needs to be similar to the sample configuration file provided below.

```
  graph:
     type: line
     xLabel: Time(sec)
     yLabel: Bytes
     title: Traffic plot
  db:
     agent: monitor_agent
     filter:
          host: servernode
          peerNode: clientnode
          trafficDirection: out
     xValue: created
     yValue: bytes
```

The configuration is divided into two parts a) Graph options and b) Database options. Graph options are used to configure the type of graph and the various labels. The database options help the tool fetch the data to be plotted.

Each record stored in the database using MAGI’s database layer has the following three fields along with any other that an agent populates.

```
    agent: Agent Name
    host: Node of which the agent is hosted
    created: Timestamp of when the record is created
```
In the above mentioned example, data populated by the agent named “monitor_agent” hosted on the node named “servernode” will be fetched. The data would further be filtered on the configured values of peerNode and trafficDirection, which are agent specific fields.

Among the fetched data, values corresponding to the fields, created and bytes, will be plotted correspoding to the x and the y axis, respectively.

## <a id="magi_orchestrator.py"></a>```magi_orchestrator.py```: Run MAGI

```magi_orchestrator.py``` reads the procedure's AAL file and orchestrates an experiment based on the specified procedures. The Orchestrator does the following in this order:

1. '''Joins Groups''' - The Orchestrator iterates over the list of groups and for each group sends a request to all the mapped nodes to join the group. A corresponding reply adds the replier to the group. Messages addressed to a group are sent to all the nodes that are part of the group.
2. '''Loads Agents''' - The Orchestrator iterates over the list of agents and for each agent sends an agent load request to the mapped groups. An agent load message tells the Orchestrator to start an instance of the agent implementation and to put it in a listening mode, where the instance waits for further messages.
3. '''Executes Event Streams''' - Next, the Orchestrator concurrently executes all the event streams listed as part of ```streamstarts```.
The Orchestrator has a predefined event stream called ```exit```. The purpose of this event stream is to unload all the agents and disjoin groups. All workflows should end with executing this stream for a clean exit.

From your home directory on ```users.isi.deterlab.net```, run the following command:

```
/share/magi/current/magi_orchestrator.py --control clientnode.myExp.myProj --events procedure.aal
```


where 
* ```clientnode``` equals the node you want to start with
* ```myExp``` is the Experiment Name
* ```myProj``` is the Project Name
* ```procedural.aal``` is the name of the AAL file.


The various command line options are as follows:

```
  Usage: magi_orchestrator.py [options]

  Options:
       -h, --help
                       show this help message and exit
       -c CONTROL, --control=CONTROL
                       The control node to connect to (i.e. control.exp.proj)
       -f EVENTS, --events=EVENTS
                       The events.aal file(s) to use. Can be specified
                       multiple times for multiple AAL files
       -l LOGLEVEL, --loglevel=LOGLEVEL
                       The level at which to log. Must be one of none, debug,
                       info, warning, error, or critical. Default is info.
       -o LOGFILE, --logfile=LOGFILE
                       If given, log to the file instead of the console
                       (stdout).
      -e EXITONFAILURE, --exitOnFailure=EXITONFAILURE
                       If any method call fails (returns False), then exit
                       all streams, unload all agents, and exit the
                       orchestrator. Default value is True
      -g GROUPBUILDTIMEOUT, --groupBuildTimeout=GROUPBUILDTIMEOUT
                       When building the initial groups for agents in the
                       given AAL, use the timeout given (in milliseconds)
                       when waiting for group formation to complete.
      --nocolor
                       If given, do not use color in output.
      -v, --verbose
                       Tell orchestrator to print info about what its doing
     -n, --tunnel
                      Tell orchestrator to tunnel data through Deter Ops
                       (users.deterlab.net).
```

## <a id="magi_status.py"></a>```magi_status.py```: Check status of a MAGI experiment, reboot MAGI daemon, download logs

Use ```magi_status.py``` to:
* check MAGI’s status on experiment nodes
* reboot MAGI daemon process
* download logs from experiment nodes

This tool is run for one experiment at a time. The user needs to provide the project name and the experiment name to the tool.

This tool, by default, works for all of the nodes corresponding to the given experiment. However, it can be made to work with a restricted set of nodes, either by directly providing the set of interested nodes, or by providing an AAL (experiment procedure) file to fetch the set of desired nodes.

This tool by default only informs if the MAGI daemon process on a node is reachable or not. Specific options can be used to fetch group membership details and information about active agents.

If you want to reboot the MAGI daemon, ```magi_status.py``` first reboots MAGI daemon processes on the experiment nodes, and then fetches their status.

If the tool is asked to download logs, it just does that, and does not fetch the status.

```
  Usage: magi_status.py [options]

  Script to get the status of MAGI daemon processes on experiment nodes,
  to reboot them if required, and to download logs.

  Options:
    -h, --help            show this help message and exit
    -p PROJECT, --project=PROJECT
                          Project name
    -e EXPERIMENT, --experiment=EXPERIMENT
                          Experiment name
    -n NODES, --nodes=NODES
                          Comma-separated list of the nodes to reboot MAGI
                          daemon
    -a AAL, --aal=AAL     The yaml-based procedure file to extract the list of
                          nodes
    -l, --logs            Fetch logs. The -o/--logoutdir option is applicable
                          only when fetching logs.
    -o LOGOUTDIR, --logoutdir=LOGOUTDIR
                          Store logs under the given directory. Default: /tmp
    -g, --groupmembership
                          Fetch group membership detail
    -i, --agentinfo       Fetch loaded agent information
    -t TIMEOUT, --timeout=TIMEOUT
                          Number of seconds to wait to receive the status reply
                          from the nodes on the overlay
    -r, --reboot          Reboot nodes. The following options are applicable
                          only when rebooting.
    -d DISTPATH, --distpath=DISTPATH
                          Location of the distribution
    -U, --noupdate        Do not update the system before installing MAGI
    -N, --noinstall       Do not install MAGI and the supporting libraries

```