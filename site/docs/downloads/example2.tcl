source tb_compat.tcl
 set ns [new Simulator]
 
 # Create the center node (named by its variable name)
 set center [$ns node]
 
 # Connect 7 satellites
 for { set i 0} { $i < 7 } { incr i} {
     # Create node n-1 (tcl n($i) becomes n-$i in the experiment)
       set n($i) [$ns node]
       # Connect center to $n($i)
       ns duplex-link $center $n($i) 100Mb 10ms DropTail
   }
   
# Creation boilerplate
$ns rtproto Static
$ns run
