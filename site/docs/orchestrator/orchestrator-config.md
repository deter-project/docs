# MAGI Configuration

## Experiment Configuration

The MAGI experiment-wide configuration (```experiment.conf```) is a YAML-based configuration file. A customized ```experiment.conf``` can be provided to the MAGI bootstrap process.
~~~~
magi_bootstrap.py --expconf /path/to/experiment.conf
~~~~

It is optional for a user to provide one. In case it is not provided, the bootstrap process creates a default configuration file. 

Also, in cases where a user needs to customize a part of the configuration, the user can provide an experiment configuration file with only the parameters that need to be customized. The MAGI configuration validation process would update the user provided configuration to fill in the missing configuration.

The experiment wide configuration file consists of three sections.

- **MesDL**: Messaging overlay configuration

- **DBDL**: Data layer configuration

- **ExpDL**: Other experiment information

## MesDL: Configure the MAGI Control Overlay

The MAGI bootstrap process establishes a networking overlay over which it communicates with the experiment nodes.

The control overlay provides a control plane across heterogeneous resources, such as containers, federation, and specialized hardware, on the DETERLab testbed.

The control overlay provides a network to reliably propagate discrete control events across the experiment. Hence, it is critical to establish a robust and scalable overlay to ensure the experiments are orchestrated correctly.

MAGI provides multi-point to multi-point group communication. A “group” has a set of nodes as members. Each group has a logical name. Any member of the group can send a message to any other member of the group.

By default, one MAGI overlay is established for the experiment and all the control messages are passed over it.

However, it may be necessary to establish two or more overlays based on the experiment topology embedding, control and data management requirements. The required overlay structure can be explicitly specified during the experiment bootstrap process.

The overlay configuration, Messaging Description Language (MesDL), is a configuration of the required overlays and bridges in the experiment. The MesDL section of ```experiment.conf``` defines all the overlays and bridges for the experiment.

The MAGI “overlay” is built on top of the control network on the DETER testbed. Nodes in the overlay can be thought of as being connected by virtual point-to-point links. The overlay provides a way to communicate with all the MAGI-enabled nodes across the testbed boundaries and even over the internet. “bridges” act as meeting places for all the members of the overlay it serves.

For example:
~~~~
# Establish two bridges on node3.
# Typically one is inward facing towards the experiment and one
# is outward facing towards the experimenter to use with magi tools
# magi tools can now connect to the experiment overlay through node3,
# port 18808
bridges:
   - { TCPServer: node3, port: 18808 }
   - { TCPServer: node3, port: 28808 }
# Establish two overlays for the experiment.
overlay:
   # Members of this overlay rendezvous at node3. All experiment nodes
   # are part of this overlay.
  - { type: TCPTransport, members: [ '__ALL__' ], server: node3,
      port: 28808 }
   # Members of this overlay rendezvous at node2.
   # node4 and node7 are members of this overlay.
  - { type: TCPTransport, members: [ 'node4', 'node7' ],
      server: node2, port: 48808 }
~~~~
In the absence of the MesDL, MAGI creates a single overlay with all the experiment nodes as members. MAGI establishes a bridge node based on the following.

!!!note
    MAGI establishes one of the nodes in the experiment as a bridge node. MAGI selects the bridge node based on the following rules:
    
      - If there is a node named “control”, it uses that node as the bridge node.
      
      - If not, it establishes the node with the lowest alphanumeric node name as the bridge node.
      
    MAGI expects the selected bridge node to be MAGI-enabled. However, if that is not the case, the user must provide a custom MesDL.
    
For example, here is the MesDL section of ```experiment.conf``` for the Client-Server tutorial
~~~~
mesdl:
  bridges:
     - {server: clientnode.clientserver.montage, type: TCPServer, port: 18808}
     - {server: clientnode.clientserver.montage, type: TCPServer, port: 28808}
  overlay:
     - members: [__ALL__]
       port: 28808
       server: clientnode.clientserver.montage
       type: TCPTransport
~~~~

## DBDL: Configure the MAGI Data Management Layer

The database configuration contains the following parameters:
~~~~
dbdl:

   #whether the database management layer is enabled or not
   isDBEnabled: true

   #whether the database is sharded or not
   isDBSharded: false

   # mapping of sensor/data producer nodes to data collector nodes
   # __DEFAULT__ maps to the default collector node
   # if the user does not provide one, the first node in the alpha-numerically
   # sorted list of collectors is selected as the default collector
   # In case some of the sensor nodes are not mapped to a collector node,
   # MAGI would map them to the default collector node
   sensorToCollectorMap: {node1: node1, node2: node1, __DEFAULT__: node3}

   # the port at which the collectors listen
   collectorPort: 27018

   #if sharded, where does the global server run
   globalServerHost: node-1
   globalServerPort: 27017
