# Using Your Nodes

## Know your DETER servers
Here are the most important things to know.

 * `www.isi.deterlab.net` is the primary web interface for the testbed.
 * `users.deterlab.net` is the host through which the testbed nodes are accessed and it is primary file server.
 * `scratch` is the local package mirror for CentOS, Ubuntu, and FreeBSD.

## Accessing your nodes

## Modes of use

There are several ways in which you can access your nodes:

1. As you start developing your experiment, you may want to SSH to your experiment and configure nodes or generate traffic manually. See our [guidelines](interact.md) for interacting with your nodes.

2. As your work progresses you may want to develop scripts (e.g., using Bash or Python or MAGI or Ansible) to automate running of your experiments

We have developed three toolkits to help you with experiment design and *automation*.

1. [DEW - distributed experiment workflows](https://dew.isi.edu) can be used to design your experiment in a human-readable format and generate NS file and bash scripts. We provide more guidance on this direction in [DEW YouTube channel](https://www.youtube.com/channel/UCocyRn8Lk40f_1giKrDnRLQ/) as well as in [documentation](https://dew.isi.edu/docs/) on DEW Web site.

Second, if you use image Ubuntu-DEW on your nodes, all the commands you type and snippets of their outputs will be saved in your project directory. You can use the tool `flight_log`, which is automatically installed in that image, to remind yourself of the commands you ran in the past and to select those you want to include in a Bash script. The script will be automatically generated for you. More information about this direction is in [DEW YouTube channel](https://www.youtube.com/channel/UCocyRn8Lk40f_1giKrDnRLQ/).

Third, you can use our [MAGI orchestrator](https://docs.deterlab.net/orchestrator/orchestrator-guide/) to create scripts that will be more robust and readable than Bash scripts.

