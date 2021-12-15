# Understanding Swapping (Node Use Policies)

## What are DETERLab's use policies?

When you swap in an experiment please use it actively and swap it out promptly if you foresee that you will not use it for an hour or longer.

There are a limited number of nodes available, and we depend on users to actively manage their experiments and return resources when they are not in use.

In general, if an experiment is idle for several hours, the system will automatically swap it out, or E-mail the user about it. In some cases, an operator may manually swap out an epxeriment.

Please see full details below.

## What is "active use"?

A node in an experiment that is being actively used will be doing something related to your experimentation goal. In almost all cases, someone will either be logged into it using it interactively, or some program will be running, sending and receiving packets, and performing the operations necessary to carry out the experiment.

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

When Idle-Swap is enabled for your experiment and the experiment has been continuously idle for the time specified in its settings, DETERLab will then automatically swap it out. *Class experiments have default idle-swap time set for 1 hour*.

When there is very high resource demand and the experiment has been idle a substantial time (e.g., a day) a DETERLab operator may swap it out manually. In this case we will typically make every effort to contact you and ask you to save state and swap out the nodes yourself. 

When you create your experiment, you may uncheck the "Idle-Swap" box, disabling the automatic idle-swapping of your experiment. If you do so, you must specify the reason, which will be reviewed by the operators. If your reason is judged unacceptable or insufficient, we will explain why, and your experiment will be marked idle-swappable. Valid reasons might be things such as:

* your experiment is actually active but our system fails to detect it as such
* you have extensive local state on the node, which is hard to preserve between swap ins
* your experiment uses a large number of nodes and you have a research/class deadline

If an experiment is non-idle-swappable, our system will not automatically swap it out, and testbed administrators will attempt to contact you in the event a swapout becomes necessary. However, we expect you to be responsible for managing your experiment in a responsible way, a way that uses DETERLab's hardware resources efficiently.

You may edit the swap settings (Idle-Swap, Max-Duration, and corresponding reasons and timeouts) using the *Modify Settings* menu item on the left sidebar in the Experiment view.

## Is there any data loss when an experiment is swapped out

Any system settings (e.g., installed applications, changes to configuration files) and any files not stored in your home directory (`/users/YourUsername`) or your project (`/proj/YourProject`) or group (`/groups/YourGroup`) directory, will be lost when your experiment is swapped out. You should make arrangements to store this state manually if it is important for you and to restore it manually when you swap in your experiment again.


## What is "Max duration"?<a name="maxduration"></a>

Each experiment may have a Maximum Duration, where an experimenter specifies the maximum amount of time that the experiment should stay swapped in. When that time is exceeded, the experiment is unconditionally swapped out even if it is not idle. *Class experiments have default max duration set to 1 day.*

