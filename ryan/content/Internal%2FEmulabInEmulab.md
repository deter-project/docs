# Overview
The [Emulab page on ElabInElab](https://wiki.emulab.net/wiki/elabinelab) makes for very useful background reading.

The following sections are derived from notes by Keith, expanding on the Emulab docs as they pertain to us:


# History

The historic behavior is that an emulab-in-emulab would steal an experimental interface and use it as the control interface. Nobody ever does that anymore.  We added another ns-commnd to have the inner nodes use the regular control interfaces. This extension doesn't seem to be documented:    `tb-elabinelab-singlenet`

Some of what they say there may not work here anymore. e.g. we've never tried the stuff that immediately attempts to swap in an experiment once the inner elab finishes building.

Another important ns command, which is not described in that document, is

	
	namespace eval TBCOMPAT {
	#   set elabinelab_maxpcs <n> where n is the number of client pc's
	    set elabinelab_maxpcs 0
	}
	

# Sample NS File
A complete ns file to create an Emulab-in-Emulab with the operating system FBSD9-ENE with 3 pc's would look like this:

	
	source tb_compat.tcl
	set ns [new Simulator]
	
	tb-elab-in-elab 1
	tb-elabinelab-singlenet
	
	set os FBSD9-ENE	
	
	namespace eval TBCOMPAT {
	    set elabinelab_maxpcs 3
	    set elabinelab_nodeos("boss") $os
	    set elabinelab_nodeos("ops") $os
	}
	
	$ns run
	

# Creating the Emulab-In-Emulab

So you create an experiment with this as an ns file and swap it in.

The build may fail; if it fails, it still declares the experiment to be swapped in but you have to do some manual intervention.

On the real boss run

`os_load  -i  FBSD9-ENE  <whatever the myboss and myops node in your experiment are>`

Wait until both nodes have reloaded and come up so that you can ssh into them.

Then, on the real boss, run the command

`elabinelab <your PID> <your EID>`

_Do not interrupt this_.  It will take 30-40 minutes, if it works. Shorter if it fails.  If it fails try again, including this os_load.

# Interacting With Your elab-in-elab

You should be able to ssh into from users or boss.isi into nodes called myboss and myops in your experiment.  The creator is given admin privs on the inside even if the creator doesn't have on the outside.

You can use firefox with the foxyproxy extension to interact with the web server on the inside as described in:   https://trac.deterlab.net/wiki/ElabElabSshProxy


There is still a bug that ought to be fixed - eventually - that used to cause some nodes in an e-in-e to not
get properly os-loaded.

If a node is sufficiently dicombobulated that the inside boss can't ssh to it, nor send it a ping-of-death,
as would happen if it started by being powered off for energy savings by the outside boss,
the inside boss requests the outside boss to power cycle them, which, in the case of nodes using the older serial-controlled RPC power controllers failed because the power cycle command won't work if it is already off.

The bug is that power cycle on this controllers should always work, and this needs to be fixed in `boss.isi:/usr/testbed/lib/power_rpc27`.

However, Keith says that all of the pc's that used to use serial power controllers are either unracked
or in hwdead (pc114, pc133) so that this is not currently an issue.  It might be if they get revived for an
education cluster.

# How It Works, and Exercising a New Version
If you've specified the ns-command
	
		    tb-elab-in-elab 1
	
in your NS file, then, as implied above `tbswap` runs `boss:/usr/testbed/sbin/elabinelab` on your behalf.

This dumps some information from the database into `/proj/<YourProj>/exp/<YourId>/dbstate.tar.gz`

It copies `boss:/usr/testbed/etc/rc.mkelab` to the inside users node and runs it, and then does the same for the boss, which are wrapper scripts that retrieve and install the source.

If there is a file `/proj/<YourProj>/exp/<YourID>/rc.mkelab` it will use that one instead, which will allow you to build the next generation version without disrupting the working one.

The standard version will similarly by default retrieve the source from `boss:/usr/testbed/src/emulab-src.tar.gz` , but if there is a file `/proj/<YourProj>/exp/<YourID>/emulab-src.tar.gz` then it will use *that* version instead.

# Another Note
The tcl that gets invoked in parsing the nsfile for the encompassing experiment is `users:/usr/testbed/lib/ns2ir/elabinelab.ns`

# Current Brokenness
The upgrade to FreeBSD10.1 compatible sources required importing a new version of imagezip, which seems to have
broken the frisbeeimage program which an inner boss uses to fetch images from an outer boss.

So, you have to manually copy the images you need from the outer boss to the inner one, in order to get inner nodes
to load.  And you'll have to do a sched_reload of all pc's before you can get them into an experiment once
having copied your default image.  I hope to remove this paragraph in the next month or so.  (sklower)
