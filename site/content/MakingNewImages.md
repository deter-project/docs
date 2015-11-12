#  Hints for Making New OS Images
First, 40% of our nodes are physically located 400 miles away from the boss and users servers. Please, *never* try to create an image from a node located in Berkeley instead of one located at ISI.  The ones located at Berkeley and their types all begin with the letter _b'', eg ''bpc183'' for a node,  ''bpc2133_ for a type.

Secondly, after you have created an image, try loading it back and watching what happens through the serial port.

Consider creating a *two* node experiment, one to create the image and the other to load it back.

There is a command called "os_load" available on the _users_ server:
	
	 users% which os_load
	 /usr/testbed/bin/os_load
	 users% os_load -h
	 option -h not recognized
	 os_load [options] node [node ...]
	 os_load [options] -e pid,eid
	 where:
	     -i    - Specify image name; otherwise load default image
	     -p    - Specify project for finding image name (-i)
	     -s    - Do *not* wait for nodes to finish reloading
	     -m    - Specify internal image id (instead of -i and -p)
	     -r    - Do *not* reboot nodes; do that yourself
	     -e    - Reboot all nodes in an experiment
	   node    - Node to reboot (pcXXX)
	
while the second node is reloading, watch its progress in real time using the console command from the _users_ server, ie
	
	users% console pc193
	
A third general suggestion is that if you think you've got a good image, but it flounders while coming up , you can create another experiment with an ns directive that says "Even if you think the node has not booted, let my experiment swap in anyway;" then you may be able to log in through the console and figure out what went wrong. An example of this is:
	
	tb-set-node-failure-action $nodeA "nonfatal"
	
A fourth suggestion is to create whole disk images on a smaller machine rather than a single partition image.
