# Swap Out (Release Resources)

When you are done working with your nodes, it is best practice to save your work and swap out the experiment so that other users have access to the physical machines.

## Saving Your Work

There are two folders that are mounted via NFS on every node in your experiment and on `users.deterlab.net`. These are (1) your home directory, i.e., `/users/YourUsername` and (2) your project directory, i.e., `/proj/YourProject`. You can place the files you want to save into these directories.  **Everything else on experimental nodes is permanently lost when an experiment is swapped out.**

!!! note
    Remember: Make sure you save your work into your home or project directory before swapping out your experiment!

## Swap Out vs Terminate

**When to Swap Out**
When you are done with your experiment for the time being, make sure you save your work into an appropriate location and then swap out your experiment. Swapping out is the equivalent of temporarily stopping the experiment and relinquishing the testbed resources. Swapping out is what you want to do when you are taking a break from the work, but coming back later. 

To do this, click on the experiment's name in "My Deterlab" view, then select *Swap Experiment Out* from the left menu. This releases resources so that someone else can use them.

**When to Terminate**
When you are completely finished with your experiment and have no intention of running it again, click on the experiment's name in "My Deterlab" view, then selecte *Terminate Experiment* from the left menu. This will **delete all traces of the experiment**. 

