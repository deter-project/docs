[[TOC]] 



# Experiments

(Adopted from the NewAPI, need to modify)

The experiment interface controls managing experiment definitions and realizing experiments (allocating and initializing resources). The experiment definition is in some flux, which is reflected in this section.

## Viewing Experiments

One or more experiments can be viewed by an authorized user assuming that user has the proper permissions.  The creator of a project owns it and that userid scopes its name.  That is an experiment's name is a pair: (owner, name).  This allows experiments to be instantiated in different projects.


* *Service:* Experiments
* *Operation:* viewExperiments
* *Input Parameters:*
   * Userid - the user making the request
   * ExperimentRE - a string containing a regular expression matched against project names (may be omitted)
   * Owner - a string holding the owner of experiments to find (may be omitted)
   * Components - a 32-bit integer containing a mask of fields to include
     * EXPERIMENT_TOPOLOGY - include the topology
     * EXPERIMENT_ACTIONS - include the actions
     * EXPERIMENT_CONSTRAINTS - include constraints
     * EXPERIMENT_DATACOLLECTION - include data collection 
     * EXPERIMENT_RESOURCES - include resources needed or allocated
     * EXPERIMENT_CONTAINERS - include components if realized
     * EXPERIMENT_LOG - include realization log and fault
     * EXPERIMENT_PERMISSIONS - include project permissions
   * TopologyFormat - an optional 32-bit int naming the topology format
     * TOPOLOGY_TOPDL - return a topdl file
     * TOPOLOGY_NS2 - return an ns2 file
   * TopologyFilter - an optional filter for limiting scope of the topology file format TBD
   * ActionFormat - an optional 32-bit int naming the action file format (values TBD)
   * ActionFilter - an optional filter for limiting scope of the constraint file format TBD
   * ConstraintFormat - an optional 32-bit int naming the constraint format (values TBD)
   * ConstraintFilter - an optional filter for limiting scope of the constraint file format TBD
   * DataCollectionFormat - an optional 32-bit int naming the data collection format (values TBD)
   * DataCollectionFilter - an optional filter for limiting scope of the data collection file format TBD
   * ResourceFilter - an optional filter for limiting scope of the resouces returned format TBD
   * ContainerFilter - an optional filter for limiting scope of the constainers returned format TBD

* *Return Values:*
   * One or more structures with the following fields
     * Name - a string containing the experiment name
     * Owner - a string containing the owner's userid
     * Project - an optional string. If present the experiment is realized under this project
     * Topology - an optional file describing the experiment topology subject to filters and format constraints
     * Actions - an optional file describing the experiment actions subject to filters and format constraints
     * Constraints - an optional file describing the experiment constraints subject to filters and format constraints
     * DataCollection - an optional file describing the experiment data collection subject to filters and format constraints
     * Containers - an optional list with the following fields describing the containers in the experimnet, if it is realized. Subject to filtering.
       * Name - the container name
       * State - a string indicating state (Up, Down, Configured, Pinned, None)
       * Type - a string indicating the container type
     * Resources - an optional list of structures giving resources needed by or allocated to the experiment, subject to filtering.
       * Name - resource name
       * Type - resource type
     * State - a string, one of
       * "Unrealized", "Realized", "Changing", "Pinned" (Pinned means that some modification other than realization is underway)
     * StateDetail - a string giving additional state information.  values TBD
     * Log - an optional file containing messages from the last realization attempt for debugging
     * FaultInfo - an optional structure containing the high level error message (if any) from the last realization.  It contains the error fields from a DeterFault:
        * ErrorCode - a 32-bit integer encoding the type of error.  Constants are available in the [javadoc for DeterFault](http://www.isi.edu/~faber/tmp/doc/net/deterlab/testbed/api/DeterFault.html).  Values are:
          * access - access denied
          * request - bad request
          * internal - internal server error
        * ErrorString - a string describing the broad error
        * DetailString - a string describing the details that caused the error
     * ReadProjects - a list of project names allowed to read this experiment
     * WriteProjects - a list of project names allowed to modify this experiment
     * RealizeProjects - a list of project names allowed to realize this experiment

## Creating and Deleting Experiments

An experiment is created using:

* *Service:* Experiments
* *Operation:* createExperiment
* *Input Parameters:*
   * Userid - the user making the request (the owner on success)
   * Name - a string containing a new experiment's name
   * Topology - an optional file describing the experiment topology 
   * Actions - an optional file describing the experiment actions 
   * Constraints - an optional file describing the experiment constraints s
   * DataCollection - an optional file describing the experiment data collection
   * ReadProjects - a list of project names allowed to read this experiment
   * WriteProjects - a list of project names allowed to modify this experiment
   * RealizeProjects - a list of project names allowed to realize this experiment
* *Return Values:*
   * None

An experiment is modified using:

* *Service:* Experiments
* *Operation:* modifyExperiment
* *Input Parameters:*
   * Userid - the user making the request (the owner on success)
   * Owner - the experiment owner
   * Name - a string containing the experiment's name
   * Topology - an optional file describing the experiment topology 
   * Actions - an optional file describing the experiment actions 
   * Constraints - an optional file describing the experiment constraints s
   * DataCollection - an optional file describing the experiment data collection
   * ReadProjects - a list of project names allowed to read this experiment
   * WriteProjects - a list of project names allowed to modify this experiment
   * RealizeProjects - a list of project names allowed to realize this experiment
* *Return Values:*
   * None

Omitted arguments are not overwritten.  To delete a field supply an empty description.

There will also be filter-based modification interfaces, but these are TBD.

An experiment is deleted using:
 
* *Service:* Experiments
* *Operation:* removeExperiment
* *Input Parameters:*
   * Userid - the user making the request (the owner on success)
   * Owner - the experiment owner
   * Name - a string containing the experiment to delete
* *Return Values:*
   * None

After `removeExperiment` succeeds, experiment state is removed from the testbed completely.

## Realizing and Releasing Experiments

To realize an experiment use:
 
* *Service:* Experiments
* *Operation:* realizeExperiment
* *Input Parameters:*
   * Userid - the user making the request (the owner on success)
   * Owner - the experiment owner
   * Name - a string containing the experiment to realize
   * Notify - a flag, if true send the user a notification when realization is complete
* *Return Values:*
   * None

The user can either poll the experiment using `viewExperiments` and examining the `StateDetail` field or poll for a notification that the realization is complete.

If the realization fails - as indicated by the `State` variable in a `viewExperiments` response, the `Log` and `FaultInfo` fields characterize the error.

To release an experiment's resources:

* *Service:* Experiments
* *Operation:* releaseExperiment
* *Input Parameters:*
   * Userid - the user making the request (the owner on success)
   * Owner - the experiment owner
   * Name - a string containing the experiment to release
   * Notify - a flag, if true send the user a notification when realization is complete
* *Return Values:*
   * None

After `releaseExperiment` succeeds, experiment state remains in the testbed, but containers are stopped and resources are returned to the testbed.
