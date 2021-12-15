# Orchestrator Data Management

Data Management is a very important aspect of experimentation, which is why the data management layer is a very important aspect of the Orchestrator's framework.

The following are some of the important terms that are used in context of Orchestrator's data management layer.

- **Sensor**: Orchestrator agent that senses information and needs to store it.
- **Collector**: Database server that can be used to store data.
- **Shard**: In case of a distributed database setup, the data is partitioned and stored in multiple database servers. This concept of partitioning data is known as "sharding", and each of the database servers is known as a "shard".

Orchestrator's data management layer is highly configurable, with experimenters having the ability to setup a centralized or a distributed database, and also configure, at the node level, where sensors collect data.

In case of a distributed/shared database setup, Orchestrator sets up a global database server. This server gives a holistic view of the database.

Orchestrator data management uses [MongoDB](http://www.mongodb.org) at its base.

## Data Manager Configuration

The data management layer configuration is part of the Orchestrator’s experiment level and node level configuration files.

As mentioned earlier, Orchestrator’s data management layer is highly configurable. More information about the same in available at <a href="../orchestrator-config/#dbdl-configure-the-magi-data-management-layer">DBDL: Configure the Orchestrator Data Management Layer</a>.

Orchestrator’s data management layer enables an experimenter to do the following.

### Sense and Collect

The following are the steps an agent developer should follow to populate Orchestrator’s database

1. Import the database management utility
~~~~
    from magi.util import database
~~~~
2. Initialize a database collection passing it a unique name. We suggest using the agent name. Each agent implementation that extends from one of the predefined agents, like the DispatchAgent, has a variable “name” that stores the agent name.
~~~~
    self.collection = database.getCollection(self.name)
~~~~
3. Insert data. Each record can be inserted as a dictionary of key-value pairs.
~~~~
    self.collection.insert({“key1” : “value1”, “key2”: “value2”})
~~~~

!!! note
    The db management utility inserts three other entries per record:
    
      - host: ``<node’s hostname>``
      
      - created: `<record creation time>`
      
      - agent: `<agent name>`

### Query and Analyze

In case of a distributed database setup, a user can connect to the mongo db server running on the global server node to get an experiment-wide view.

However, in case of an unsharded setup, a user would have to connect to the appropriate collector based on the sensor-collector mapping to fetch data stored by a particular sensor.

Orchestrator, by default, sets up an non-distributed database, with all the sensors collecting at the same collector.

    > mongo node-1.myExperiment.myProject:27018
    mongo> use magi
    switched to db magi
    mongo> db.experiment_data.find()
    { "agent" : "user_agent", "host" : "node-1", "created" : 1409075736.646182,
    "key1" : "value1", "key2" : "value2" }
    { "agent" : "user_agent", "host" : "node-2", "created" : 1409075737.514683,
    "key3" : "value3", "key4" : "value4" }
    In case of a distributed setup, the configuration file would have information about a global server host. An experimenter can connect to the global server to get an experiment wide view of the database, or connect to individual collectors to get their local view.

And, for more advanced queries, you can refer the Mongo documentation available at [http://docs.mongodb.org/manual/tutorial/query-documents/](http://docs.mongodb.org/manual/tutorial/query-documents/).