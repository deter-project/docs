
!!! important
    This page is deprecated. Please use our <a href="https://launch.mod.deterlab.net/">new platform</a> and accompanying documentation.
 

# Specialized User

This page gives you a brief introduction on writing your own Magi Agent. It is designed to give you sample code, briefly explain it, then show you the pieces needed to run it. After reading this page you should be able to write and run a basic MAGI Agent. Further details and more advanced agent information may be found in the Magi Agent Library document (link).

## Basic Agent Information

An Agent runs in two modes: a threaded mode and a process mode.

- **Threaded** mode: The MAGI Daemon loads python codes directly, and runs the Agent in a thread in its own process space.
- **Process** mode: The MAGI Daemon runs the agent in a process space separate from itself and communicates with the Agent via a pipe or a socket.

## `DispatchAgent` class

In most cases you will want to use the Orchestrator (link) and an AAL file (link) to run and coordinate your Agent actions. In order to get the basic Agent control (via remote procedure calls), you'll need to derive your agent from the `DispatchAgent` base class.

The `DispatchAgent` implements the simple remote procedure call (RPC) mechanism used by the Orchestrator (and available through the MAGI python API). This allows any method in a class derived from `DispatchAgent` to be invoked in an AAL (or by a MagiMessage if using the MAGI python interface directly).

The `DispatchAgent` code simply loops, parsing incoming messages, looking for an event message. When it finds one, it attempts to call the method specified in the message with the arguments given. You needn't worry about message handling or parsing when you derive from `DispatchAgent`, you can simply write your code and call that code from the AAL.

## Basic Elements of Writing a Client

To write and execute your agent you need the following three things:

