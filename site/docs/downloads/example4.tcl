source tb_compat.tcl
set ns [new Simulator]

# Create the center node (named by its variable name)
set center [$ns node]
# The center node is a process
tb-add-node-attribute $center containers:node_type process

# Connect 9 satellites
for { set i 0} { $i < 9 } { incr i} {
    # Create node n-1 (tcl n($i) becomes n-$i in the experiment)
    set n($i) [$ns node]
    # Satellites are qemu nodes - except for n-9 which is physical
    if { $i < 8 } { 
  tb-add-node-attribute $n($i) containers:node_type qemu
    } else {
  tb-add-node-attribute $n($i) containers:node_type embedded_pnode
    }

    # Connect center to $n($i)
    ns duplex-link $center $n($i) 100Mb 10ms DropTail
}

# Creation boilerplate
$ns rtptoto Static
$ns run
