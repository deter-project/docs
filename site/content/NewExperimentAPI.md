[[TOC]] 


DETERLab is regarded as a scientific instrument to 
create knowledge and understanding through 
observation and measurement of cyber security 
technologies. DETERLab provides a 
flexible software framework to 
structure the experiment environment 
and execute the procedue 
while ensuring experiment validity and repeatability. 
In this section we discuss each of these aspects in 
detail. 

[[Image(expdescription.png, 720px)]]

# Environment

The experiment environment defines the set of 
resources required to configure a DETERLab experiment. 
It consists of the three planes and 
elements with different functional behaviors mapped onto them. 
We discuss each in detail below. 

The experiment environment consists of three planes: 

* *an experiment plane: * 

  The plane that carries the experiment traffic. 
  It consists of the set of experiment nodes, substrates,
  and their topological structure. 
  The functional behaviors are 
  mapped onto the experiment nodes. 
  For example, an experiment may consist of background
  traffic generators including webserver and webclients, 
  attack traffic generators, including botmasters and bots. 
  The structure is defined in the TopDL/ns-2 
  description file.


* *a control plane: * 
   The plane to send and receive  control specific instructions and 
   signalling commands to the experiment nodes. 
   In addition to the experiment nodes, other control-specific 
   nodes such as an orchestrator and a bridge may also belong to the control     
   plane. 
   The topological structure of the control plane 
   is defined by the testbed or configured per experiment
   in the TopDL/MesDL description file.
   The topology consists of four types of elements. 
   Namely, directors, bridges, overlays, and orchestrators. 

* *a data plane: *
   The plane to carry measurement specific traffic for 
   for analysis and visualization. 
   In addition to the experiment nodes, other data specific 
   nodes, such as aggregators and collectors, 
   may also belong to the data plane. 
   The topological structure of the data plane 
   is defined by the testbed or configured per experiment
   in the description TopDL/MesDL file.  
   The topology consists of four types of elements, 
   namely, sensors, collector, aggregators and queriers. 


There are five types of properties that can be configured for 
each experiment element: 

* *process*: 
   The property characterizes the _computational capacity_ 
   of the element. 
   A functional mapping of the behavior onto the element can impose 
   requirement constraints, that is, a webserver requires at least 200Mhz 
   of computational capacity. 
   Computational capacity units can be specified in jiffies and clock speed. 
   

* * storage*:
   This property characterizes the local _persistent_ (and non--persistent) 
   recording capacity of the element. 
   A functional mapping of the behavior onto the element can impose 
   different storage requirement constraints. For example, a router 
   element in the experiment may not require any storage, whereas, a 
   collector element may require a lot of storage capacity.  

* *network interface*:
   This property characterizes the cardinality and type of network interface 
   on the experiment element. There may be more than one interface. 
   Each interface has its own rate and delay characteristics. 
   The functional mappings of the behavior onto the element can impose 
   different interface requirements. For example, collectors may require 
   a high bandwidth interface, core routers in an experiment topology 
   may require many interfaces. 

* *sense*:
     This property characterizes the types of stimulus the element can sense. 
     For example, heat, GPS signal, high rate packet capture, video. 
     
     
* *actuate*: 
     This property characterizes the types of responses the element can implement. 
     For example, bring down an interface, increase delay on a link, 
     partition a network 


Each experiment element has incoming and outgoing connections to one or more 
experiment planes. 

	#!comment
	Each experiment element has incoming and outgoing connections:
	Based on the type of element, it will have one or more 
	communicate, sense and actuate functions. 
	
	Incoming: 
	From experiment plane: the experiment  traffic (router/server)
	From control plane: the control management traffic (event signals, actuation signals)
	From data plane: data management traffic 
	(collection traffic into a collector, data streams into a aggregator)
	
	
	Outgoing: 
	To experiment plane: the experiment traffic (router/traffic generator)
	To control plane: return triggers from nodes, actuation signals from evaluators 
	To data plane: sensing data from sensor, aggregation from aggregator
	
	
	
	

# Workflow

The experiment workflow defines the dynamic 
procedure enacted to conduct a DETERLab experiment. 
It consists of three main activities: 

* *Event Streams: *
    An event is a  signal to invoke a particular behavior on the experiment nodes. 
    The event streams in an experiment are 
    partially ordered set of events defined as a directed acyclic graph. 
    An experiment workflow consists on one or more event streams  
    defined in an AAL  description file. 
    All event signals are sent over the control plane 
    typically by the orchestrator. 

* *Triggers: *
    A synchronization point in the dynamic experiment workflow. 
    The trigger may be _time-based_, that is the orchestrator waits for 
    a particular amount of time to lapse or _event-based_, where the 
    orchestrator waits to receive a signal before proceeding with the 
    workflow. Triggers can be used to synchronize one or more event streams.
    All triggers are sent over the control plane.
    Triggers are defined as part of the experiment workflow in 
    the AAL description file. 


* *Collectors: *
   A signal to enable sensing and collection of experiment measurements for 
   feedback as 
   triggers and for analysis. 
   All sensing and collection measurements are sent over the data plane. 
   Collectors may be defined within the procedure description AAL file. 


# Validity Management

The experiment validity is maintained by a set of constraints and 
invariants asserted throughout the experiment lifecycle. 
They relate to the experiment environment and the workflow as follows: 

* *Environment:*
     During the process of defining and configuring the environment, 
     the constraints and invariants can be used to 
     ensure the validity of a particular configuration step. 
     Some constraints and invariants may indicate key 
     capacity requirements for validity, 
     for example, CPU requirements for experiment nodes,
     while some may be functional requirements, such as, 
     number of available client hosts.
     The constraints and invariants are defined in an ECL description file
     and processed by the DETERLab validity management framework. 

* *Workflow:* 
    During experiment execution, the constraints and invariants 
    can be used to ensure that the experiment proceeds in accordance 
    with these assumptions. The constraints can thus be used to ensure 
    _safety_, that is, the experiment will not do anything bad and 
    _liveness_ that is, the experiment will do something useful.   
    The constraints and invariants are defined in an ECL description file
    and processed by the DETERLab validity management framework. 
      
  

# More Information 

* [wiki:ExperimentAPISPec Detailed Experiment API Specification] 
