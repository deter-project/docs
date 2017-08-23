# MAGI Agent Library

Every node has a daemon running with a series of Agents on it. These Agents are each executed in their own thread or process. They are provided with a defined interface with which to send and receive messages to other objects in the experiment. The MAGI daemon will route messages to the agent based on the routing information in the message. The daemon supports group-based, name-based, and “dock”-based routing. (A dock is like a port for a traditional daemon; an agent listens on a dock.) Once a message is delivered to an agent, the format of the message data is then up to the agent itself.

Most agents will not need to parse messages directly, however, because the MAGI Agent Library supports a number of useful abstractions implemented in base classes from which Agent authors can derive. These are described in detail below.

###  Agent Execution Models

There are two execution models supported by the daemon for Agents: 
* ** Thread-based**  - A thread-based Agent is loaded and runs in the process space of the daemon. The daemon communicates with a thread-based agent directly
* ** Process-based**  - A process-based Agent is started as a separate process. The daemon communicates with it via standard interprocess communication techniques: a pipe or a socket.

Here is a list outlining the differences between the execution models.

** Threads** 

* ** Pro** : Lightweight
* ** Pro** : Messages passed as objects without need for serialization
* ** Con** : Must be written in Python
* ** Con** : Must be aware of other threads when it comes to file descriptors or other shared memory

** Process**  (Pipe or Socket)

* ** Pro** : Agents may be written in languages other than Python.
* ** Pro** : May kill off agent individually from the shell
* ** Con** : Heavier weight if invoking a new interpreter for each Agent for scripted languages
* ** Con** : Message transceiver is more complex, in particular if a library for the language has not been written. (

!!! note
    As of now, only Python is supported. We are working on adding support for other languages.)

###  Interface Description Language (IDL)

Agent authors must write an IDL that matches the interface exported by their agent. This IDL is used by MAGI to validate the interface of the agent (and in the future to generate GUIs for agent execution and configuration.) 

The IDL should specify: 
* agent execution model (thread or process);
* any public agent variables and their types, ranges, or enumerated values; 
* any public methods and the method arguments and their types; 
* “help” strings for each method and agent variable which explain their purpose; 
* and finally any Agent library from which they derive.

This may seem like a lot to specify, but the Agent Library supplies IDL for base Agents --  so in practice much of the IDL specification will be supplied to the Agent author.

The IDL format and keywords are given in a table below. 

(TBD - Coming soon)

###  Agent Library

In this section we describe the Agent Library and give brief examples for usage. Classes are organized from the bottom up, that is, starting with the class from which the others derive.

!!! note
    When using the Orchestrator to run your experiment, the Orchestrator will, by default, handle a return value of *False* from an Agent method as a reason to unload all Agents, break down communication groups and exit. Thus your Agent may stop an experiment by returning *False*.

#### ```Agent```

This is the base Agent class. It implements a ```setConfiguration``` method. If derived from, the user may call ```setConfiguration``` to set any ```self``` variables in your class. 

Agent also implements an empty ```confirmConfiguration``` method that is called once the ```self``` variables are set. You may implement your own ```confirmConfiguration``` if you need to make sure the user has set your internal variables to match any constraints you may want to impose. Returning *False* from this method will signal to the Orchestrator that something is wrong and the Orchestrator should handle this as an error. The default implementation of ```confirmConfiguration``` simply returns *True*. 

The method signature for ```confirmConfiguration()``` is

```
def confirmConfiguration(self):
```

It takes no arguments. 

In your ```confirmConfiguration``` method, you should confirm that your agent internal variables are the correct type and in the expected range.

In the following example, imagine an agent has a variable that is an integer and the range of the value must be between 1 and 10. An agent can use the ```Agent``` class to implement this as so:


```
from magi.util.agent import Agent

class myAgent(Agent):
    def __init__(self):
        self.value = None

    def confirmConfiguration():
        if not isinstance(self.value, int):
            return False

        if not 1 <= self.value <= 10:
            return False

        return True
```

If the variable ```self.value``` is not an integer or is not between 1 and 10, ```confirmConfiguration``` returns *False*. If running this agent with the Orchestrator, the *False* value will get returned to the Orchestrator which will unload all agents, destroy all group communications, then exit. Thus your agent may cause the experiment to stop and be reset when it is not given the correct inputs.

