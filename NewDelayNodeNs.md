# Introduction

[DETER](http://www.isi.deterlab/net) extends the [Emulab](http://www.emulab.net) model of links and LANs with static delay and loss properties to include probabalistic losses and delays.  This allows researchers to model large networks with fewer resources.  Researchers can change the distributions on the fly in similar ways to changing static delay and loss parameters.  The facility is based on the Click modular router, though this is transparent to researchers.

Delays can be distributed Normally, Exponentially, or using a Poisson distribution.  Losses follow a two-state model with threshold poisson probabilities for entering and leaving the burst dropping state.  The two-state loss model is described in more detail below. Delays can also be static and losses uniform to replicate the existing behavior.  Similarly, the new facility will limit bandwidths.

Researchers can make use of this facility using the commands below. The new command syntax is similar to the old make-lan to make an easy transition. However, it doesn't require the user to memorise the position of the parameters.

# make-deter-lan
The new delay node supports variable delays based on various probability distributions such as: Poisson, Normal and Exponential. Moreover, it
enhances some of the functions for a more realistic link emulation. "make-deter-lan" command create a LAN that uses this new delay node to control bandwidth, add probabilistic delays and induces sophisticated loss pattern. make-deter-lan parameters are the nodelist, bandwidth, delay properties, and loss pattern description. To create a LAN, connecting three nodes, with a static delay of 30ms, 1Gb bandwidth and a static loss of threshold 0.1 and a rate of 1.
	
	        set ns [ new Simulator] 
	        source tb_compat.tcl
	
	        set nodeA [$ns node]
	        set nodeB [$ns node]
	        set nodeC [$ns node]
	
	        set lan1 [$ns make-deter-lan "$nodeA $nodeB $nodeC" bw 1Gb delay static mean 30ms loss static threshold 0.1 rate 1]
	        $ns rtproto Static
	        $ns run
	

By swapping an experiment with the above NS file and pinging nodeB from nodeA, you would get something like the following:
	
	ping nodeb -c 1000000
	PING nodeB-lan1 (10.1.1.3) 56(84) bytes of data.
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=1 ttl=64 time=60.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=2 ttl=64 time=60.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=3 ttl=64 time=60.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=4 ttl=64 time=60.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=5 ttl=64 time=60.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=6 ttl=64 time=60.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=7 ttl=64 time=60.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=8 ttl=64 time=60.1 ms
	.....
	.....
	.....
	.....
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16951 ttl=64 time=60.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16953 ttl=64 time=60.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16954 ttl=64 time=60.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16956 ttl=64 time=60.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16957 ttl=64 time=60.2 ms
	
	--- nodeB-lan1 ping statistics ---
	1000000 packets transmitted, 817371 received, 18% packet loss, time 12880005ms
	rtt min/avg/max/mdev = 60.111/60.185/103.070/0.338 ms, pipe 8, ipg/ewma 12.880/60.231 ms
	
	
make-deter-lan receives the arguments in any order e.g you could provide delay parameters before loss one, however, nodelist should be the first. Note that bandwidth parameters have to be preceded by "bw", delay with "delay", and loss with "loss". Also, specifying delay and loss parameters should be preceded by some keywords e.g mean, std (standard deviation), threshold (loss threshold), and rate. The user only have to provide the nodelist, others are optional, but once she provide any it has to be provided in the correct format.The command is described by:
	
	        make-deter-lan <nodelist> [bw <bandwidth> ] [delay <type> mean <mean> [std <standard deviation>] ] [loss <dropmode> threshold <threshold> rate <rate>]  
	
	
Delay types are : *static_', '''normal''', '''poisson''' and '_exponential*. Note that normal requires standard deviation, which is set to zero if not provided.
Loss dropmodes are *static_' and '_poisson*. Also notice that the default bandwidth is 1Gb.

By choosing a static delay with 100ms, the LAN would delay each packet by 100ms. Normal delays packets based on a normal distribution fashion, with a mean and a standard variation. Plotting the travel time of the packet you would get a bell-curved graph. Poisson delays packet based on a discrete poisson distribution with Lambda=mean, and so does the exponential.

## Loss Model

The loss model is more sophisticated.It adds the ability to drop packets based on different parameters. The user can adjust the parameters to achieve any desirable pattern. Dropping packet is based on a threshold x; x ≥ 0.000001 and x ≤ 1 which is given by the user. For each received packet, if not in the dropping state, the element generates a uniform random number r ∈ [0.000001, 1] if r ≤ x then it enters the dropping mode. It has to drop σ packets to leave the dropping state. σ is either a static value given by the user or a random number belongs to a Poisson distribution. To set up a dropping mode with static dropping rate the dropmode should be set to *static*.

# Examples

	
	        #Example 1
	        make-deter-lan "$nodeA $nodeB " bw 1Gb delay static mean 100ms
	
Ping from nodeA to nodeB
	
	ping nodeb -c 100
	PING nodeB-lan1 (10.1.1.3) 56(84) bytes of data.
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=1 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=2 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=3 ttl=64 time=200 ms
	......
	......
	......
	

	     
	        #Example 2
	        make-deter-lan "$nodeA $nodeB " bw 1Gb delay normal mean 100ms std 5
	
     Ping from nodeA to nodeB
	     
	ping nodeb
	PING nodeB-lan1 (10.1.1.3) 56(84) bytes of data.
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=1 ttl=64 time=205 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=2 ttl=64 time=195 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=3 ttl=64 time=201 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=4 ttl=64 time=201 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=5 ttl=64 time=202 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=6 ttl=64 time=193 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=7 ttl=64 time=211 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=8 ttl=64 time=209 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=9 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=11 ttl=64 time=190 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=10 ttl=64 time=202 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=12 ttl=64 time=197 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=13 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=14 ttl=64 time=198 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=15 ttl=64 time=205 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16 ttl=64 time=195 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=17 ttl=64 time=205 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=18 ttl=64 time=197 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=19 ttl=64 time=202 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=20 ttl=64 time=210 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=21 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=23 ttl=64 time=185 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=22 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=24 ttl=64 time=202 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=25 ttl=64 time=203 ms
	......
	......
	

	
	        #Example 3
	        make-deter-lan "$nodeA $nodeB " bw 1Gb delay poisson mean 100ms
	
        Ping from nodeA to nodeB
	
	ping nodeb -i 0 -c 100
	PING nodeB-lan1 (10.1.1.3) 56(84) bytes of data.
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=1 ttl=64 time=190 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=2 ttl=64 time=202 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=3 ttl=64 time=195 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=4 ttl=64 time=190 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=5 ttl=64 time=205 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=6 ttl=64 time=199 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=7 ttl=64 time=211 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=8 ttl=64 time=210 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=9 ttl=64 time=208 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=11 ttl=64 time=190 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=12 ttl=64 time=199 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=10 ttl=64 time=222 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=14 ttl=64 time=183 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=13 ttl=64 time=197 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=15 ttl=64 time=194 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16 ttl=64 time=211 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=17 ttl=64 time=201 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=19 ttl=64 time=204 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=20 ttl=64 time=196 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=21 ttl=64 time=187 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=22 ttl=64 time=185 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=18 ttl=64 time=238 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=23 ttl=64 time=189 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=25 ttl=64 time=170 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=24 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=26 ttl=64 time=182 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=28 ttl=64 time=184 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=27 ttl=64 time=201 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=29 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=30 ttl=64 time=207 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=31 ttl=64 time=203 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=32 ttl=64 time=208 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=34 ttl=64 time=217 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=33 ttl=64 time=228 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=35 ttl=64 time=221 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=37 ttl=64 time=209 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=36 ttl=64 time=225 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=38 ttl=64 time=206 ms
	
	

	
	        #Example 4
	        make-deter-lan "$nodeA $nodeB " bw 1Gb delay exponential mean 15ms
	
        Ping from nodeA to nodeB
	
	ping nodeb -c 100
	PING nodeB-lan1 (10.1.1.3) 56(84) bytes of data.
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=4 ttl=64 time=20.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=3 ttl=64 time=40.9 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=5 ttl=64 time=41.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=6 ttl=64 time=37.0 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=7 ttl=64 time=31.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=9 ttl=64 time=15.9 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=10 ttl=64 time=16.8 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=8 ttl=64 time=45.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=11 ttl=64 time=17.6 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=12 ttl=64 time=11.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=13 ttl=64 time=20.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=15 ttl=64 time=11.8 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=14 ttl=64 time=30.0 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=16 ttl=64 time=15.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=17 ttl=64 time=9.96 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=18 ttl=64 time=15.8 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=19 ttl=64 time=7.09 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=20 ttl=64 time=26.8 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=21 ttl=64 time=22.9 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=23 ttl=64 time=9.34 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=22 ttl=64 time=37.3 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=27 ttl=64 time=1.50 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=25 ttl=64 time=31.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=26 ttl=64 time=18.7 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=24 ttl=64 time=52.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=28 ttl=64 time=35.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=30 ttl=64 time=16.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=31 ttl=64 time=14.9 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=29 ttl=64 time=48.3 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=33 ttl=64 time=14.0 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=32 ttl=64 time=26.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=35 ttl=64 time=16.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=36 ttl=64 time=13.6 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=34 ttl=64 time=48.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=37 ttl=64 time=26.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=38 ttl=64 time=18.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=39 ttl=64 time=10.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=40 ttl=64 time=15.9 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=42 ttl=64 time=1.75 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=43 ttl=64 time=16.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=44 ttl=64 time=12.0 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=41 ttl=64 time=54.7 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=45 ttl=64 time=23.8 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=47 ttl=64 time=12.6 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=46 ttl=64 time=26.7 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=49 ttl=64 time=25.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=48 ttl=64 time=55.9 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=52 ttl=64 time=17.3 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=51 ttl=64 time=36.8 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=50 ttl=64 time=52.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=54 ttl=64 time=22.8 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=53 ttl=64 time=41.7 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=56 ttl=64 time=28.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=55 ttl=64 time=71.2 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=57 ttl=64 time=43.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=58 ttl=64 time=32.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=60 ttl=64 time=1.35 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=61 ttl=64 time=12.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=62 ttl=64 time=8.31 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=64 ttl=64 time=3.25 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=65 ttl=64 time=0.856 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=59 ttl=64 time=51.5 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=66 ttl=64 time=8.79 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=63 ttl=64 time=52.1 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=68 ttl=64 time=16.9 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=69 ttl=64 time=16.4 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=67 ttl=64 time=41.2 ms
	......
	......
	......
	......
	

	
	        #Example 5
	        make-deter-lan "$nodeA $nodeB " bw 1Gb delay normal mean 100ms std 5 loss poisson threshold 0.01 rate 5
	
        Ping from nodeA to nodeB
	
	
	ping nodeb
	PING nodeB-lan1 (10.1.1.3) 56(84) bytes of data.
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=2 ttl=64 time=188 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=1 ttl=64 time=206 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=3 ttl=64 time=205 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=5 ttl=64 time=185 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=4 ttl=64 time=208 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=6 ttl=64 time=203 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=7 ttl=64 time=195 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=8 ttl=64 time=195 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=9 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=10 ttl=64 time=200 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=11 ttl=64 time=196 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=12 ttl=64 time=196 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=14 ttl=64 time=195 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=13 ttl=64 time=207 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=18 ttl=64 time=186 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=17 ttl=64 time=209 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=19 ttl=64 time=199 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=20 ttl=64 time=203 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=24 ttl=64 time=195 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=25 ttl=64 time=204 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=26 ttl=64 time=189 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=28 ttl=64 time=198 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=27 ttl=64 time=219 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=29 ttl=64 time=205 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=30 ttl=64 time=208 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=31 ttl=64 time=202 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=32 ttl=64 time=208 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=33 ttl=64 time=203 ms
	......
	......
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=43 ttl=64 time=197 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=44 ttl=64 time=202 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=47 ttl=64 time=198 ms
	64 bytes from nodeB-lan1 (10.1.1.3): icmp_seq=48 ttl=64 time=197 ms
	......
	......
	--- nodeB-lan1 ping statistics ---
	41765 packets transmitted, 37767 received, 9% packet loss, time 582211ms
	rtt min/avg/max/mdev = 162.135/200.201/228.616/7.138 ms, pipe 19, ipg/ewma 13.940/199.137 ms
	
	
