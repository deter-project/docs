An ARP spoofing experiment where the attacker puts himself in between two nodes and then modifies their traffic. There are two classes of experiments that need to be combined:
    a. an experiment where ARP poisoning happens between two nodes by the attacker
    b. an experiment where an attacker changes traffic passing through it


# Example 3: ARP poisoning with MITM attack

This example used two metadescriptions. The first was ARP poisoning which is a flavor of cache poisoning, and the other is MITM attack. This example is written in [CurrentlyProposedLanguage].


## ARP poisoning metadescription

  This is a special case of cache poisoning where the target is ARP cache.

*define ARPPoisoning: import cachePoisoning cp*

*Logical topology:* 

    *Objects:*
  
      IP := cp.Name, IP extends IPAddress

      fakePA := cp.fakeResource, fakePA extends MACAddress

      Cache := cp.Cache, Cache := {ARPRecord[] records}

    *Cardinality:*

    *Relationships:*

*Timeline of events: *

  *Definitions:*

    Attacker a, IP ip, fakePA fpa, Cache c

      e1 :ARPREPLY, origin c, content fpa)}

      s1 := cp.s1

  *Timeline:*

      timeline(cp)
 
*Invariants:* Nothing in addition to the topology and timeline above.

## MITM attack metadescription

*define MITM:*

*Logical topology:* 

    *Objects:*

      Attacker, Node1, Node2 extends Node

    *Cardinality:*

      |Attacker|,,1,,
  
      |Node1|,,1,,

      |Node2|,,1,,

    *Relationships:*


*Timeline of events: *

  _'Definitions:_

    Attacker a, Node1 n1, Node2 n2

      e1 :MSG, origin a, content = x}

      e2 :MSG, origin n2, content = modify(x)}

      e3 :MSG, origin a, content = y}

      e4 :MSG, origin n1, content = modify(y)}

  *Timeline:*

      e1 -> e2 and e3 -> e4 

*Invariants:*    Nothing in addition to the topology and timeline above.

## Experiment design

Now I'm a user who wants to design an experiment. I need to combine two metadescriptions (ARP poisoning and MITM attack) and somehow tie them down to generator choices. To combine I'll do something like this:

*define MITMwARP: import ARPPoisoning arp1, ARPPoisoning arp2, MITMAttack mitm*

*Logical topology:* 

    *Objects:*

      arp1.FakePA := mac(mitm.Attacker)

      arp1.IP := ip(mitm.Node2)

      arp2.fakePA := mac(mitm.Attacker)

      arp2.IP := ip(mitm.Node1)

    *Cardinality:*

    *Relationships:*

      collocated(arp1.Cache, mitm.Node1)	

      collocated(arp2.Cache, mitm.Node2)	
 
*Timeline of events: *

  _'Definitions:_

    (timeline(arp1) and timeline(arp2)) -> timeline(mitm)

  *Timeline:*

*Invariants:*    Nothing in addition to the topology and timeline above.

    
  
  
