This page includes links to tools that have been useful to DETER users in the past. There is no guarantee that they will perform with current DETER software and they are listed for legacy purposes.

## Benchmarks

### DDoS Defense Benchmarks

Developed and maintained by University of Delaware, this tool contains:

* A benchmark suite with a set of scenarios to be used for defense evaluation, integrated with SEER,
* A set of performance metrics that characterize an attack's impact and a defense's performance, and
* A set of tools used for benchmark development, integration of benchmarks with the DETER testbed and calculation of performance metrics from tcpdump traces collected during DDoS experimentation.

* **Website**: <http://www.isi.edu/~mirkovic/bench> 
* **Runs on**: Any platform 
* **Best for**: Testing DDoS defenses 
* **For questions, contact**: <a href="mailto:sunshine@isi.edu">Jelena Mirkovic</a> at ISI

## Legitimate Traffic Generators

### <a name="seer"></a>SEER
The Security Experimentation EnviRonment (SEER), developed by SPARTA, Inc., is a GUI-based user interface to DETERLab, helping an experimenter to set up, script, and perform experiments in the DETER environment. The SEER back-end includes tools to generate legitimate traffic using Harpoon or custom-made Web, DNS, Ping, IRC, FTP and VoIP agents. Note that this tool is no longer supported and is offered as-is.

* **Website**: <http://seer.deterlab.net/trac> 
* **Runs on**: All platforms, written in Java 
* **Best for**: Legitimate traffic generation, DoS traffic generation, visualization of traffic levels in topology

### Tcpreplay
Tcpreplay is a suite of BSD licensed tools, which gives you the ability to inject previously captured traffic in libpcap format to test a variety of network devices. It allows you to classify traffic as client or server, rewrite Layer 2, 3 and 4 headers and finally replay the traffic back onto the network and through other devices such as switches, routers, firewalls, NIDS and IPS's. Tcpreplay supports both single and dual NIC modes for testing both sniffing and inline devices. 

* **Website**: <http://tcpreplay.synfin.net/trac/> 
* **Runs on**: UNIX-flavored OSes and Win32 with Cygwin 
* **Best for**: Replaying traces to regenerate same or similar traffic 
* **For questions, contact**: <a href="http://tcpreplay.synfin.net/trac/wiki/Support">Tcpreplay support</a>

### Webstone
Webstone, a benchmark owned by Mindcraft Inc., measures performance of web server software and hardware products. Webstone consists of a program called the webmaster which can be installed on a client in the network or on a separate computer. The webmaster distributes web client software as well as configuration files for testing to the client computers, that contact the web server to retrieve web pages or files in order to test web server performance. Webstone also tests operating system software, CPU and network speeds. While it was developed with the idea of measuring the performance of web servers, it can be used to generate background traffic in a network as the multiple clients keep contacting the server over a period of time thereby simulating web traffic in the network.

* **Website**: <http://www.mindcraft.com/webstone/> 
* **Runs on**: UNIX-flavored OSes and Windows NT 
* **Best for**: Web traffic generation

### Harpoon
Harpoon, developed at University of Wisconsin, is a flow-level traffic generator. It uses a set of distributional parameters that can be automatically extracted from Netflow traces to generate flows that exhibit the same statistical qualities present in measured Internet traces, including temporal and spatial characteristics. Harpoon can be used to generate representative background traffic for application or protocol testing, or for testing network switching hardware. Note, however, that while traffic dynamics will resemble the one found in traces, Harpoon traffic runs over HTTP and application behavior may be different from the real one.

* **Website**: <https://github.com/jsommers/harpoon> 
* **Runs on**: UNIX-flavored OSes 
* **Best for**: Generating traffic from traces or from high-level specifications.

 
## DoS and DDoS Attack Traffic Generators

### SEER
(<a href="#seer">See above</a>) SEER generates attack traffic using the Flooder tool, developed by SPARTA, and the Cleo tool developed by UCLA. Look at SEER's Web page for a more detailed description of these tools.

The following collection of real DDoS tools has little new to offer with regard to attack traffic generation, when compared to SEER's capabilities. In general, SEER can generate same traffic variations as this tools, and is easier to control and customize. If, however, you are testing a defense that looks at control traffic of DoS networks these tools may be useful to you. They are all downloadable from third-party Web sites and are not maintained.

### Stacheldraht
Stacheldraht combines features of Trinoo and TFN tools and adds encrypted communication between the attacker and the masters. Stacheldraht uses TCP for encrypted communication between the attacker and the masters, and TCP or ICMP for communication between master and agents. Another added feature is the ability to perform automatic updates of agent code. Available attacks are UDP flood, TCP SYN flood, ICMP ECHO flood and Smurf attacks.

* **Website**: <http://packetstormsecurity.org/distributed/stachel.tgz>

### Mstream
Mstream generates a flood of TCP packets with the ACK bit set. Masters can be controlled remotely by one or more attackers using a password- protected interactive login. The communications between attacker and masters, and a master and agents, are configurable at compile time and have varied signif- icantly from incident to incident. Source addresses in attack packets are spoofed at random. The TCP ACK attack exhausts network resources and will likely cause a TCP RST to be sent to the spoofed source address (potentially also creating outgoing bandwidth consumption at the victim).

* **Website**: <http://packetstormsecurity.org/distributed/mstream.txt>

## Topology Generators and Convertors

### Rocketfuel-to-ns
Rocketfuel-to-ns, developed by Purdue University, is a utility to convert RocketFuel-format data files into a set of configuration files runnable on am emulation testbed like the DETER testbed. Experiment configurations generated with this tool have the advantage of not being totally synthetic representations of the Internet; they provide a router-level topology based off real measurement data. This distribution also contains many sample NS files that represent real AS topologies.

* **Website**: <http://www.cs.purdue.edu/homes/fahmy/software/rf2ns/index.html> 
* **Runs on**: UNIX 
* **Best for**: Collecting real AS topologies and importing them into DETERLab.

### Inet
Inet, developed by University of Michigan, is a generator of representative Autonomous System (AS) level Internet topologies.

* **Website**: <http://topology.eecs.umich.edu/inet/> 
* **Runs on**: FreeBSD, Linux, Mac OS and Solaris 
* **Best for**: Synthetic topology generation, following a power law.

### Brite
Brite, developed by Boston University, is a generator of flat AS, flat Router and hierarchical topologies, interoperable with various topology generators and simulators.

* **Website**: <http://www.cs.bu.edu/brite/> 
* **Best for**: Synthetic topology generation using different models and a GUI.

### GT-ITM
GT-ITM: Georgia Tech Internetwork Topology Models, developed by Georgia Tech, generates graphs that model the topological structure of internetworks.

* **Website**: <http://www.cc.gatech.edu/projects/gtitm/> 
* **Runs on**: SunOS and Linux
* **Best for**: Synthetic topology generation for small size topologies.