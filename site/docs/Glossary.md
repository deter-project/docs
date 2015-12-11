
* **Agent Abstraction Language (AAL)**

    * A YAML based descriptive language that the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a> uses to describe an experiment’s procedural workflow. The entire experiment procedure needs to be expressed as part of an AAL file. Find more information in the <a href="/orchestrator/orchestrator-guide/#step-1-write-the-aal-file">Orchestrator Guide</a>.

* **agent**

    * In <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a piece of code that instruments a given functional behavior. Find more information in the <a href="/orchestrator/orchestrator-guide/#Agents">Orchestrator Guide</a>.

* **Boss network (<tt>myboss.isi.deterlab.net</tt>)**

    * The main testbed server that runs DETERLab. Users are not allowed to log directly into it.

* **collectors/collector nodes**

    * In <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a set of nodes that capture and store experiment status and data.

* **container_image.py**

    * In the <a href="/containers/containers-quickstart/">Containers (Virtualization) system</a>, a command that draws a picture of the topology of an experiment. This is helpful in keeping track of how virtual nodes are connected. For more information, see the <a href="/containers/containers-reference/#container_image.py">Containers Reference</a>.

* **containerize.py**

    * In <a href="/containers/containers-quickstart/">Containers (Virtualization) system</a>, the command that creates a DETER experiment made up of containers. For more information, see <a href="/containers/containers-reference/#containerizepy">containerize.py</a>.

* **container**

    * In the <a href="/containers/containers-quickstart/">Containers (Virtualization) system</a>, any one of various virtualization technologies, from an Openvz container to a physical machine to a simulation. The Containers system allows you to create interconnections of containers (in our sense) holding different experiment elements.

* **data management layer**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, helps agents collect data. Users can query for the collected data by connecting to the data management layer.

* **DBDL**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, the section of the experiment config file that configures the data layer.

* **DETER web interface (isi.deterlab.net)**

    * The browser-based web portal for starting and defining experiments in DETERLab. 

* **DETER**

    * Stands for cyber DEfense Technology Experimental Research and is an organization out of ISI/USC conducting research (the DETER Project) as well as the operator of a leading cyber security experimentation lab, DETERLab. DETER's mission is to readily enable the research community to conduct advanced research in cyber security through use of DETERLab's innovative methods and advanced tools -- that allow for repeatable, scalable and scientifically verifiable experimentation -- for homeland security and critical infrastructure protection.

* **DETER Project**

    * A research project run by DETER that focuses on answering key questions about how best to conduct cyber-security research, what are the best methods and tools to carry out this kind of research, and how to conduct cyber research in a repeatable, archivable, hypothesis-based way. For more information, see <a href="http://www.deter-project.org/about_deter_project" class="ext-link">http://www.deter-project.org/about_deter_project</a>.

* **DETERLab**

    * A state-of-the-art scientific computing facility for cyber-security researchers engaged in research, development, discovery, experimentation, and testing of innovative cyber-security technology. For more information, see <a href="http://www.deter-project.org/about_deterlab" class="ext-link">http://www.deter-project.org/about_deterlab</a>.

* **Emulab**

    * A network testbed designed to provide researchers a wide range of environments in which to develop, debug, and evaluate their systems. The DETERLab system is based on Emulab.

* **endnode tracing/monitoring**

    * Refers to putting the trace hooks on the end nodes of a link, instead of on delay nodes. This happens when there are no delay nodes in use or if you have explicitly requested end node shaping to reduce the number of nodes you need for an experiment.

* **event groups**

    * In <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a group of events that enable a behavior in the experiment, for example web server events.

* **event streams**

    * In <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, the order of events in a particular MAGI (orchestrated) experiment. Events are one of two things, events or triggers. Events are similar to remote procedure calls on agents. Triggers are synchronization and/or branching points in your event stream.  A simple example of an event stream could be: configure the agent, tell it to begin monitoring the local node, wait for 60 seconds, then tell the agent to stop monitoring. When the event stream has no more events or triggers, the orchestrator will exit.

* **event system**

    * In <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a messaging system to send and receive orchestration messages.

* **events**

    * In <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, events are one of two things, events or triggers. Events are similar to remote procedure calls on agents. Triggers are synchronization and/or branching points in your event stream. 

* **ExpDL**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, the section of the experiment config file that configures common experiment wide configuration that is used by the various MAGI tools. Most of the configuration in this section is automatically generated.

* **experiment**

    * Work in DETERLab is organized by experiments within project.

