# Automating Your Experimentation

Once you have developed your experiment and set everything up, you may want to automate that setup so you can easily re-run the experimetn later. There are multiple ways to automate your experiment.

## Scripting ##

You can write scripts using languages like Bash and Python to run commands on your nodes in a given scenario. For example, if you wanted to ping B from A and then ping A from B, in an experiment called `test` and project `Share`,  you could write the following script in bash:
```
	ssh A.test.Share "ping -c 1 B"
	ssh B.test.Share "ping -c 1 A"
```
You can then save it, e.g., in a file called `ping.sh` and run it by typing on `users.deterlab.net`:
```
	bash ping.sh
```
Similarly, in Python you can achieve the same with the following script:
```
	import paramiko
	ssh = paramiko.SSHClient()
	ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	ssh.connect("A.test.Share")

	stdin, stdout, stderr = ssh.exec_command("ping -c 1 B")
	ssh.connect("B.test.Share")

	stdin, stdout, stderr = ssh.exec_command("ping -c 1 A")
```
You can then save it, e.g., in a file called `ping.py` and run it *on one of your experiment nodes* (not on `users.deterlab.net`) by typing:
```
	python ping.py
```
## DEW

You can use [DEW - distributed experiment workflows](https://dew.isi.edu) to design your experiment in a human-readable format and generate NS file and bash scripts. `

We provide more guidance in [DEW YouTube channel](https://www.youtube.com/channel/UCocyRn8Lk40f_1giKrDnRLQ/) as well as in [documentation](https://dew.isi.edu/docs/) on DEW Web site.

If you use image Ubuntu-DEW on your nodes, all the commands you type and snippets of their outputs will be saved in your project directory. You can use the tool flight_log, which is automatically installed in that image, to remind yourself of the commands you ran in the past and to select those you want to include in a Bash script. The script will be automatically generated for you. More information about this direction is in [DEW YouTube channel](https://www.youtube.com/channel/UCocyRn8Lk40f_1giKrDnRLQ/).

## Orchestrator

You can use our MAGI orchestrator to create scripts that will be more robust and readable than Bash scripts. Please see our [orchestrator](../../orchestrator/) documentation for guidelines and examples.