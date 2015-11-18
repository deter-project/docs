In <a href="/orchestrator/writing-agents/">Writing MAGI Agents</a>, you saw how to create a basic agent. The sample agent created a single file on a test node. This document will explain how to use configuration in the AAL file to configure an agent at runtime.

## Setting Agent Configuration

This document will expand the sample code of our ```FileCreator``` example. For reference, here is the agent code:


```
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
          **Create a file on the host.**
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
  if __name__ "__main__":
      agent = FileCreator()
      initializeProcessAgent(agent, sys.argv)
      agent.run()

```

If we reset the ```self.filename``` variable in the agent *before* invoking ```createFile``` in the AAL, we can change the file that is created. 

The base class ```DispatchAgent``` itself is derived from a class that will let us do this. The Agent class implements two methods: 

* ```setConfiguration``` -  Sets the passed parameters as class instance variables.
* ```confirmConfiguration``` - This method is meant to be re-implemented in your agent if you need confirm the variables set are valid for your agent.

To set the ```self.filename``` variable in the FileCreator Agents, we modify the AAL to include a call to the Agent method ```setConfiguration```, passing in a list of key-value pairs. (In the following example, it is a single key-value pair.)

```
- type: event
  agent: myFileCreators
  method: setConfiguration
  args:
     filename: /tmp/myCreatedFile

```

Note that you do not specify self when referencing an Agent variable. We make sure to place this event in the AAL event stream prior to the ```createFile``` event. The complete AAL file is:

```
  streamstarts: [main]

  groups:
      myFileCreatorGroup: [NODES]

  agents:
      myFileCreators:
          group: myFileCreatorGroup
          # (note: the "PATH" argument is the agent directory. The
          # directory must contain an IDL and agent implementation. It must
          # also contain a *__init__.py* file, which is required
          # for it to be considered as a valid python package.)
          path: PATH/FileCreator
          execargs: []

  eventstreams:
      main:
          - type: event
            agent: myFileCreators
            method: setConfiguration
            args:
               filename: /tmp/myCreatedFile

          - type: event
            agent: myFileCreators
            method: createFile
            args: {}

```

Now when we run the Agent again (possibly using ```agentTool``` to restart the Magi daemons), we see the following events:

```
  $ magi_orchestrator.py --project $project --experiment $experiment --events ./myEvents.aal -o run.log -v
  stream initialization : sent : joinGroup myFileCreatorGroup --> __ALL__
  stream initialization : done : trigger GroupBuildDone myFileCreatorGroup  complete.
  stream initialization : sent : loadAgent myFileCreators --> myFileCreatorGroup
  stream initialization : done : trigger AgentLoadDone  myFileCreators complete.
  stream initialization : DONE : complete.
  stream main           : sent : setConfiguration(['/tmp/myCreatedFile ... ) --> myFileCreatorGroup
  stream main           : sent : createFile(None) --> myFileCreatorGroup
  stream main           : DONE : complete.
  $ ssh myNode.myExperiment.myGroup ls -l /tmp/myCreatedFile
  -rw-r--r-- 1 root root 0 Mar  5 13:55 /tmp/myCreatedFile
  $
```

And we see that our specified file, **/tmp/myCreatedFile** was created.

## Confirming Valid Configuration

This works well, but the input to the Agent is free-form. What if the user gives invalid input, like the wrong type or data that is not in a valid range? This is where the Agent ```confirmConfiguration``` method comes into play.

```confirmConfiguration``` should be written for any Agent that wants to validate its state. It gets invoked in the AAL file after the user invokes ```setConfiguration```.

**Note:** The concept of an Agent confirming user input will change in future releases of MAGI. The Orchestrator (or other MAGI/Montage components) will use the interface specification in the Agent’s IDL file to ensure the input to the agent is valid.

Suppose our sample agent wanted to allow the user to create a file in only the **/local** directory on the host machine. The ```confirmConfiguration``` method that does this is:

```
  def confirmConfiguration(self):
      **Make sure the user input is a string value and starts with
      "/local".**
      if not isinstance(self.filename, (str, unicode)):
          return False

      if not self.filename.startswith('/local'):
          return False

      return True
```

When we add this method to our sample Agent, and run the experiment with the existing AAL file, which contains configuration that does not start with **/local**, the Orchestrator gives us an error while executing the event stream:

```
  $ magi_orchestrator.py --project $project --experiment $experiment --events ./myEvents.aal -o run.log -v
  stream initialization : sent : joinGroup myFileCreatorGroup --> __ALL__
  stream initialization : done : trigger GroupBuildDone myFileCreatorGroup  complete.
  stream initialization : sent : loadAgent myFileCreators --> myFileCreatorGroup
  stream initialization : done : trigger AgentLoadDone  myFileCreators complete.
  stream initialization : DONE : complete.
  stream main           : sent : setConfiguration(['/tmp/myCreatedFile ... ) --> myFileCreatorGroup
  stream unknown        : exit : method setConfiguration returned False on agent unknown in group unknown and on node(s): moat.
  $
```

The Orchestrator exited with an error, as it should.

