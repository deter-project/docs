[[TOC]]

'''Contributors:  \\
Peter A. H. Peterson, UCLA. pahp@cs.ucla.edu \\
David Morgan, USC. davidmor@usc.edu'''

# What is DeterLab?

[DeterLab](https://www.isi.deterlab.net/) is a security and education-enhanced version of [Emulab](http://www.emulab.net/). Funded by the [National Science Foundation](http://www.nsf.gov/) and the [Department of Homeland Security](http://www.dhs.gov/), DeterLab is hosted by [USC/ISI](http://www.isi.edu/) and [UC Berkeley](http://www.berkeley.edu/).

     "USC/ISI’s DeterLab (cyber DEfense Technology Experimental Research Laboratory) is a state-of-the-art scientific computing facility for cyber-security researchers engaged in research, development, discovery, experimentation, and testing of innovative cyber-security technology. DeterLab is a shared testbed providing a platform for research in cyber security and serving a broad user community, including academia, industry, and government. To date, DeterLab-based projects have included behavior analysis and defensive technologies including DDoS attacks, worm and botnet attacks, encryption, pattern detection, and intrusion-tolerant storage protocols. [ [1](http://deter-project.org/about_deterlab) ]."

DeterLab (like Emulab) offers user accounts with assorted permissions associated with different experiment groups. Each group can have its own preconfigured experimental environments running on Linux, BSD, Windows, or other operating systems. Users running DeterLab experiments have full control of real hardware and networks running preconfigured software packages. These features make it an ideal platform for computer science and especially computer security education. Many instructors have designed class exercises (homework assignments, project assignments, in-class demos, etc.) consisting of a lab manual, software, data, network configurations, and machines from DETER's pool. This allows each student to run her own experiments on dedicated hardware.

# How does it work?

The software running DeterLab will load operating system images (low level disk copies) onto to free nodes in the testbed, and then reconfigure programmable switches to create VLANs with the newly-imaged nodes connected according to the topology specified by the experiment creator. After the system is fully imaged and configured, DeterLab will execute specified scripts, unpack tarballs, and/or install rpm files according to the experiment's configuration. The end result is a live network of real machines, accessible via the Internet.

# How do I get a DeterLab login?

1. Your instructor will request an account for you. Simply send your preferred email address to your instructor.
2. Once the testbed ops set up your account, you will receive an email with your username and password at the address you supplied.
3. Within one week, use those credentials to log in.
4. Edit your profile as follows:
  a. Choose "Profile" tab
  b. Choose "Edit profile" menu option
  c. Replace any default contents in the 2 fields shown with your actual name and working phone number
  d. Change your password!
  e. Click "Submit"

# Using DeterLab

## How do I start an exercise?

Before you can perform the tasks described in your exercise assignment, you will, in many cases, need to create an experiment in DeterLab to work on. This will be your environment to use whenever you need it. To create a new experiment:

1. Log into DeterLab with your account.
2. Under the "Experimentation" menu at the top of the page, click "Begin an Experiment".
3. Select your Class Project name from the "Select Project" dropdown. (Throughout this document, we'll assume your class project name is YourProject)
4. Leave the "Group" dropdown set to Default unless otherwise instructed.
5. In the "Name" field, enter a name of the format _username-exercisename''. (Example:'' jstudent-exploits_).
6. Enter a brief description in the "Description" field.
7. In the "Your NS File" field, follow the instructions in the "Setup" section of your exercise manual.
8. Set the "Idle Swap" field to _1 h_. Leave the rest of the settings for "Swapping," "Linktest Option," and "BatchMode" alone (unless otherwise instructed).
9. If you would like to start your lab now, check the "Swap In Immediately" box and move to the next section. Otherwise, do not check this box.
10. Click "Submit"!

## How do I work on my exercise?

1. Log into DeterLab with your DeterLab account (or contact your instructor if you need an account).
2. Click on the "My DeterLab" link on the left hand menu.
3. In the "Current Experiments" table, click on the name of the experiment you want.
4. Under the "Experiment Options" menu on the left margin, click "Swap Experiment In", then click "Confirm".
5. The swap in process will take 5 to 10 minutes. While you're waiting, you can watch the swap in process displayed in your web browser. Or, you can watch your email box for a message letting you know that it has finished swapping in.
6. When the experiment has finished swapping in, you can perform the tasks in your exercise manual.

## How do I access my experiment?

Your experiment is made up of one or more machines on the internal DeterLab network, which is behind a firewall. To access your experimental nodes, you'll need to first SSH to `users.deterlab.net`. If you don't know how to use SSH, [wiki:DETERSSH see our tutorial].

`users.deterlab.net` (or `users` for short) is the "control server" for DeterLab. From `users` you can contact all your nodes, reboot them, connect to their serial ports, etc.

Once you log in to `users`, you'll need to SSH again to your actual experimental nodes. Since your nodes' addresses may change every time you swap them in, it's best to SSH to the permanent network names of the nodes. Here's how to figure out what their names are:

Once your experiment has swapped in:
1. Navigate to the experiment you just installed.
    - If you just swapped in your experiment, the quickest way to find your node names is to click on the experiment name in the table under "Swap Control." However, you      can also get there by clicking "My DeterLab". Your experiment is listed as "active" in the "State" column. Click on the experiment's name in the "EID" column.
2. Once you can see your experiment's page, click on the "Details" tab in the main content panel. Your nodes' network names are listed under the heading "Qualified Name."
    - For example, `node1.YourExperiment.YourProject.isi.deterlab.net`.
    - You should familiarize yourself with the information available on this page, but for now we just need to know the long DNS qualified name(s) node(s) you just swapped in. If you are curious, you should also look at the "Settings" (generic info), "Visualization," and "NS File." (The topology mapplet may be disabled for some labs, so these last two may not be visible).
3. Now that you are logged in to `users.deterlab.net`, your nodes are swapped in, and you know their network name(s), you can SSH from `users` to your experimental nodes by executing: `ssh node1.YourExperiment.YourProject.isi.deterlab.net`. You will not need to re-authenticate.
   - You may need to wait a few more minutes. Once DeterLab is finished setting up the experiment, the nodes still need a minute or two to boot and complete their configuration. If you get a message about "server configuration" when you try to log in, wait a few minutes and try again.
   - If a lab instructs you to create new users on your experimental nodes, you can log in as them by running `ssh newuser@node1.YourExperiment.YourProject.isi.deterlab.net` or `ssh newuser@localhost` from the experimental node.

Congratulations! Your lab environment is now set up, and you can get to work at the tasks in your lab manual. Make sure you read the "Things to keep in mind" section below!

 Some labs benefit from Port Forwarding. Port Forwarding is a technique that can allow you to access your experimental nodes directly from your desktop computer. This is especially useful for accessing web applications running on your experimental nodes. See our ssh tutorial for more information.

Finally, when you are done working with your nodes, you should save your work and swap out the experiment so that someone else can use the physical machines.

# Things to keep in mind

Carefully read the [wiki:UserGuidelines evolving version of this document].

## Saving and securing your files on DeterLab

Every user on DeterLab has a home directory on `users.deterlab.net` which is mounted via NFS (Network File System) to experimental nodes. This means that anything you place in your home directory on one experimental node (or the `users` machine) is visible in your home directory on your other experimental nodes. Your home directory is private, so you may save your work in that directory. However, everything else on experimental nodes is permanently lost when an experiment is swapped out.

*Make sure you save your work in your home directory before swapping out your experiment!*

Another place to save your files would be `/proj/YourProject`. This directory is also NFS-mounted to all experimental nodes so same rules apply about writing to it a lot, as for your home directory. It is shared by all members of your project/class.

Again, on DeterLab, files ARE NOT SAVED between swap-ins. Additionally, class experiments may be forcibly swapped out after a certain number of idle hours (or some maximum amount of time).

You must manually save copies of any files you want to keep in your home directory. Any files left elsewhere on the experimental nodes will be erased and lost forever. This means that if you want to store progress for a lab and come back to it later, you will need to put it in your home directory before swapping out the experiment.

## Swap out -- DON'T "terminate"!

When you are done with your experiment for the time being, please make sure you save your work into an appropriate location and then swap out your experiment. To do this, use the "Swap Experiment Out" link in the "Experiment Options" panel. (This is the same place that used to have a "Swap Experiment In" link.) This allows the resources to be deallocated so that someone else can use them.

*Do not use the potentially misleading "Terminate Experiment" link unless you are completely finished with your exercise. Termination will erase the experiment and you won't be able to swap it back in without recreating it.*

Swapping out is the equivalent of temporarily stopping the experiment and relinquishing the testbed resources. Swapping out is what you want to do when you're taking a break from the work, but coming back later. Terminating says "I won't need this experiment again, ever." This may be confusing, especially since "Swap Out" seems to imply that it saves your progress (it doesn't, as described above). Just remember to Swap In/Out, and never "Terminate" unless you're sure you're completely done with the experiment. If you do end up terminating an experiment, you can always go back and recreate it.

## Submitting your work to your instructor

Each exercise manual has a section entitled "Submission Instructions," and your instructor may have given you additional instructions for submission. Follow the instructions in that section, and submit your work to your instructor.

Unless otherwise instructed, it's a good idea to include:

* Your name
* Your preferred email address
* Your student ID (if applicable)
* Your DeterLab username
* Your experiment's name (e.g., jstudent-exploits)

# Frequently Asked Questions

Please check the following list of questions for answers. If you do not find an answer to your question here or elsewhere, please email your instructor or TA. Do not email testbed ops unless specifically instructed to do so by your instructor.

## Why can't I log in to DeterLab?

DeterLab has an automatic blacklist mechanism. *If you enter the wrong username and password combination too many times, your account will no longer be accessible from your current IP address.* If you think that this has happened to you, you can try logging in from another address (if you know how), or you can email your instructor or TA and specify your IP address. They will relay the request to the testbed ops that this specific blacklist entry should be erased.

If you have questions you think should be added to this FAQ, or other information you think should be added to this document, please [wiki:GettingHelp contact us].