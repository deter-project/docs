set ns [new Simulator]
source tb_compat.tcl

set magi_start "sudo python /share/magi/dev/magi_bootstrap.py -p /share/magi/dev/"

#Server Nodes
set NS 10 
for {set i 0 } {$i < $NS } { incr i } {  
        set s($i) [$ns node]
        tb-set-node-startcmd $s($i) "$magi_start" 
        tb-set-node-os $s($i) Ubuntu-STD
        tb-set-hardware $s($i) MicroCloud
}

#Noise Generating Nodes
set NUC 50
for {set i 0 } {$i < $NUC } { incr i } {  
        set uc($i) [$ns node]
        tb-set-node-startcmd $uc($i) "$magi_start" 
        tb-set-node-os $uc($i) Ubuntu-STD
        tb-set-hardware $uc($i) MicroCloud
}

#Control Client Node
set NC 1
for {set i 0 } {$i < $NC } { incr i } {  
        set c($i) [$ns node]
        tb-set-node-startcmd $c($i) "$magi_start" 
        tb-set-node-os $c($i) Ubuntu-STD
        tb-set-hardware $c($i) MicroCloud
}

#Routers
set rs [$ns node] 
tb-set-node-startcmd $rs "$magi_start" 
tb-set-node-os $rs Ubuntu-STD
tb-set-hardware $rs MicroCloud

set rc [$ns node] 
tb-set-node-startcmd $rc "$magi_start" 
tb-set-node-os $rc Ubuntu-STD
tb-set-hardware $rc MicroCloud

# Links
set link(1) [$ns duplex-link $rs $rc 1000000.0kb 0.0ms DropTail]
set link(2) [$ns duplex-link $rs $s(0) 1000000.0kb 0.0ms DropTail]
set link(3) [$ns duplex-link $rc $uc(0) 1000000.0kb 0.0ms DropTail]  
set link(4) [$ns duplex-link $rc $c(0) 1000000.0kb 0.0ms DropTail]  
 
set l 5
for {set i 1 } {$i < $NS } { incr i } {
        set link($l) [$ns duplex-link $s($i) $s([expr $i/3]) 1000000.0kb 0.0ms DropTail]
        incr l
}

for {set i 1 } {$i < $NUC } { incr i } {
        set link($l) [$ns duplex-link $uc($i) $uc([expr $i/3]) 1000000.0kb 0.0ms DropTail]
        incr l
} 

for {set i 1 } {$i < $NC } { incr i } {
        set link($l) [$ns duplex-link $c($i) $c([expr $i/3]) 1000000.0kb 0.0ms DropTail]
        incr l
} 
 
$ns rtproto Static
$ns run
