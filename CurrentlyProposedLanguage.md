This page describes currently proposed language for meta-descriptions. It may be updated frequently. Here is the [BnFnotation] for the language.

# Relational operators
Standard relational operators apply with same precedence as usual.
||*Meaning     _'    || '_Operator *||
||Less than       ||<         ||
||Less or equal   ||<=        ||
||Greater than    ||>         ||
||Greater or equal||>=        ||
||Equal           ||==        ||
||Different than  ||!=        ||

# Logical operators
Standard logical operators apply with same precedence as usual.
||*Meaning_' || '_Operator *||
||And	  || and      ||
||Or	  || or       ||
||Xor	  || xor      ||
||Not	  || not      ||

For events in the timeline of events, using *and_' or '_or* operators denotes that any ordering between these events is possible.

# Arithmetic operators
Standard arithmetic operators apply and parenthesis are used for non-obvious precedence

# Temporal operators
We want to be able to denote order and concurrency of events and state changes, and duration of events.
||*Meaning	_'                   ||''' Operator and example '''|| '_Precedence* ||
||A occurs after B                 || B -> A               || Highest for binary operators ||
||A and B occur concurrently       || A | | B              || Lowest for binary operators  ||           
||A lasts T time	           || A,,T,,               || Same as not                  || 
||A occurs T time after B	   || B ->,,T,, A          || Same as -> operator          ||

# Existential, cardinality and modal operators
We want to be able to denote how many objects or events of a given type must/may occur. This is usually specified in front of events/state change definitions.
||*Meaning_'	                     || '_Operator and example* || 
||Every object A	             || each A               ||
||Some objects A	             || some A               ||
||Some object A called a1            || some A a1            ||

Cardinality and modality of occurence:

||*Meaning_'	                     || '''Operator and example''' || '_Precedence* || 
||A must occur	                     || A                    || None, no explicit operator ||
||A may occur	                     || [A]                  || Same as parentheses        ||
||Exactly N objects/events of type A || |A|,,N,,             ||Same as parentheses        ||
||At least N objects/events of type A|| |A|,,>=N,,           ||Same as parentheses        ||
||At most N objects/events of type A || |A|,,<=N,,           || Same as parentheses        ||
# Conditions and loops
We want to be able to express that an event occurs under certain conditions.
||*Meaning_'||'''Operator and example''' || '_Precedence* || 
||if condition cond holds then A occurs else B occurs ||	if cond then A else B || Lowest ||
||Repeat some action while condition cond holds	      ||do A while cond || Same as if ||
||A for which condition cond holds || A | cond || Same as not ||

An object has a type, may have certain variables associated with it, and an initial state. Logical topology describes (each item is in separate section):
* Object types, variables of interest and initial state. A variable is a new object.
* Object aliases if needed: an object in a given state or whose variable(s) have some given value(s) can be assigned an alias for easier human manipulation such as a Vulnerable node that is in infected state is called Infected node.
* Cardinality of objects using the notation specified above
* Topological relationships between objects: one example is *collocated* function. Users can define other relationship functions such as A and B being on the same subnet, A being a leaf node, etc. All function definitions reside in the domain library.

|| *Meaning_' ||	'_Operator and example* ||
||A is of type X ||	A extends X          ||
||A’s initial state is Z ||	A :Z} ||
||A has an object M of type Y and with initial value I ||	A :I} ||
||B is an alias for A in state C	|| B :C}||
||There are N objects of type A	|| |A|,,N,, ||
||A is different than B||	A != B||
||A and B reside on the same physical node	||collocated(A,B)||

State name may be just a symbolic name or it may be associated with an object variable holding some value. An object in a given state always responds in the same manner to the same stimuli. Both state and variable values can be changed during a state change. 
States are really there just as a memory of which actions object has undergone and what may come next. For example once the Vulnerable object is
in infected state it starts scanning.


State change names start with s followed by a number. They are defined within curly brackets by specifying the object and its new state, like this:

`s1 :newstate`}


Some events may lead to transitions between states, others occur but don’t change object state. Each event has the type, the origin and one or more destinations. These are specified within curly brackets. Event names start with e followed by a number. Each event may have multiple parameters. Example of an event definition:

`e1 :TYPE, origin {object}, {par_i=val_i`}}}

We should have a notion of events matching each other, like a reply matches a request. To support this there's a function *match(event1, event2)* which is defined in the domain library for each request/reply pair. To do this properly, the definition of
event TYPE t1 and the event match relation t1-rel should be bound
together when they are defined. In the timeline of events part of a meta-description if we want a reply to match a request we must explicitly say so using *such that* operator or have a condition on reply matching the request to proceed with the rest of the events in the sequence.

A meta-description starts with 

*define MDName:*

and may be followed by import statements if it uses/extends some other metadescriptions, such as

*define MDName: import MD1 m1, MD2 m2*

It has the following sections

*Logical topology*

   *Objects*
   
    All relevant objects are defined here. If some are imported from other meta-descriptions and use the same name, are of the same type and have the same initialization they are not mentioned. If some are imported but the name/type/initialization are changed they are mentioned here, linked to the object they extend from the imported meta-description and any changes are noted. For example:

    Name :Assigned}

   *Cardinality*

   This section describes how many objects of a given type we have in the scenario. If we imported some from other meta-descriptions and don't want to change their cardinality nothing needs to be said here about them.

   *Relationships*
  
   Relationships between objects are defined here. For now we use only *collocated* function.

*Timeline of events*

   *Definitions*

   This section defines all events and states. We may use *each_', '_some* operators and aliases for state definitions. Event types may extend other event types. All events/states must be defined here. If we inherit some events from other meta-descriptions and customize inherited ones, we have to redefine them. In case of inheritance relevant events will be checked against both meta-descriptions. If we inherit events from other meta-descriptions as they are, without customizations, we can just note that without redefining them. For example if we imported from m1 that had defined event e2 as event of type INFO without any parameters we'd do the following in order to customize it:

   e1 :INFO, content = x}

   vs doing the following if we're not customizing:
  
   e1 := m1.e2


   If we are importing all events from a metadescription we don't have to say anything in this section.



   *Timeline*

   This section describes ordering of events, i.e. the scenario of the experiment. In case of inheritance, the inherited scenario should be possible to obtain from the given one. If we are combining two or more meta-descriptions we can either interleave their events manually such as

    m1.e1 -> m2.e1 -> m2.e2 -> m1.e3

  or we can say that all events from one meta-description occur in some given order with events from other meta-description, such as

  timeline(m1) -> timeline(m2)

  The above means that all events from m1 must happen before any events from m2.

  *Invariants*

  This section defines additional invariants - those that cannot be derived from logical topology and timeline of events sections above.