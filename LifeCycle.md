
# Design Notes

This page documents a collection of preliminary ideas on experiment lifecycle management. It serves the following purposes: 

  * It discusses the high-level concepts of an experiment lifecycle and its isomorphism to the software development lifecycle 

  * It discusses how the experiment lifecycle plug-in will integrate with the DETER testbed and related technologies 


# Overview 
The current experimental testbed services primarily focus on providing experimenters access to testbed resources with little or no help to configure, correctly execute, 
and systematically analyze the experiment data and artifacts. Additionally, while it is well know that experimentation is inherently iterative, there are limited mechanisms to integrate and cumulatively build upon experimentation assets and artifacts during the configure-execute-analyze phases of the experiment lifecyle. 

The eclipse ELM plug-in provides an integrated environment with a (large) collection of tools and workbenches to support and manage artifacts from all three phases on the experiment life cycle. Each workbench or perspective integrates several tools to support a specific experimentation activity. It provide a consistent interface for 
easy invocation of tools and tool chains along with access to data repositories to store and recall artifacts in a uniform way. For example, the topology perspective 
allows the experimenter to define a physical topology by merging topology elements based on the specified constraints and then validate the resultant topology. 

The key capabilities of the ELM plug-in include: 

 
* Mechanisms to record variations and derivations of the experiment assets and artifacts and along with their 
 inter-realtionships for the entire set of tasks over which an experimenter iterates during the study. 

* Inform design and analysis tools to obtain maximum information with the minimum number of experiment trials for a particular study. Every measured value in an experiment is fundamentally a 
 random variable. Hence there are slight variations in the measurements during a trial even when all experimentation factors are kept constant. Hence to be able to characterize such stochastic behavior, 
 it is necessary to execute multiple repetitions and identify confidence levels. Leveraging the tools in the analysis phase, feedback from the analysis phase can be used to control the number of 
 required repetitions for statistically significant results. 

* Facilitate composition of functional and structural elements of the experiment based on stated and unstated constraints. The ELM workbenches allow creating and linking functional elements 
 of the experiment without specifying the underlying structure and topology. Resolving the constraints to configure a set of realizable and executable 
 experiment trials is  a complex constraint satisfaction problem. 
 
* Facilitate experiment monitoring and analysis for accuracy of results and availability of resources and services. ELM+SEER will enable monitoring the experiment configuration and performance of  
 resources to ensure the experiment is executed correctly. While resource misconfiguration and failures are easier to spot, identifying "incorrect performance" of a resource or service is extremely 
 hard. For stochastic processes as seen typically in networked systems, it is very important to be able to identify such experimentation errors as they can significantly impact results and bias 
 measurements.

* Enable reuse of experiment assets and artifacts. Reuse is driven by the ability to discover the workflows, scenarios, and data. The ELM environment will provide registry and registry views, along
 with (RDF-based, DAML+OIL) metadata to facilitate the discovery process. ELM will provide tools to index and search semantically rich descriptions and identify experimentation components
 including models, workflows, services and specialized applications. To promote sharing, ELM will provide annotation workbenches that allow experimenters to add sufficient metadata and dynamically 
 link artifacts based on these annotations. 

* Support for multi-party experiments where a particular scenario can be personalized for a team in a _appropriate_ way by providing restricted views and control over only certain aspects of the 
 experiment. The registry view will allow the team to access only a restricted set of services. The analysis perspectives and views will present relevant animations and graphs to the team. Thus by 
 personalizing a scenario view, the same underlying scenario, can be manipulated and observed in  different ways by multiple teams.


We define a *scenario_' to encompass related experiments used to explore a scientific inquiry. The scenario explicitly couples the experimenter's '''intent''' with the '_apparatus* to create a series of related experiment trials. 
The experimenter's intent is captured as *workflows_' and '''invariants'''. A workflow is a sequence of interdependent actions or steps and  invariants are properties of an experiment that should remain unchanged throughout the lifecycle. The '_apparatus* on the other hand, includes the topology and services that are instantiated on the testbed during the execution phase. Separation of experimentation intent from the apparatus also enables experiment portability where the underlying apparatus could 
heterogeneous and abstract, virtualized experiment elements.

# Steps for creating an experiment 
Given the above ELM environment, the basic process of creating a scenario consists of the following steps in a spiral: 
 
*Composition Phase *
*  defining the functional components and functional topology of the study. 
* defining the abstractions, models, parameters, and constraints for each functional component 
* identifying/defining the experiment workflow and invariants 
* identifying/defining the structural physical topology 
* Composing the experiment trials by resolving the constraints and exploring the parameter space 

*Execution Phase*
* sequential or batched execution of experiment trials 
* monitoring for error and configuration problems 

*Analysis Phase*
* analyzing completed trials (some trial may still be executing) 
* presenting results to experimenter 
* feedback parameters into the composition tools 
* annotate data and artifacts and store in the repositories

# Integration with DETER 
 A scenario construct captures

(Place holder: need to update) 

# August Review Demo 

Suppose my intent is to study the response time of an intrusion detection system. I design a scenario to connect attacker components to the IDS component with an internet-cloud component. The ids component is then connected to a service component with a wan-cloud component as shown below. 

[[File:Attacker-ids.png]]

I am interested in exploring the effects of the attacker on response time of the IDS and not interested in any other aspect of the experiment. The ELM framework should then enable me, the experimenter to solely focus on creating a battery of  experimentation trials by varying the number of attacker components, the attacker model, the model parameters,etc. All other aspects of the experiment should be defined, configured, controlled, and monitored based on standard experimentation methodologies and practices. 

Each component that affects the response time of the IDS and has several alternatives is called a _factor''. In the above example, there are four factors: attacker type, internet-cloud type, wan-cloud type and service type. The models that a factor can assume is called a ''level_. Thus the attacker type has two levels: volume attack and stealth attack. Each level can be further parameterized to give additional sub-levels, for example, low-volume vs high-volume attacks. 

Factors whose effects need to be quantified are called primary factors, for example, in the above study, we are interested in  quantifying the effects of attack type. All other factors are secondary, and we are not interested in exploring and quantifying currently. 

Hence the experiment design tool consists of defining individual trials varying each factor and level (and possibly also trial repetitions for statistical significance) to create a battery of experiment trials to explore the every possible combination of all levels and all primary factors.