!!! note
    In the future, this functionality of enforcing correct input will be handled outside of the agent code. The IDL associated with the agent already specifies correct input and the Orchestrator (or other Montage/MAGI front end tool) will enforce proper input.

All classes in the ```AgentLibrary``` inherit from ```Agent```.

The ```Agent``` documentation can seen <a href="http://montage.deterlab.net/backend/python/util.html#magi.util.agent.Agent">here</a>.

#### ```DispatchAgent```

The ```DispatchAgent``` implements the simple remote procedure call (RPC) mechanism used by the Orchestrator (and available through the MAGI python API). This allows any method in a class derived from ```DispatchAgent``` to be invoked in an AAL file (or by a ```MagiMessage``` if using the MAGI python interface directly). 

You almost always want to derive your agent from ```DispatchAgent```. The ```DispatchAgent``` code simply loops, parsing incoming messages, looking for an event message. When it finds one, it attempts to call the method specified in the message with the arguments given in the message, thus implementing a basic RPC functionality in your agent.

The first argument to your RPC-enabled method is the received message. It is accompanied by the optional named-parameters, sent as part of the ```MagiMessage```. The Agent Library exports a function decorator for ```DispatchAgent```-callable methods named ```agentmethod```. It is not currently used for anything, but it is suggested that agent developers use it anyway.

The ```DispatchAgent``` reads incoming messages and invokes the required method synchronously, i.e., it waits for a method call to return before reading the next message.

Here is a simple example:

```
from magi.util.agent import DispatchAgent, agentmethod

def myAgent(DispatchAgent):
    def __init__(self):
        DispatchAgent.__init__(self)

    @agentmethod()
    def doAction(self, msg):
        pass
```

Given the agent ```myAgent``` above and the AAL fragment below, the method ```doAction``` will be called on all test nodes associated with ```myAgentGroup```.

```
eventstreams:
    myStream:
        - type: event
          agent: myAgentGroup
          method: doAction
          args: { }
```

The ```DispatchAgent``` documentation may seen <a href="http://montage.deterlab.net/backend/python/util.html#magi.util.agent.DispatchAgent">here</a>. 

#### ```NonBlockingDispatchAgent```

The ```NonBlockingDispatchAgent``` is similar to ```DispatchAgent```. The only difference is that ```NonBlockingDispatchAgent``` invokes the methods *asynchronously*, i.e., it forks a new thread for each method call and does not wait for the call to return. It invokes the required method and moves on to read the next message.

#### ```ReportingDispatchAgent```

You will note that the ```DispatchAgent``` only allows an outside source to send commands to the agent. There is no communication backwards. The ```ReportingDispatchAgent``` base class has a slightly different run loop. Rather than blocking forever on incoming messages, it will also call its own method, ```periodic```, to allow other operations to occur.

The call to ```periodic``` will return the amount of time in seconds (as a float) that it will wait until calling ```periodic``` again. The ```periodic``` function therefore controls how often it is called. The first call will happen as soon as the run is called.

The method signature of the ```periodic``` method is:

```
def periodic(self, now):
```

If ```periodic``` is not implemented in the subclass, an exception is raised.

This example code writes the current time to a file once a second. Note the explicit use of the ```Agent``` class to set the file name.

```
import os.path
from magi.util.agent import ReportingDispatchAgent, agentmethod

class myTimeTracker(ReportingDispatchAgent):
    def __init__(self):
        ReportingDispatchAgent.__init__(self)
        self.filename = None

    def confirmConfiguration(self):
        if not os.path.exists(self.filename):
            return False

    def periodic(self, now):
        with open(self.filename, 'a') as fd:
            fd.write('%f\n' % now)

        # call again one second from now
        return 1.0

```

The ```ReportingDispatchAgent``` documentation may seen here. http://montage.deterlab.net/backend/python/util.html#magi.util.agent.ReportingDispatchAgent

#### ```SharedServer```

The ```SharedServer``` class inherits from ```DispatchAgent``` and expects the subclass to implement the methods ```runserver``` and ```terminateserver``` to start or stop a local server process. 

The ```SharedServer``` class takes care of multiple agents requesting use of the server and only calls ```runserver``` or ```terminateserver``` when required. This ensures that there is ever only one instance of the server running at once on a given host. A canonical example of this would be a web server running a single instance of Apache. The methods ```runserver``` and ```stopserver``` take no arguments.