- The Agent code to implement the Agent. Also, every Agent must implement a method named `getAgent` which returns an instance of the Agent to run. The MAGI Daemon uses this method to get an instance of the Agent to run in a local thread and communicate with the Agent instance.
- An Interface Description Language (IDL) file to describe the Agent function and specify things the MAGI Daemon needs to know to load and execute the Agent code (among these is the location of the Agent code and the execution mode).
- An AAL file (as described [here](../orchestrator-guide/#step-1-write-the-aal-file))

## Deploying and Executing a Sample Agent

### Step 1: Create a local directory named "FileCreator"

MAGI Agents are usually contained in a single directory.

### Step 2: Create the Agent implementation code file

Copy the following Agent implementation code to the file "FileCreator/FileCreator.py".

This example Agent code has the following characteristics:

- It creates a simple Agent which creates a single file on a host.
- The agent is called FileCreator.
- It has a single method, `createFile`, which creates the file `/tmp/newfile` when called
- For this agent, we will always run in threaded-mode.

~~~~
  from magi.util.agent import DispatchAgent, agentmethod
  from magi.util.processAgent import initializeProcessAgent

  # The FileCreator agent implementation, derived from DispatchAgent.
  class FileCreator(DispatchAgent):
      def __init__(self):
          DispatchAgent.__init__(self)
          self.filename = '/tmp/newfile'

      # A single method which creates the file named by self.filename.
      # (The @agentmethod() decorator is not required, but is encouraged.
      #  it does nothing of substance now, but may in the future.)
      @agentmethod()
      def createFile(self, msg):
          '''Create a file on the host.'''
          # open and immediately close the file to create it.
          open(self.filename, 'w').close()

  # the getAgent() method must be defined somewhere for all agents.
  # The Magi daemon invokes this mehod to get a reference to an
  # agent. It uses this reference to run and interact with an agent
  # instance.
  def getAgent():
      agent = FileCreator()
      return agent

  # In case the agent is run as a separate process, we need to
  # create an instance of the agent, initialize the required
  # parameters based on the received arguments, and then call the
  # run method defined in DispatchAgent.
  if __name__ == "__main__":
      agent = FileCreator()
      initializeProcessAgent(agent, sys.argv)
      agent.run()
~~~~

### Step 3: Create the IDL file

Copy the IDL below to a file named 'FileCreator/FileCreator.idl'.

!!! note 
    The file and directory may be named anything, but if you deviate from the naming scheme given, make sure the mainfile setting in the IDL and the code setting in your AAL (below) matches your naming scheme.

The following example IDL file has the following characteristics:

- The execution mode is "thread" and the inheritance is specified as "DispatchAgent".
- When you run this, you must specify the name of your implementation file (i.e., the Agent code from the previous step). This example assumes the file is in the local directory and is named "FileCreator.py".
- It lists methods and internal variables that the author wants exposed to external configuration. In our case, we expose the variable `filename`, but currently only use the default setting. Later we will describe how to set this outside of the Agent implementation.

~~~~
    name: FileCreator
    display: File Creator Agent
    description:  This agent creates a file on the test node.
    execute: thread
    mainfile: FileCreator.py
    inherits:
       - DispatchAgent

    methods:
       - name: createFile
         help: Create the file
         args: []

    variables:
       - name: filename
         help: the full path of the file to create
         type: string
~~~~

### Step 4: Create the AAL file

Copy the sample AAL code below to a file named "FileCreator/myEvents.aal".

Make sure to:

- Replace `PATH` with the full path to your "FileCreator" directory. Note: the PATH you use must include the NFS-mounted location on the test nodes.
- Replace `NODES` with the comma-separated list of nodes on your testbed on which you want to run the Agent.

```
    streamstarts: [main]

    groups:
        myFileCreatorGroup [NODES]

    agents:
        myFileCreators:
            group: myFileCreatorGroup
            # (note: the "code" argument is the Agent directory. The
            # directory must contain an IDL and Agent implementation.)
            code: PATH/FileCreator
            execargs: []

    eventstreams:
        main:
            - type: event
              agent: myFileCreators
              method: createFile
              args: { }
```

!!! note
    - The AAL is in YAML format; therefore, it cannot have tabs. If you cut and paste the above code, make sure to remove any possible inserted tabs.
    - Because your Agent code is on an NFS-mounted filesystem, all MAGI Daemons may read the code directly.

### Step 5: Run Orchestrator

Run the MAGI Orchestrator to run the event streams in your AAL file - and thus your agent code:

```
magi_orchestrator --control $control --events myEvents.aal -o run.log -v
```

Where `$control` is the fully qualified domain of your DETERLab node, i.e. `myNode.myGroup.myProject`}

This command runs the Orchestrator, which connects to the `$control` node, runs the events in the **myEvents.aal** file and writes verbose output to **run.log**.

In this example, the method `createFile` will be called on all test nodes associated with `myAgentGroup` in the AAL file.

On standard out, you should see Orchestrator output similar to the following:

```
stream initialization : sent : joinGroup myFileCreatorGroup --> __ALL__
stream initialization : done : trigger GroupBuildDone myFileCreatorGroup  complete.
stream initialization : sent : loadAgent myFileCreators --> myFileCreatorGroup
stream initialization : done : trigger AgentLoadDone  myFileCreators complete.
stream initialization : DONE : complete.
stream main           : sent : createFile(None) --> myFileCreatorGroup
stream main           : DONE : complete.
```

This output shows the two execution streams the orchestrator runs. The first, _initialization_, is internal to the Orchestrator and sets up group communication and loads the agents. The second, _main_, is the event stream specified in your AAL file.

If you do not see the "correct" output above, refer to the [#troubleshooting Troubleshooting] section below.

To confirm the Agent ran and executed the `createFile` method, run the following (from `users`):

```
ssh myNode.myExperiment.myGroup ls -l /tmp/newfile
```

Where `myNode.myExperiment.myGroup` is the domain name of a node on which you executed the Agent.

You may download the sample code as a tar file here: [FileCreator.tbz] (attach).

## Runtime Agent Configuration

The sample Agent `FileCreator` always creates the same file, each time it is run. What if you wanted to create a different file? Or a series of files? It is possible to specify Agent configuration in an AAL file - configuration that can modify the internal variables of your Agent at run time. See [MAGI Agent Configuration](../agent-configuration/) for details.

## Troubleshooting

Look at the Magi Daemon log file at `/var/log/magi/daemon.log` on your control and test nodes looking for errors. If there are syntax errors in Agent execution, they may show up here.

### Error: You see a 'No such file' error

You may see an error indicating there is no such file as follows:

```
Run-time exception in agent <Daemon(daemon, started 140555403872000)> on node(s) control in method __init__, line 71, in file threadInterface.py. Error: [Errno 2] No such file or directory
```

**Solution:** You probably did not specify the correct "mainfile" in the IDL file. It must not be pathed out and must match the name of the main Agent implementation file, for example, "myAgent.py".

### Error: You see a "no attribute 'getAgent'" message

**Solution:** The Magi Daemon needs the well-known method `getAgent` to exist in the Agent module. Add it to your Agent code.

### Error: 'module' object has no attribute 'getAgent'

**Solution:** Make sure your agent defines (and exports or make available) a `getAgent` method and that it returns an instance of your agent.
