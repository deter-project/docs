A worm infects some vulnerable hosts, they organize into a P2P botnet with some botmaster and start exchanging C&C traffic. Experimenter wants to observe the evolution of the botnet and the amount of traffic that master receives. There are two classes of experiments here that need to be combined together:
    a. an experiment where worm spreads and infects vulnerable hosts
    b. an experiment where some hosts organize into P2P network and somehow elect a leader who then sends commands to them and they may send reports back

# Example 1: Botnet

This example used two metadescriptions. Let's go through each of them. This example is written in [CurrentlyProposedLanguage].

## Worm spread metadescription

*define Worm:*

*Logical topology:* 
  
  *Objects:*

    VNode extends Node

    VNode :Vulnerable, Vulnerability vulnerability = x}

    INode :Infected}

  *Cardinality:*

    |INode|,,>=1,,
 
    |VNode|,,>=1,,

  *Relationships:*

   
*Timeline of events: *

   *Definitions:*
     
     each Inode i, some VNode v:
      
       e1 :SCAN, origin v, vulnerability = x }

       s1 :Infected}

   *Timeline:*
  
       e1 -> if (e1.vulnerability == v.vulnerability) then s1


*Invariants:* No additional ones are needed here.

## P2P w leader and C&C traffic metadescription

*define P2P:*

*Logical topology:* 

  *Objects:*

    Peer extends Node

    Peer :{}, Leader leader = none }

    Leader extends Peer

    Leader :{}  }

  *Cardinality:*

    |Peer|,,>=2,,

    |Leader|,,>=1,,

  *Relationships:*


*Timeline of events: *

  *Definitions:*
 
    PEERREQUEST extends REQUEST

    PEERREPLY extends REPLY

    each Peer peer1, some Peer peer2: 
 
      e1 :PEERREQUEST, origin peer2}

      e2 :PEERREPLY, origin peer1}

      s1 := {peer2.peers += peer1}

      s2 := {peer2.peers += peer1}
 
   each Peer x: 
      
      e3 :LEADERIS, origin x, Leader yourleader = leader}

      s3 :leader}

      e4 :HELLO, origin x.leader} 

      e5 :CMD, origin x, String cmd = c} 

      e6 :REPORT, origin x, String report = r} 

  *Timeline:*

      e1 -> [s1 and (e2 | matches(e2,e1)) -> s2] | | e3 -> s3 -> e4 -> e5 -> [e6]


*Invariants:* No additional ones are needed here.

## Experiment design

Now I'm a user who wants to design my experiment. I need to combine two metadescriptions and somehow tie them down to generator choices. To combine I need to specify how outputs of worm metadescription match inputs of P2P metadescription. I'll do something like this:

*define Botnet: import Worm w, P2P p2p*
 
*Logical topology:* 

  
  *Objects:*

    each p2p.Peer p and each w.Infected i

        p := i

  *Cardinality:*

  *Relationships:*
   
*Timeline of events: *

   *Definitions:*     

   *Timeline:*
  
     timeline(w) | | timeline(p2p)
     

*Invariants:* No additional ones are needed here.
    



i.e. each infected host becomes a peer.

