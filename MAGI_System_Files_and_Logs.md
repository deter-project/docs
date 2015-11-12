[wiki:OrchestratorReference < Orchestrator Reference] | [wiki:MAGI_Agent_Library MAGI Agent Library >]

[[TOC]]

# MAGI System Organization

The MAGI system is divided into *magicore_' and '_magimodules*.

The *magicore* consists of the group communication, control, and data management infrastructure.

The latest available version for use on DeterLab may be found on `users` at:

	
	/share/magi/current/
	

The *magimodules* are agent function implementations that enable a particular behavior on the experiment nodes.

The agents along with supporting documentation and file are located on `users` at:

	
	
	/share/magi/modules
	

(Cris: dirs in modules currently read:
* apache
* attackreplay
* curl_reporter
* flooder
* http_client
* http_server
* loadGenerator
* nodeStats
* pktcounters
* runcmd
* runshell
* tb_compat.tcl
* tcpdump

but none of these were listed in the agent library. what's the difference?)

## Logs
You can find helpful logs in these locations in `users`:

 LOG_DIR:: Check experiment configuration file. Default: /var/log/magi
 MAGI Bootstrap Log:: /tmp/magi_bootstrap.log
 MAGI Daemon Log:: $LOG_DIR/daemon.log
 MongoDB Log:: $LOG_DIR/mongo.log

## Configuration Files
The following configuration files are available in `users`:

 Experiment Configuration:: /proj/<project_name>/exp/<experiment_name>/experiment.conf
 CONF_DIR:: Check experiment configuration file. Default: /var/log/magi
 Node Configuration:: $CONF_DIR/node.conf

[wiki:OrchestratorReference < Orchestrator Reference] | [wiki:MAGI_Agent_Library MAGI Agent Library >]