* **experiment.conf**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, the experiment-wide, YAML-based configuration file.

* **federation**

    * In general, refers to the ability to join disparate resources as if they were the same resource. DETERLab offers federated  architecture for creating experiments that span multiple testbeds through dynamically acquiring resources from other testbeds. 

* **fidelity**

    * In general, means the degree to which something is faithfully reproduced. In DETERLab, refers to varying degrees different elements of a large-scale experiment (in the <a href="/containers/containers-quickstart/">Containers (Virtualization) system</a>, for example) need to be fully reproduced. Some processes require high degree of fidelity while others do not.

* **gatekeeper**

    * Protects the internet facing side of the testbed and serves as a NAT machine for the Private Internet Network using a bridging firewall. 

* **image IDs**

    * A descriptor for a disk image. This can be an image of an entire disk, a partition of a disk, or a set of partitions of a disk.

* **image**

    * Refers to a disk image.

* **interface description file (IDL)**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, refers to a YAML-based file that describes an agent's interface. This is required when writing your own agents and allows an agent to be integrated with the experiment GUIs.

* **link tracing/monitoring**

    * The ability to follow the path of a link or LAN in a DETERLab experiment.

* **MAGI**

    * A DETERLab system that allows you to orchestrate very complex experiments. Stands for Montage AGent Infrastructure (Montage was originally an experiment lifecycle manager in DETERLab). For more information, see <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator docs</a>.

* **MAGI Graph**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a graph generator for experiments executed on DETER Lab using MAGI. The tool fetches the required data using MAGI’s data management layer and generates a graph in PNG format.

* **MAGI Status**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a status tool that allows you to check MAGI’s status on experiment nodes, reboot MAGI daemon process, and download logs from experiment nodes.

* **magi_bootstrap.py**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, installs the MAGI distribution along with the supporting tools when setting up a MAGI-enabled experiment in DETERLab.

* **magi_orchestrator.py**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a tool that parses an AAL file and orchestrates an experiment based on the specified procedures.

* **Messaging Description Language (MESDL)**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, the section of the experiment config file that defines all the overlays and bridges for the experiment. The MAGI “overlay” is built on top of the control network on the DETERLab testbed. Nodes in the overlay can be thought of as being connected by virtual point-to-point links. The overlay provides a way to communicate with all the MAGI-enabled nodes across the testbed boundaries and even over the internet. “Bridges” act as meeting places for all the members of the overlay it serves.

* **node.conf**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, a node-specific configuration file used by the MAGI daemon process. As part of the bootstrap process, the experiment-wide config file (experiment.conf) is already broken down into node-level configuration. But you may customize node configuration via this file and it may be provided as an input to the MAGI bootstrap script, or to the MAGI daemon startup script, directly.

* **nodes**

    * A node simply means any computer allocated to an experiment.

* **NS (Network Simulators) files syntax**

    * Used to describe topologies in network experiments. DETERLab-specific information may be found in the <a href="/core/core-guide/#Step1:Designthetopology">Core Guide</a> and further documentation is available at <a href="http://www.isi.edu/nsnam/ns/" class="ext-link">http://www.isi.edu/nsnam/ns/</a>.

* **operating system images (OSIDs)**

    * Describes an operating system which resides on a partition of a disk image. Every ImageID will have at least one OSID associated with it.

* **orchestrator**

    * See `orchestrator.py`, in the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>.

* **project**

    * Each group of users (or team) using DETERLab is grouped into 'projects', identified by a project ID (PID).

* **swapin**

    * The process where DETERLab allocates resources for your experiment and runs it.

* **swapout**

    * The process where DETERLab frees up the resources that were being used for your experiment. It is very important to do so when you are no longer using your experiment so that these resources are available for other experiments.

* **topology**

    * A description of the various elements of a computer network. In DETERLab, your experiment requires a topology in NS syntax that describes the links, nodes, etc of your experiment.

* **triggers**

    * In the <a href="/orchestrator/orchestrator-quickstart/">MAGI Orchestrator</a>, these are synchronization and/or branching points in a stream of events.

* **users network (<tt>users.isi.deterlab.net</tt>)**

    * DETERLab's file server that serves as a shell host for testbed users. 

* **YAML**

    * A simple format for describing data, used as the syntax for many configuration files throughout DETERLab systems. In general, just follow configuration file documentation, but if you are curious about specifications, you may find the latest here: <a href="http://www.yaml.org/spec/1.2/spec.html" class="ext-link">http://www.yaml.org/spec/1.2/spec.html</a>