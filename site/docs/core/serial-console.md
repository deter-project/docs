# Using the Serial Console

## Determining which nodes to connect to

You can determine the nodes allocated to your experiment by looking at the **Reserved Nodes** table on the *Show Experiment* page on the web interface.  The node names will be given in the first column  of the table. 

## Connecting to the Serial Console

Every node on the testbed has serial console access enabled.  

To connect to a node's serial console, you must first log into `users.deterlab.net` and use the **/usr/testbed/bin/console** command.

To connect to a particular node, type `/usr/testbed/bin/console node-name` where *node-name* is a node allocated to your experiment.

To disconnect from the console session, press `Ctrl` key and ']' key together, then type `quit`. 

## Serial Console Logs

All console output from each node is saved in `/var/log/tiplogs/node-name.run`, where *node-name* is a node allocated to your experiment.  

This run file is created when nodes are first allocated to an experiment, and the Unix permissions of the run files permit only members of the project to view them.  

!!! warning
    When the experiment is swapped out, the run logs are removed.  In order to preserve them, you must make a copy before swapping out your experiment.

Console logs may be viewed through the web interface on the *Show Experiment* page by clicking on the icon in the Console column of the *Reserved Nodes* table.

