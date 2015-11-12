disable::
    /usr/testbed/sbin/wap /usr/testbed/sbin/ctlsep_setup uninstall

  enable::
    /usr/testbed/sbin/wap /usr/testbed/sbin/ctlsep_setup install

    If the installation was not successful, clear the site variable swap/lockout
   
  post-tagger-reboot::
    /usr/testbed/sbin/wap /usr/testbed/sbin/ctlsep_setup tagger

# Disabling Control net separtion

When running uninstall the first thing it does is to move all control interfaces
in all swapped in experiments to the common CONTROL VLan which takes under 20 seconds.
Experimenters should be able to ssh to their nodes, which should have normal NFS
connectivity to the server users.isi.deterlab.net

It then performs some mop up operations which disable the traffic interfaces for
both the ISI and Berkeley taggers, and removes all the other per-experiment control
VLans.  The act of untagging the output traffic interface for each tagger is a snmpit
corner case which will produce some diagnostics, but it actually does the correct thing
and by that point should be irrelevant to the historic operation of the testbed.

The entire cleanup operation should take less than 3 minutes.

# Installing Control Net Separation

To enable control net separation, both commands are required.
The separation process requires about 12 seconds for each normal swapped in experiment
(independent of the number of the nodes in the experiment!) and will take about 30 seconds for each firewalled experiment.
The site variable swap/lockout is set during the state change, and must be reset manually by the operator
if the utility aborts.

# Wedged Tagger

If the tagger node gets wedged and must be rebooted, it needs to be informed about which
mac address go to which vlans. In other cases when the tagger state could be corrupted,
it must be reset as well.

The command _ctlsep_setup tagger_ assumes that the tagger is up and running,
formats the information derived from the database state and synchronizes the tagger
via an ssh command.