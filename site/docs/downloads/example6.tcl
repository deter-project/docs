source tb_compat.tcl
set ns [new Simulator]

set center [$ns node]
tb-add-node-attribute $center "containers:PartitionPass" 0


for { set i 0} { $i < 3 } { incr i} {
    set lanlist $center
    for { set j 0 } { $j < 20} { incr j } {
  set idx [expr $i * 20 + $j]
  set n($idx) [$ns node]
  tb-add-node-attribute $n($idx) "containers:PartitionPass" [expr $i + 1]
  lappend lanlist $n($idx)
    }
    set lan($i) [$ns make-lan [join $lanlist " "] 100Mb 0]
}

# Creation boilerplate
$ns rtptoto Static
$ns run
