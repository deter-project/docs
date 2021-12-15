# Orchestrator Quickstart

This page describes basic information about the MAGI Orchestrator and provides a high-level overview of how to use it. More details are available in the <a href="../orchestrator-guide/">Orchestrator Guide</a>.

## What is the MAGI Orchestrator?

MAGI allows you to automate and manage the procedures of a DETERLab experiment which is very useful for highly complex experiments. It's essentially a workflow management system for DETERLab that provides deterministic control and orchestration over event streams, repeatable enactment of procedures and control and data management for experiments.

MAGI replaces the SEER experimentation framework and is part of the DETER experiment lifecycle management tools.

## How does it work? ##

The procedure for a MAGI experiment is expressed in a YAML-based Agent Activation Language (AAL) file. The MAGI Orchestrator tool parses the procedure AAL file and maintains experiment-wide state to execute the procedure. The Orchestrator then sends and receives events from agents on the experiment nodes and enforces synchronization points -- called as triggers — to deterministically execute the procedure. 

## How do I use the Orchestrator?

### 1. Include a special start command in your topology

Add a special start command in your topology to install MAGI and supporting tools on all nodes at startup. The command will be similar to the following:

```
tb-set-node-startcmd $NodeName "sudo python /share/magi/current/magi_bootstrap.py"
```

### 2. Write the AAL file that describes the experiment's workflows
    
Describe the experiment procedure (ie, workflow) in a YAML-based AAL (.aal) file that describes:

* groups - one or more nodes of with similar behavior. 
* agents - sets of behaviors 
* event streams - list of events and triggers that make up a procedure.
  * events - invoke a procedure implemented in an agent
  * triggers - synchronization mechanism based on events or time.

The following is an example of an event in the AAL file:

```
- type: event
  agent: server_agent
  method: startServer
  trigger: serverStartedSuccessfully
  args: {}
```

You'll find more detailed information about writing the AAL file in the <a href="../orchestrator-guide/">Orchestrator Guide</a>.

### 3. Run the ```magi_orchestrator.py``` tool on a physical experiment in DETERLab

Similar to <a href="../../containers/containers-quickstart/">Containers</a>, you run the Orchestrator tool in conjunction with a swapped-in physical experiment in DETERLab. ```magi_orchestrator.py``` reads the procedure's AAL file and orchestrates an experiment based on the specified procedures.

You would run a command similar to the following on ```users```:

```
/share/magi/current/magi_orchestrator.py --control clientnode.myExp.myProj --events procedure.aal
```

### 4. View results by accessing nodes, modify the experiment as needed.

In an orchestrated experiment, you can access the virtual nodes with the same directories mounted as in a Core DETERLab experiment. You can load and run software and conduct experiments as you would in a Core experiment. 

### 5. Save your work and swap out your experiment (release the resources) 

As with all DETERLab experiment, when you are ready to stop working on an experiment but know you want to work on it again, save your files in specific protected directories and swap-out (via web interface or commandline) to release resources back to the testbed. This helps ensure there are enough resources for all DETERLab users.

## More Information 

For more detailed information about the Orchestrator, read the following:

* <a href="../orchestrator-guide/">Orchestrator Guide</a> - This guide walks you through a basic example of using the Orchestrator and includes some advanced topics.
* <a href="../orchestrator-case-studies/">Orchestrator Case Studies</a> - Includes details of real-world examples of using Orchestrator.
* <a href="../orchestrator-reference/">Orchestrator Reference</a> - This reference includes commands, configuration details and logs.
