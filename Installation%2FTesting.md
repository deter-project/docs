The DETER distribution includes a small set of tests
to verify basic functionality of the newly-installed testbed.
Once *elabman* has created the first user,
that user may start the tests on the _users_ node
from within the build user's check-out source tree.
First:
	
	cd ~<builduser>/testbed/testsuite/deter
	
Edit the third line of tbcheck so `tbsrc` refers to the full path for ~<builduser>/testbed.
	
	set tbsrc /usr/testbed/src/testbed
	
Then
	
	./tbcheck
	
should produce (after a fair amount of other logging)
	
	basic2 passed all phases
	basic passed all phases
	toofast failed preparse
	miniTbcmd2 passed all phases
	cbr passed all phases
	basic3 passed all phases
	
_tbcheck_ is a tcl expect script which exercises the testbed
using this short series of experiments,
attempting to: swap each in;
test link behavior; verify other properties of the instantiated
experiment; and finally swap out.
Given a sufficient quantity of experimental nodes, and a correctly-functioning testbed,
only one of the tests is designed to fail.

* _basic'' checks that an experimental node's group file includes the project group. It also includes two links with different delays, and one at a lower bitrate than the others. ''basic_ should pass all phases.
* _basic2_ checks than an experimental node properly mounted the user's home directory, and should pass all phases.
* _basic3_ performs the same group file check as "basic" but will swap in on a testbed with as few as three experimental nodes.
* _cbr_ includes a number of links with delay, traffic agents, and link events.  The test verifies that the testbed correctly creates a log file for one of the events.
* _miniTbcmd2_ includes a pair of tar archives to be extracted on one of the experimental nodes, and a startup command for that node.
* _toofast_ is supposed to fail to swap-in (according to emulab) because one of the links is too fast, but in practice fails due to a parsing error. This is the only one of the five tests which is intended to fail.

The full series requires at least six experimental nodes,
assuming one node available for delay use has four experimental interfaces.
_basic2'' and ''basic3_ require two and three experimental nodes, respectively.
