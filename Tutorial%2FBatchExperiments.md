# Batch Mode (DEPRECATED)
	
	#!html
	<p style="text-align: center; background-color: #fcf8e3; font-weight: bold;">
	IMPORTANT: This page is outdated. Please go to the new version of this documentation in the <a href="/wiki/CoreGuide">Core Guide</a>.
	</p>
	

## Batch Mode Introduction
Batch Mode experiments can be created on DETER via the "Create an Experiment" link in the operations menu to your left. There is a checkbox near the bottom of the form that indicates you want to use the batch system. There are several important differences between a regular experiment and a batch mode experiment:
      * The experiment is run when enough resources (ie: nodes) are available. This might be immediately, or it might be sometime in the future.
      * Once your NS file is handed off to the system, the batch system is responsible for setting up the experiment and tearing it down once the experiment has completed. You will receive email notifying you when the experiment has been scheduled and when it has been terminated.
      * There is currently a limit of only one batch experiment per user.
      * Unlike Emulab, we do not currently swap out batch experiments based on the result of `tb-set-node-startcmd`.

Existing Batch Mode experiments may be "stopped" and "queued." Stopping a Batch Mode experiment has identical semantics to swapping out a regular experiment, including loss of local node disk state, and thus is not really a "clean stop." Queueing a Batch Mode experiment is almost the same as a regular experiment swapin, the difference being that the swapin may be delayed if insufficient resources are available at the time of the swapin.
Unfortunately, while Batch Mode makes running experiments much easier, it also makes wasting resources far easier, e.g., a user queues up an interactive experiment and then is not around when it finally gets swapped in. To counter this, the idle swap threshold for a Batch Mode experiment is typically set lower than that for a regular experiment, usually 15 minutes. If necessary, this can be changed using the "Edit Experiment Metadata" link on an experiment's page. The modified value will remain in effect til the next swapout.
While multiple Batch Mode experiments may be running in DETER simultaneously, the current policy is that there can only be one such experiment per-user. That is, two users in the same project may run experiments simultaneously.
Finally, note that the rights and responsibilities of a Batch Mode experiment are conferred at creation time. It is not possible to, for example, swap out a regular experiment and then swap it back in as a Batch Mode experiment (i.e., to get delayed swapin semantics). This is unfortunate.

The batch system is still under development. Currently, the batch system tries every 10 minutes to run your batch. It will send you email every 5 or so attempts to let you know that it is trying, but that resources are not available. It is a good idea to glance at the message to make sure that the problem is lack of resources and not an error in your NS file.

