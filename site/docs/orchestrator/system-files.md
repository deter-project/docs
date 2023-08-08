
!!! important
    This page is deprecated. Please use our <a href="https://launch.mod.deterlab.net/">new platform</a> and accompanying documentation.

# MAGI System Organization

The MAGI system is divided into **magicore** and **magimodules**.

## magicore

The **magicore** consists of the group communication, control, and data management infrastructure.

The latest available version for use on DETERLab may be found on `users` at:

~~~~
/share/magi/current/
~~~~

The MAGI codebase is also available at a publically accessible repository.
~~~~
https://github.com/deter-project/magi.git
~~~~

## magimodules
The **magimodules** are agent function implementations that enable a particular behavior on the experiment nodes.

The agents along with supporting documentation and file are located on `users` at:

~~~~
/share/magi/modules
~~~~

The MAGi modules are also available at a publically accessible repository.
~~~~
https://github.com/deter-project/magi-modules.git
~~~~

## Logs
You can find helpful logs in these locations in `users`

* **LOG_DIR**

    Check experiment configuration file. Default: `/var/log/magi`

* **MAGI Bootstrap Log**

    `/tmp/magi_bootstrap.log`

* **MAGI Daemon Log** 

    `$LOG_DIR/daemon.log`

* **MongoDB Log** 

    `$LOG_DIR/mongo.log`

## Configuration Files
The following configuration files are available in `users`:

*  **Agent**

    Name for the set of nodes that represent the behavior

* **Experiment Configuration**

    `/proj/<project_name>/exp/<experiment_name>/experiment.conf`

* **CONF_DIR**

    Check experiment configuration file. Default: `/var/log/magi`

* **Node Configuration**

    `$CONF_DIR/node.conf`


