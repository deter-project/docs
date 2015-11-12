Power cycle a node, on "boss":
	
	 power cycle <node>
	

Add (or remove) a user to (from) the wheel group:
	
	 wap unixgroups -a [user] wheel
	 Usage: /usr/testbed/sbin/unixgroups <-h | -p | < <-a | -r> uid gid...> >
	  -h            This message
	  -p            Print group information
	  -a uid gid... Add a user to one (or more) groups
	  -r uid gid... Remove a user from one (or more) groups
	

Check the syntax of an ns file:
	
	 nscheck nsfile
	  where:
	  nsfile    - Path to NS file you to wish check for parse errors
	

Mark nodes "hwdown", on "boss".
	
	 (Make sure that /usr/testbed/sbin is in your path.)
	 wap sched_reserve emulab-ops hwdown [list-of-nodes]
	                              ^ desired state
	 
	 nfree emulab-ops reloading [list-of-nodes]
	                  ^ current state
	

To allocate node(s) that are currently "free", on "boss":
	 
	 nalloc emulab-ops hwdown [list-of-nodes]
	                   ^ desired state
	
	 Usage: nalloc [-v] [-p] <pid> <eid> <node> <node> <...>
	  -p enables partial allocation mode
	  -v enables debugging output
	

Get switch statistics (such as packet counts) for an experiment.  On "users":
	
	 portstats <proj> <exp>
	 prints statistics for all experimental interfaces in an experiment. 
	 portstats -h
	 lists the other options.
	

Load an image onto node(s) in an experiment.
	
	 os_load [options] node [node ...]
	 os_load [options] -e pid,eid
	  where:
	  -i    - Specify image name; otherwise load default image
	  -p    - Specify project for finding image name (-i)
	  -s    - Do *not* wait for nodes to finish reloading
	  -m    - Specify internal image id (instead of -i and -p)
	  -r    - Do *not* reboot nodes; do that yourself
	  -e    - Reboot all nodes in an experiment
	  -z 1  - Zero unused portions of the disk.
	          (Currently only on "boss".)
	  node  - Node(s) to reboot (pcXXX)
	
	  Wrapper Options:
	   --help      Display this help message
	   --server    Set the server hostname
	   --login     Set the login id (defaults to $USER)
	   --debug     Turn on semi-useful debugging
	

Schedule a Node's future assignment(s)
	
	 wap sched_reserve <pid> <eid> <node> [<node> ...]
	
Schedule a OS installation
	
	 wap sched_reload (see sched_reload --help)
	

Release a node from it's current assignment.
	
	 wap nfree <pid> <eid> [<node>] [<node>...]
	 ***don't forget the node name or you'll free 
	 ***all the nodes in the project/group
	