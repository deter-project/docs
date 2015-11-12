This page talks about language used to design experiments. It should both be used to design metadescriptions and perhaps to make them more specific to a particular experiment the user wants to run. 

I'll start with a few examples of experiments first, that we should be able to design in this language. 
1. [BotnetExample] 
1. [CachePoisonExample] 
1. [MitmExample]

[CurrentlyProposedLanguage]

We may end up with a single language or a set of related languages. Here is what we need to express:

  1. *Logical topology_' - both at the level of individual nodes or groups of nodes. We are expressing a ''logical'' topology of the experiment where there are '''objects''' that do something in the experiment - generate traffic, change state, hold data, whatever. Whether these objects are individually generated or generated as a group of entities, whether they are physical nodes or virtual, etc. does not matter. The expressiveness should be such that the actual implementation of objects and the cardinality of each object is orthogonal to the topology description. We should however be able to give '_hints* such as "these objects are in the same network or on same physical node or object A resides on object B". Here is a rough list of hints we'd like to be able to give:
   * What type of object this is - we need to enumerate all possible types such as Node, Info, DNSRecord, ... As new meta-descriptions and new generators are added type list will grow
   * What is the cardinality of this object - this is just a hint about cardinality. I need to be able to say "this is one of many" vs "one and only one", like in [BotnetExample] I should have many vulnerable hosts, but in [MitmExample] I have exactly two nodes and one attacker in the middle of them. I could have multiple MITM triplets but the minimum size is 1 triplet.
   * Can objects overlap or are they distinct
   * An object is (not) located on another object (e.g., cache on a node)
   * An object is (not) contained in another object (e.g. cache record in cache)

  2. *Timeline of events* - we need to express the ordering of actions that some objects will take in the experiment, their duration, repetition and concurrency. We also need to express state transitions in objects. In some domains this is called a _workflow_. It could be pre-created in the experiment design stage or it could be generated manually during the experiment (mined from events that happen as user takes manual actions) or a mix of those. Each experiment class must have some default workflow that user can manipulate during experiment design. Here is a rough list of things to express here: 
   * Parameters of an action
   * An action must happen vs may happen
   * Additional actions are allowed vs not allowed 
   * An action can(not) be split into multiple smaller pieces that have the same effect
   * All vs some vs none vs selected objects take some action or undergo a state transition
   * State changes in objects due to some action, at random, due to a timeout ... State changes that generate an action
   * Conditions that lead to state change or to an action
   * One (or none or N) of a number of actions must happen 
   * Loops with and without conditions
   * Actions follow one another (optionally: after some time has elapsed), occur in parallel
   * "Unwinding" actions that invalidate some state and return one to a prior state (see Vigna et al. "STATL")

  3. *Invariants* - we need to express what MUST happen in the experiment for it to be valid. This is not a complete set, just the necessary one. If any of the invariants were violated the experiment would become invalid. Valid here means "for it to belong to a class of experiments whose metadescription we used" plus any other conditions that user wants to impose. There are two types of invariants:
     a. those that deal with objects and their states ("cache must be poisoned")
     b. those that deal with events and their features ("traffic must flow from A to B for 5 minutes at 100Mbps")
     
     In general case invariants are defined in the logical topology and timeline of events. Additional invariants may be defined in this section but so far I had hard time coming up with those for a meta-description. Naturally when the user designs her experiment starting from the metadescription this will lead to more invariants being defined automatically and to some that a user can choose to define.

*Note that intentionally this is all pretty high-level and is orthogonal to any generator used to generate topologies, traffic, etc.* There must be a mapping process that selects eligible generators for each dimension and takes their output and maps objects and events to it. More about this mapping process later.

The entire system has a domain library that contains domain-specific information, such as:
  * Context: This will probably be expressed in a mix of [CurrentlyProposedLanguage] and regular expressions
   * what is an IP address
   * what is an IP flow
   * what is an IP packet pair
   * what is a TCP connection (consists of three packets with following features ..)
   * what is a DNS request/reply, what makes a reply match the request
   * what is an HTTP request/reply, what makes a reply match the request
   * what is the syntax of a DNS record
  * Parameterization: This will probably be expressed using [CurrentlyProposedLanguage]
   * for each type of object and each type of event in any metadescription what kind of parameters can be defined. E.g., for HTTP request this would be timing of requests and content of requests (type=GET/PUT/POST, filename). Note that this is divorced from the actual generator of such event, parameters are strictly related to events, regardless of how they are generated.

The context part would be mostly populated by us. The parameterization and relationship parts would be seeded by us but then extended by other experts that create meta-descriptions. There is an automated way of identifying unknowns from a meta-description that must be defined in the domain library.

Our system keeps the following info about each generator:
  * Name
  * Contact of the author or N/A for non-supported generators
  * URL of the manual for the generator
  * What is the type of its output (e.g. Topology) - the types mentioned here are from the same enum list as object types in the logical topology
  * What parameters users can customize - these come from the same list as parameters in the parameterization part of the domain library. A generator may have some parameters specific to itself, we don't care about those in this item. We care about parameters that describe a certain event/object and which of them we can manipulate if we choose this generator.
  * How the parameters can be customized, e.g., randomized, input by user, selected from a list ...
  * Other inputs of the generator, their range of values and their relationship to the parameters from the above two items
This information is expressed using [CurrentlyProposedLanguage] and fixed section/function names

We have a library of functions such as:
  * Getting an IP address of a node, or an ARP address or DNS name
  * What does it mean for a request to match a reply for a given request/reply subclass (e.g., DNS request/reply) 
These will likely be expressed using [CurrentlyProposedLanguage]

During experiment design the system identifies all the objects and events in the metadescription and tries to map them to possible generators. This mapping should occur by the following formula:
  * For each object and each event find out what parameters it may have from the parameterization part of the domain library
  * Highlight those that we actually plan to customize based on the meta-description
  * Find a set of generators that can customize these parameters (how the customization is done is also important but it's a little vague to me yet how to formalize this part of spec)
  * Offer these generators to the user with a default option that she can just accept
  * Each generator's output must be mapped to objects/events in the metadescription. This mapping may be 1-1 as in "we're generating DNS request/reply and that's exactly what's in the meta-description" or it may be N-1 as in "we're generating a topology and some nodes are objects X from the meta-description". We should provide some straightforward mappings such as:
    * 1-1
    * random
    * for Topology type, random among edges or random among nodes of degree X or <X or >X or in between X and Y, or geographic
Users must have a way to define their own mapping if they want.
  * Users must have a way to combine meta-descriptions during experiment design just like I did in the examples, or to instantiate one meta-description (or portions of it) multiple times
  * Users must have a way to define their own events/invariants on top of what we generate automatically

What completely describes an experiment is a meta-description plus the user input, i.e., generator selection and parameterization and any customization that happens on top of that. This record can be archived and reused assuming no manual action during an experiment. If there are some manual actions these should be inserted into the "timeline of events" part of the experiment design and this modified record saved.   
  
* How do we allow certain generators to generate state in the middle of a meta-description? For example, we can form a P2P network as I described in [BotnetExample] by exchanging messages with potential peers, and then we can send C&C traffic on it. But we can also just have some generator give us a P2P topology. We need a way to say, when we choose the second generator, that this is the same outcome as exchanging messages with potential peers. That is, the fact that peer requests and replies will be missing in the second case does not invalidate the experiment from P2P class of experiments.