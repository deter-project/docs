# Using Your Nodes

## Know your DETER servers
Here are the most important things to know.

 * `www.isi.deterlab.net` is the primary web interface for the testbed.
 * `users.deterlab.net` is the host through which the testbed nodes are accessed and it is primary file server.
 * `scratch` is the local package mirror for CentOS, Ubuntu, and FreeBSD.

## Accessing your nodes

To access your nodes you will need to:

1. Swap in your experiment
1. SSH into `users.deterlab.net`
1. SSH into your experimental nodes using `node.exprt.proj`. For example to access node `client` in experiment `test` and project `CS444` one could type `ssh client.test.CS444` on the users.deterlab.net. 

Please see more detailed documentation about [hostnames](hostnames.md) and [logging in](logging-in.md).

## Modes of Use

There are several ways in which you can use your nodes:

1. As you start developing your experiment you may want to design your NS topology, swap the experiment in, and then SSH to your nodes and manually execute commands.

2. As your work progresses you may want to develop *scripts* (e.g., using Bash or Python or MAGI or Ansible) to automate running of your experiments

We have developed three toolkits to help you with experiment design and automation. First, you can use [DEW - distributed experiment workflows](https://dew.isi.edu) to design your experiment in a human-readable format and generate NS file and bash scripts. We provide more guidance on this direction in [DEW YouTube channel](https://www.youtube.com/channel/UCocyRn8Lk40f_1giKrDnRLQ/) as well as in documentation on DEW Web site.

Second, if you use image Ubuntu-DEW on your nodes, all the commands you type and snippets of their outputs will be saved in your project directory. You can use the tool *flight_log*, which is automatically installed in that image, to remind yourself of the commands you ran in the past and to select those you want to include in a Bash script. The script will be automatically generated for you. More information about this direction is in [DEW YouTube channel](https://www.youtube.com/channel/UCocyRn8Lk40f_1giKrDnRLQ/).

Third, you can use our [MAGI orchestrator](../orchestrator/orchestrator-guide.md) to create scripts that will be more robust and readable than Bash scripts.

## FAQ

We have compiled a list of frequenty asked questions about node access [here](faq.md)
