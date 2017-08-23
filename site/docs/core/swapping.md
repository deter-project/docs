# Understanding Swapping (Node Use Policies)

## What are DETERLab's use policies?

As a courtesy to other experimenters, we ask that experiments be swapped out or terminated when they are no longer in active use. There are a limited number of nodes available, and node reservations are exclusive, so it is important to free nodes that will be idle so that others may use them. In summary, our policy is that experiments should be swapped out when they are not in use. We encourage you to do that yourself. In general, if experiments are idle for several hours, the system will automatically swap them out, or send you mail about it, and/or an operator may manually swap them out. The actual grace period will differ depending on the size of the experiment, the current demand for resources, and other factors (such as whether you've been a good DETERLab citizen in the past!). If you mark your experiment "non-idle-swappable" at creation time or before swapin, and testbed-ops approves your justification, we will make every effort to contact you before swapping it, since local node state could be lost on swapout. Please see full details below.

## What is "active use"?

A node or experiment that is being actively used will be doing something related to your experiment. In almost all cases, someone will either be logged into it using it interactively, or some program will be running, sending and receiving packets, and performing the operations necessary to carry out the experiment.

## When is an experiment considered idle?

Your experiment will be considered idle if it has no measurable activity for a significant period of time (a few hours; the exact time is typically set at swapin time). We detect the following types of activity:

* Any network activity on the experimental network
* Substantial activity on the control network
* TTY/console activity on nodes
* High CPU activity on nodes
* Certain external events, such as rebooting a node with ```node_reboot``` 

If your experiment's activity falls outside these measured types of activity, or it seems that DETERLab is not assessing your idle time correctly, please be sure to let us know when you create your experiment, or you may be swapped out unexpectedly.

''It is considered abuse to generate artificial activity in order to prevent your experiment from being marked idle. Abusers' access to DETERLab will be revoked, and their actions will be reported to their project leader. Please do not do this. If you think you need special assistance for a deadline, demo or other reason, please <a href="https://trac.deterlab.net/wiki/GettingHelp">contact us</a>.''

## What is "swapping"? <a name="swapping"></a>

Swapping is the process of instantiating your experiment, i.e., allocating nodes, configuring links, etc. It also refers to the reverse process, in which nodes are released. These processes are called "swapping in" and "swapping out" respectively.

## What is an "Idle-Swap"? <a name="idleswap"></a>

An "Idle-Swap" is when DETERLab or its operators swap out your experiment because it was idle for too long. There are two ways that your experiment may be idle-swapped: automatic and manual. 

The most common is automatic, which happens when Idle-Swap is enabled for your experiment and the experiment has been continuously idle for the idle-swap time that was set at creation/swapin time (usually a few hours). DETERLab will then automatically swap it out. 

The other way to get idle-swapped is manually, by a DETERLab operator. This typically happens when there is very high resource demand and the experiment has been idle a substantial time, usually a few hours. In this case we will typically make every effort to contact you, since it may cause you to lose data stored on the nodes. 

''Note that operators (and you) may swap your excessively idle experiment whether or not it is marked idle-swappable.''

When you create your experiment, you may uncheck the "Idle-Swap" box, disabling the automatic idle-swapping of your experiment. If you do so, you must specify the reason, which will be reviewed by testbed-ops. If your reason is judged unacceptable or insufficient, we will explain why, and your experiment will be marked idle-swappable. Valid reasons might be things such as:

* ''Your idle-detection system fails to detect my experimental activity.''
* ''I have node-local state that is impractical to copy off in a timely or reliable manner, because .....''
* ''My experiment takes a huge number of nodes, I have several runs to make with intervening think time, and if someone grabs some of these nodes if I'm swapped while thinking, I'll miss my deadline 2 days from now.''

If an experiment is non-idle-swappable, our system will not automatically swap it out, and testbed administrators will attempt to contact you in the event a swapout becomes necessary. However, we expect you to be responsible for managing your experiment in a responsible way, a way that uses DETERLab's hardware resources efficiently.

When you create your experiment, you may decrease the idle-swap time from the displayed default, but you may not raise it. If lowering it is compatible with your planned use, doing so helps you be a good DETERLab citizen. If you want it raised, for example for reasons similar to those given above, send mail to testbed-ops AT deterlab.net.

You may edit the swap settings (Idle-Swap, Max-Duration, and corresponding reasons and timeouts) using the "Modify Settings" menu item on the ''Experiment'' page for your experiment.

## How long is too long for a node to be idle?

Ideally, an experiment should be used nearly continuously from start to finish of the experiment, then swapped out or terminated. However, this isn't always possible. In general, if your experiment is idle for 2 hours or more, it should be swapped out. This is especially true at night (in U.S. timezones) and on weekends. Many experimenters take advantage of lower demand during evenings and weekends to run their large-scale (50-150 node) tests. If your experiment uses 10 nodes or more, it is even more important to release your nodes as soon as possible. Swapin and swapout only take a few minutes (typically 3-5 for swapin, and less than 1 for swapout), so you won't lose much time by doing it.

Sometimes an experiment will run long enough that you cannot be online to terminate it, for example, if the experiment completes in the middle of the night. We provide three mechanisms to assist you in terminating your experiment and releasing nodes in a timely manner. The first is the Idle Swap, explained above, the second is <a href="/core/core-guide/#Halting">Scheduled Termination</a>, and the third is the "Max Duration" option, <a href="#maxduration">explained below</a>.

## What is "node state"? <a name="swapstatesave"></a>

Some experiments have state that is stored exclusively on the nodes themselves, on their local hard drives. This is state that is not in your NS file or files or disk images that it references, and therefore is not preserved in our database across swapin/swapout. This is state you add to your machines "by hand" after DETERLab sets up your experiment, like files you add or modify on filesystems local to test nodes. Local node state does not include any data you store in ```/users```, ```/proj```, or ```/groups```, since those are saved on a fileserver, and not on the local nodes.

Most experiments don't have any local node state, and can be swapped out and in without losing any information. This is highly recommended, since it is more courteous to other experimenters. It allows you or DETERLab to easily free up your nodes at any time without losing any of your work. '''Please make your experiments adhere to this guideline whenever possible.'''

An experiment that needs local state that inherently cannot be saved (for some reason) or that you will not be able to copy off before your experiment hits the "idle-swap time," should not be marked "idle-swap" when you create it. In the ''Begin Experiment'' form you must explain the reason. If you must have node state, you can save it before you swap out by copying it by hand (e.g., into a tar or RPM file), or creating a disk image of the node in question, and later reloading it to a new node after you swap in again. Disk images in effect create a "custom OS" that may be loaded automatically based on your NS file. More information about disk images can be found on our <a href="https://www.isi.deterlab.net/showimageid_list.php3">Disk Image page</a> (you must be logged in to use it). We will be developing a system that will allow the swapping system automatically to save and restore the local node state of an entire experiment.

## I just received an email asking me to swap or terminate my experiment. <a name="autoswap"></a>

DETERLab has a system for detecting node use, to help achieve more efficient and fair use of DETERLab's limited resources. This system sends email messages to experiment leaders whose experiments have been idle for several hours. If you get a message like this, your experiment has been inactive for too long and you should free up its nodes. If the experiment continues to be idle, more reminders may be sent, and soon your project leader will be one of the recipients. After you have been notified, your experiment may be swapped at any time, depending on current demand for nodes, and other factors.

If you feel you received the message in error, please respond to Testbed Operations (testbed-ops@isi.deterlab.net) as soon as possible, describing how you have used your node in the last few hours. There are some types of activity that are difficult to accurately detect, so we'd like to know how we can improve our activity detection system. '''Above all, do not ignore these messages.''' If you get several reminders and don't respond, your experiment will be swapped out, potentially causing loss of some of your work (see "node state" above). If there is a reason you need to keep your experiment running, tell us so we don't inadvertently cause problems for you.

## Someone swapped my experiment!

As described above, the system automatically swaps out your experiment after it reaches its idle time limit, or sometimes an DETERLab operator does it earlier when resources are in especially high demand. In the latter case, we will typically try to contact you by email before we swap it out. However, especially if the experiment has been idle for several hours, we may swap it out for you without waiting very long to hear from you. Because of this, it is critical that you keep in close contact with us about an experiment that we may perceive as idle if you want to avoid any loss of your work.

## What is "Max duration"?<a name="maxduration"></a>

Each experiment may have a Maximum Duration, where an experimenter specifies the maximum amount of time that the experiment should stay swapped in. When that time is exceeded, the experiment is unconditionally swapped out. The timer is reset every time the experiment swaps in. A reminder message is sent about an hour before the experiment is swapped. This swapout happens regardless of any activity on the nodes, and can be averted by using the "Edit Metadata" menu item on the experiment's page to turn off the Maximum Duration feature or to lengthen the duration.

This feature allows users to schedule experiment swapouts, helping them to release nodes in a timely manner. For instance, if you plan to use your experiment throughout an 8 hour work day, you can schedule a swapout for 8 hours after it is swapped in. That way, if you forget to swap out before leaving for the day, it will automatically free up the nodes for other users, without leaving the nodes idle for several hours before being idle-swapped, and will work even if you leave your test programs running, making the experiment look non-idle. For automated experiments, it lets you schedule a swapout for slightly after the maximum amount of time your experiment should last. It can also help catch "runaway" experiments (typically batch).

"Max duration" has a similar effect as <a href="/core/core-guide/#Halting">scheduled termination/swapout</a>, which is specified in the NS file. The differences are that the former lets you adjust the duration while the experiment is running, you get a warning email, and you're always swapped, never terminated. (It's also implemented differently, with a 5 minute scheduling granularity.)