+++
tags = ["getting_started"]
tags_weight = 1
date = "2015-11-12T07:54:14-08:00"
draft = true
title = "Core Quickstart"
+++

This page describes basic information about DeterLab and its core functionality.

# What is DeterLab?

The DeterLab testbed is a security and education-enhanced version of [Emulab](https://www.emulab.net/). Funded by the National Science Foundation and the Department of Homeland Security, DeterLab is hosted by USC/ISI and UC Berkeley.

DeterLab (like Emulab) offers user accounts with assorted permissions associated with different experiment groups. Each group can have its own pre-configured experimental environments running on Linux, BSD, Windows, or other operating systems. Users running DeterLab experiments have full control of real hardware and networks running preconfigured software packages.

# How does it work?

The software running DeterLab loads operating system images (low level disk copies) onto free nodes in the testbed, and then reconfigures programmable switches to create VLANs with the newly-imaged nodes connected according to the topology specified by the experiment creator. 

After the system is fully imaged and configured, DeterLab executes specified scripts, unpacks tarballs, and/or installs RPM files according to the experiment's configuration. The end result is a live network of real machines, accessible via the Internet.

Work in DeterLab is based on *projects_' that include individual '_experiments* and is accomplished either via the browser-based web interface (isi.deterlab.net) or via commandline on the DeterLab nodes. 

To access DeterLab, you need to create an account, which provides credentials for accessing both the web interface and nodes.

# How do I get a DeterLab account?

You may obtain a DeterLab account by either starting a new project (if you are a PI or instructor) or joining an existing project (if you are a project member or a student).

*If you are the project investigator or instructor*, you must create a project and invite your team members or students to join. 

*If you are the member of a team using DeterLab*, your project leader will invite you to join the appropriate DeterLab project. 

*If you are a student*, you may not create a project. Your instructor must create the project and, once approved, will give you information for joining the project.

See [wiki:GettingStarted Getting Started] for more information.

# How do I use DeterLab?

In general, once you have a DeterLab account, you follow these steps. The [wiki:CoreGuide DeterLab Core Guide] will walk you through a basic tutorial of these steps.

## 1. Design the topology
Every experiment in DeterLab is based on a network topology file written in NS format and saved on the users node. The following is a very basic example:

	
	# This is a simple ns script. Comments start with #.
	set ns [new Simulator]                 
	source tb_compat.tcl
	
	set nodeA [$ns node]
	set nodeB [$ns node]
	set nodeC [$ns node]
	set nodeD [$ns node]
	
	set link0 [$ns duplex-link $nodeB $nodeA 30Mb 50ms DropTail]
	tb-set-link-loss $link0 0.01
	
	set lan0 [$ns make-lan "$nodeD $nodeC $nodeB " 100Mb 0ms]
	
	# Set the OS on a couple.
	tb-set-node-os $nodeA FBSD7-STD
	tb-set-node-os $nodeC Ubuntu1004-STD         
	
	$ns rtproto Static
	
	# Go!
	$ns run                                 
	

## 2. Create, start and swap in (allocate resources for) an experiment
Using your topology file, you start a new experiment via menu options in the DeterLab web interface.

[[Image(create_experiment_screenshot.png)]]

## 3. Generate traffic for your nodes
Now you can experiment and start generating traffic for your nodes. We provide a [wiki:LegoTG flexible framework] to pull together the software you'll need.

## 4. View results by accessing nodes, modify the experiment as needed.

Once your experiment has started, you now can access nodes via SSH and conduct your desired experiments in your new environment.

You may modify aspects of a running experiment through the "Modify experiment" page in the web interface or by making changes to the NS file.

## 5. Save your work and swap out your experiment (release the resources)
When you are ready to stop working on an experiment but know you will want to work on it again, save your files in specific protected directories and swap-out (via web interface or commandline) to release resources back to the testbed. This helps ensure there are enough resources for all DeterLab users.

This is just a high-level overview. Go to the [wiki:CoreGuide Core Guide] for a basic hands-on example of using DeterLab Core.

[wiki:Documentation < Documentation] | [wiki:CoreGuide Core Guide >]