Below is an example of a simple agent that starts and stops Apache on the local host. If there are other agents running on the machine that require Apache to be running, they may inherit from ```SharedServer``` as well, thus ensuring that there is only ever one instance of Apache running.

```
from subprocess import check_call, CalledProcessError
from magi.util.agent import SharedServer

class ApacheServerAgent(SharedServer):
    def __init__(self):
        SharedServer.__init__(self)

    def runserver(self):
        try:
            check_call('apachectl start'.split())

        except CalledProcessError:
            return False

        return True

    def stopserver(self):
        try:
            check_call('apachectl stop'.split())

        except CalledProcessError:
            return False

        return True
```

The ```SharedServer``` documentation may seen <a href="http://montage.deterlab.net/backend/python/util.html#magi.util.agent.SharedServer">here</a>. 

#### ```TrafficClientAgent```

```TrafficClientAgent``` models an agent that periodically generates traffic. It must implement the ```getCmd``` method, returning a string to execute on the commandline to generate traffic. For example, the ```getCmd``` could return a ```curl``` or ```wget``` command to generate client-side HTML traffic. The signature of ```getCmd``` is:

```
def getCmd(self, destination)
```

Where ```destination``` is a server host name from which the agent should request traffic. 

The ```TrafficClientAgent``` class implements the following event-callable methods: ```startClient()``` and ```stopClient()}}. Neither method takes any arguments. These methods may be invoked from an AAL and start and stop the client respectively.

The base class contains a number of variables which control how often ```getCmd``` is called and which servers should be contacted: 
* ```servers```: A list of server hostnames
* ```interval```: A distribution variable

!!! note
    A distribution variable is any valid python expression that returns a float. It may be as simple as an integer, “1”, or an actual distribution function. The Agent Library provides ```minmax```, ```gamma```, ```pareto```, and ```expo``` in the distributions module. Thus a valid value for the ```TrafficClientAgent``` interval value could be ```minmax(1,10)```, which returns a value between 1 and 10 inclusive. The signatures of these distributions are:

        minmax(min, max)
        gamma(alpha, rate, cap = None)
        pareto(alpha, scale = 1.0, cap = None)
        expo(lambd, scale = 1.0, cap = None)

Below is a sample ```TrafficClientAgent``` which implements a simple HTTP client-side traffic agent. It assumes the destinations have been set correctly (via the ```Agent setConfiguration``` method) and there are web servers already running there.

```
from magi.util.agent import TrafficClientAgent

class mySimpleHTTPClient(TrafficClientAgent):
    def __init__(self):
        TrafficClientAgent.__init__(self)

    def getCmd(self, destination):
        cmd = 'curl -s -o /dev/null http://%s/index.html' % destination
        return cmd
```

When this agent is used with the following AAL clauses, the servers ** server_1**  and ** server_2**  are used as HTTP traffic generation servers and traffic is generated once an interval where the interval ranges randomly between 5 and 10 seconds, inclusive. The first event sets the agent’s internal configuration. The second event starts the traffic generation.

```
eventstreams:
    myStream:
        - type: event
          agent: myHTTPClients
          method: setConfiguration
          args:
                interval: 'minmax(5, 10)'
                servers: ['server_1', 'server_2']

        - type: event
          agent: myHTTPClients
          method: startClient
          args: { }
```

The ```TrafficClientAgent``` documentation may seen here. http://montage.deterlab.net/backend/python/util.html#magi.util.agent.TrafficClientAgent

#### ```ProbabilisticTrafficClientAgent```

```ProbabilisticTrafficClientAgent``` provides the same service as ```TrafficAgent```, but ```getCmd``` is called only when the configured probability function evaluates to a non-zero value.

#### ```ConnectedTrafficClientAgent```

```ConnectedTrafficClientAgent``` is a base for an agent that controls a set of agents that have standing connections to, and traffic between, a set of servers. 

```connect()``` and ```disconnect()``` are called periodically when a given client should connect or disconnect to a given server. 

```generateTraffic()``` is called when the given client should generate traffic between itself and the server it is connected to. The sequence of calls is: 

```
[period], connect(), [period], generateTraffic(), [period], generateTraffic(), ..., disconnect()
```

This sequence may be repeated.

Derived classes should implement ```connect()```, ```disconnect()```, and ```generateTraffic()```.

### Agent Load and Execution Chain (for threaded agents)

(TBD - Coming soon)

