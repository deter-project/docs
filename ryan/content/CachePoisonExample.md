The attacker poisons a DNS cache to take over authority for a given domain. The attacker then creates a phishing page and tries to steal user's usernames/passwords. There are two classes of experiments that need to be combined:
    a. an experiment where a DNS cache is poisoned, subclass of cache poisoning experiments
    b. an experiment where a phishing attack is conducted via a Web page to steal usernames/passwords

# Example 2: DNS cache poisoning for phishing

This example used two metadescriptions. Let's go through each of them. This example is written in [CurrentlyProposedLanguage]. 

## Cache poisoning metadescription

*define cachePoisoning:*
 
*Logical topology:* 

    *Objects:*

      Attacker extends Node
  
      Name, fakeResource extends String

      Cache extends Object

      Cache := {String[] records}

    *Cardinality:*

      |Attacker|,,1,,

      |Name|,,1,,

      |fakeResource|,,1,,

      |Cache|,,1,,

    *Relationships:*

      not collocated(Cache, Attacker)


*Timeline of events: *

  *Definitions:*

    Attacker a, Cache c, Name n, fakeResource fr

    e1 :REPLY, origin c, content = (n=fr)}

    s1 := {c.records += (n=fr)} 

  *Timeline:*

    e1 -> s1

*Invariants:*    Nothing in addition to the topology and timeline above.

## DNS Cache poisoning metadescription

  This is a special case of cache poisoning where the target is DNS cache. 

*define DNSCachePoisoning: import cachePoisoning cp*
 
*Logical topology:* 

  *Objects:*

    Auth extends Node

    (Name extends DNSName, Name := cp.Name, fakeIP extends IPAddress, FakeIP := cp.fakeResource) xor

    (Name extends DNSName, domain(Name) := cp.Name, fakeAuth extends DNSName,  fakeAuth := cp.fakeResource)

    RealIP extends IPAddress

    victimCache extends Object, victimCache := cp.Cache
 
    victimCache := {DNSRecord[] records}

    authCache extends Object

    authCache :{Name=RealIP, auth(domain(Name)) = Auth}

  *Cardinality:*


    |Auth|,,1,,

    |RealIP|,,1,,

    |authCache|,,1,,

  *Relationships:*

    not collocated(victimCache, Auth)
 
    collocated(authCache, Auth)


*Timeline of events: *

  *Definitions:*

    DNSREQUEST extends REQUEST

    DNSREPLY extends REPLY

    Attacker att, Auth auth, Name n, FakeIP fIP, fakeAuth fauth, RealIP rIP, victimCache vc, authCache ac

      e1 :DNSREQUEST, origin vc, content = IP(n)?}

      e2 :DNSREQUEST, origin auth, content = IP(n)?}

      e3 :DNSREPLY, origin vc, content = {n=rIP}}

      e4 :DNSREPLY, origin vc, content = {n=unknown}}

      e5 :DNSREPLY, origin vc, content fakeAuth}}

      s1 :fakeAuth)}

      e6 :DNSREPLY, origin vc, content = {n=fIP}}

      s2 :=  cp.s1, s1 := {vc.records += (n=fIP)}

  *Timeline:*

      e1 -> e2 -> (e5 | matches(e5,e2) -> s1 -> e4 xor e6 | matches(e6, e2) -> s2 -> e3) 


*Invariants:*    Nothing in addition to the topology and timeline above.

## Confidential access metadescription
 
   The phishing attempt is essentially same as presenting a valid page to the user that asks for confidential info - it's just that the location of that page is not as user expected. 

*define confidentialAccess:*

*Logical topology:* 

  *Objects:*

      User extends Human

      Server extends webServer

      Page extends webPage

      Public, Confidential extends String

  *Cardinality:*

    |User|,,1,,

    |Server|,,1,,

    |Page|,,>=1,,

    |Public|,,1,,

    |Confidential|,,1,,

  *Relationships:*

    collocated(Page, Server)

*Timeline of events: *

  *Definitions:*

    User u, Server s, Public p, Confidential c, Page wp

      e1 :WEBREQUEST, origin s, content = url(wp)}

      e2 :WEBREQUEST, origin u, content = (public?, confidential?)}

      e3 :WEBREPLY, origin s, content = (public=x, confidential=y)}

      e4 :WEBREPLY, origin u, content = wp}

  *Timeline:*

      e1 -> e2 -> e3 -> if (x # p and y c) then e4
 

*Invariants:*    Nothing in addition to the topology and timeline above.

## Experiment design

Now I'm a user who wants to design an experiment. I need to combine two metadescriptions (DNS cache poisoning and phishing) and somehow tie them down to generator choices. To combine I'll do something like this:

_'define Phishing: import DNSCachePoisoning dcp, confidentialAccess ca_
  
*Logical topology:* 

  *Objects:*
    
    dcp.FakeIP := ip(ca.Server)

  *Cardinality:*

  *Relationships:*

*Timeline of events: *

  *Definitions:*

  *Timeline:*

      timeline(dcp) -> timeline(ca)
 

*Invariants:*    Nothing in addition to the topology and timeline above.

  
    