~~~~

By default, MAGI setups an unsharded setup with a centralized collector. All the sensors collect data at the same collector. However, an experimenter can choose to configure the database whichever way.

All the collector nodes need to be MAGI-enabled. The data manager configuration needs to have a collector mapping for each of the MAGI-enabled experiment nodes. If one is not provided, any sensors on a node that does not have a mapped collector, would end up collecting at the default collector.

The <a href="../data-management/">Data Management</a> section has more information about MAGI’s data management layer.

!!!note
    The ports are not configurable, they are only for informational purpose.
    
## ExpDL: Other common experiment wide configuration

The ExpDL part of the experiment configuration file contains common experiment-wide configuration that is used by the various MAGI tools. Most of the configuration in this section is automatically generated.

A user can override the default AAL file location and the default directories for config files, log files, database files and temporary files.
~~~~
expdl:
  aal: /proj/montage/exp/clientserver/procedure.aal
  nodePaths: {config: /var/log/magi, db: /var/lib/mongodb, logs: /var/log/magi, temp: /tmp}
  distributionPath: /share/magi/dev
  experimentName: clientserver
  projectName: montage
  nodeList: [clientnode, servernode]
  testbedPaths: {experimentDir: /proj/montage/exp/clientserver}
~~~~

## Node Configuration

The MAGI daemon process runs using a node-specific configuration (```node.conf```). The experiment wide configuration (```experiment.conf```) is converted into a node specific configuration as part of the bootstrap process. The node configuration file contains some additional configuration apart from all the node specific configuration from the experiment wide configuration.

A customized ```node.conf``` can be provided as an input to the MAGI bootstrap script, or to the MAGI daemon startup script, directly. Similar to the ```experiment.conf```, a user can provide an incomplete configuration file, containing only customized parameters. The MAGI configuration validation process would fill in the missing configuration.

~~~~
transports:
- {address: 0.0.0.0, class: TCPServer, port: 18808}
- {address: 0.0.0.0, class: TCPServer, port: 28808}

database:
  isDBEnabled: true
  configHost: clientnode
  sensorToCollectorMap: {clientnode: clientnode, servernode: servernode}

localInfo:
  configDir: /var/log/magi
  logDir: /var/log/magi
  tempDir: /tmp
  dbDir: /var/lib/mongodb
  architecture: 32bit
  controlif: eth0
  controlip: 172.16.111.95
  distribution: Ubuntu 10.04 (lucid)
  nodename: clientnode
  hostname: clientnode.clientserver.montage.isi.deterlab.net
  interfaceInfo:
    eth1:
      expif: eth1
      expip: 10.0.0.1
      expmac: 00:00:00:00:00:01
      linkname: link
      peernodes: [servernode]

software:
- {dir: /share/magi/dev/Linux-Ubuntu10.04-i686, type: rpmfile}
- {dir: /share/magi/dev/Linux-Ubuntu10.04-i686, type: archive}
- {type: apt}
- {dir: /share/magi/dev/source, type: source}
- {dir: /tmp/src, type: source}
~~~~

## Bootstrap Process

The ```magi_bootstrap.py``` is used to configure the overlay and start MAGI on the experiment nodes.

The ```magi_bootstrap.py``` tool is typically called when the node starts as follows:
~~~~
tb-set-node-startcmd $NodeName "sudo python /share/magi/current/magi_bootstrap.py"
~~~~

The magi bootstrap script can be used to install, configure, and start MAGI. The various command line options are as follows.
~~~~
Usage: magi_bootstrap.py [options]

Bootstrap script that can be used to install, configure, and start MAGI

Options:
  -h, --help            show this help message and exit
  -p RPATH, --path=RPATH
                        Location of the distribution
  -U, --noupdate        Do not update the system before installing Magi
  -N, --noinstall       Do not install magi and the supporting libraries
  -v, --verbose         Include debugging information
  -e EXPCONF, --expconf=EXPCONF
                        Path to the experiment wide configuration file
  -c NODECONF, --nodeconf=NODECONF
                        Path to the node specific configuration file. Cannot
                        use along with -f (see below)
  -n NODEDIR, --nodedir=NODEDIR
                        Directory to put MAGI daemon specific files
  -f, --force           Recreate node configuration file, even if present.
                        Cannot use along with -c (see above)
  -D, --nodataman       Do not install and setup data manager
  -o LOGFILE, --logfile=LOGFILE
                        Log file. Default: /tmp/magi_bootstrap.log
~~~~
