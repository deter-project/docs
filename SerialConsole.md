[[TOC]]
[wiki:CoreReference < Back to Core Reference]

# Determining which nodes to connect to

You can determine the nodes allocated to your experiment by looking at the *Reserved Nodes_' table on the '_Show Experiment* page on the web interface.  For DETER nodes are generally named 'pcXXX' for nodes at [wiki:ISIUCB ISI] and 'bpcXXX' for node at [wiki:ISIUCB UCB].

# Connecting to the Serial Console

Every node on the testbed has serial console access enabled.  To connect to a nodes serial console, you must first log into users.isi.deterlab.net and use the *console_' command located in /usr/testbed/bin (which should be in every users PATH by default).  To connect to a particular node, you just type '_console pcXXX* where pcXXX is a node allocated to your experiment.

To disconnect from the console session type *Ctrl-]_' and then '_exit*.  The console command is actually a wrapper for telnet.

# Serial Console Logs

All console output from each node is saved in /var/log/tiplogs/pcXXX.run, where pcXXX is a node allocated to your experiment.  This run file is created when nodes are first allocated to an experiment, and the Unix permissions of the run files permit only members of the project to view them.  When the experiment is swapped out, the run logs are removed.  In order to preserve them, you must make a copy before swapping out your experiment.

Console logs can be viewed through the web interface on the Show Experiment page by clicking on the icon in the Console column of the *Reserved Nodes* table.

# Additional information
* [wiki:DellSerialConsole Dell Serial Console Information]

[wiki:CoreReference < Back to Core Reference]