If we now modify the AAL file to include a valid configuration, the Orchestrator succeeds. The updated AAL fragment is:


```
  - type: event
    agent: myFileCreators
    method: setConfiguration
    args:
       filename: /local/myGreatFile
```

When we run the Orchestrator with the modified AAL, it succeeds as the agent configuration is now valid:

```
  $ magi_orchestrator.py --project $project --experiment $experiment --events ./myEvents.aal -o run.log -v
  stream initialization : sent : joinGroup myFileCreatorGroup --> __ALL__
  stream initialization : done : trigger GroupBuildDone myFileCreatorGroup  complete.
  stream initialization : sent : loadAgent myFileCreators --> myFileCreatorGroup
  stream initialization : done : trigger AgentLoadDone  myFileCreators complete.
  stream initialization : DONE : complete.
  stream main           : sent : setConfiguration(['/local/myGreatFile ... ) --> myFileCreatorGroup
  stream main           : sent : createFile(None) --> myFileCreatorGroup
  stream main           : DONE : complete.
  $
```

And the “valid” file has been created on the machine:

```
  $ ssh myNode.myExperiment.myGroup ls -l /local
  total 4
  drwxrwxr-x 2 glawler Deter 4096 Mar  5 08:35 logs
  -rw-r--r-- 1 root    root     0 Mar  5 14:33 myGreatFile
  $

```

## Triggers and Event Stream Sequence Points

If you run the AAL and Agent code above, you may see that it does not actually work. One small needed detail has been left out of the AAL file. Normally the Orchestrator will run through the events in the AAL as fast is it can. If we used the event streams in the AAL file as it now stands:


```
  eventstreams:
      main:
          - type: event
            agent: myFileCreators
            method: setConfiguration
            args:
                filename: /local/myGreatFile

          - type: event
            agent: myFileCreators
            method: createFile
            args: {}
```


The Orchestrator will send two messages to the Agents in rapid succession: the ```setConfiguration``` and ```createFile``` event messages. If the ```setConfiguration``` call returns *False*, which it will given invalid input, the Orchestrator will not receive the message because would have sent the messages and exited. 

Therefore, we need a way to tell the Orchestrator to wait for a response from ```setConfiguration``` before continuing. This is done by inserting a small pause, using a trigger which times out after 3 seconds:


```
  # Wait 3 seconds for a response to setConfiguration
  # timeout value is in milliseconds.
  - type: trigger
    triggers: [{timeout: 3000}]
```

If we insert this trigger between ```setConfiguration``` and ```createFile```, the Orchestrator will receive the error message from the agent and exit on error.

The full AAL file now is:

```
  streamstarts: [main]

  groups:
      myFileCreatorGroup: [witch, moat]

  agents:
      myFileCreators:
          group: myFileCreatorGroup
          path: PATH/FileCreator
          execargs: []

  eventstreams:
      main:
          - type: event
            agent: myFileCreators
            method: setConfiguration
            args:
                filename: /local/myGreatFile

          - type: trigger
            triggers: [{timeout: 3000}]

          - type: event
            agent: myFileCreators
            method: createFile
            args: {}

```

But how do we know that waiting for 3 seconds is a long enough time to wait? Wouldn’t it be better if we could tell the Orchestrator to wait for a response from the agent before continuing? 

We can do this using a named trigger. We add a trigger statement to the ```setConfiguration``` event clause and modify the trigger to wait for that event before continuing to process the event stream:

```
- type: event
  agent: myFileCreators
  trigger: configDone
  method: setConfiguration
  args:
      filename: /local/myGreatFile

# Wait for the event "configDone" from all fileCreator agents.
- type: trigger
  triggers: [{event: configDone, agent: myFileCreators}]

```

Now when ```setConfiguration``` is called on the Agent, the daemon will send a trigger with the event ```configDone``` after the method has returned. With this modified trigger, the Orchestrator will wait for the trigger event ```configDone``` before processing the next event in the event stream.

Here is the Orchestrator output now. Note that ```setConfiguration``` now “fires” a trigger (sends a trigger) and the Orchestrator waits until the trigger is resolved before moving on.

```
  $ magi_orchestrator.py --project $project --experiment $experiment --events ./myEvents.aal -o run.log -v
  stream initialization : sent : joinGroup myFileCreatorGroup --> __ALL__
  stream initialization : done : trigger GroupBuildDone myFileCreatorGroup  complete.
  stream initialization : sent : loadAgent myFileCreators --> myFileCreatorGroup
  stream initialization : done : trigger AgentLoadDone  myFileCreators complete.
  stream initialization : DONE : complete.
  stream main           : sent : setConfiguration(['/local/myGreatFile ... ) --> myFileCreatorGroup  (fires trigger: configDone)
  stream main           : done : trigger configDone  complete.
  stream main           : sent : createFile(None) --> myFileCreatorGroup
  stream main           : DONE : complete.
  $
```

For reference, the new agent implementation, AAL file, and IDL, file can be downloaded as a tar file here: <a href="/downloads/FileCreator-withconfig.tbz">FileCreator-withconfig.tbz</a>.