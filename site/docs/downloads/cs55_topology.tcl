set ns [new Simulator] 
source tb_compat.tcl 

set magi_start "sudo python /share/magi/current/magi_bootstrap.py" 

set A 50 
set clanstr ""

for {set i 1 } {$i <= $A } { incr i } {  
        set clientnode($i) [$ns node]
        tb-set-node-startcmd $clientnode($i) "$magi_start" 
        append clanstr "$clientnode($i) "
} 


set A 5 
set slanstr ""

for {set i 1 } {$i <= $A } { incr i } {  
        set servernode($i) [$ns node]
        tb-set-node-startcmd $servernode($i) "$magi_start" 
        append slanstr "$servernode($i) "
}

set router [$ns node] 

set lanC [$ns make-lan "router $clanstr" 10Mb 0ms]
set lanS [$ns make-lan "router $slanstr" 10Mb 0ms]



$ns rtproto Static
$ns run
