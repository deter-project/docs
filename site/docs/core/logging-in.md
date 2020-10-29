# Logging into your Node

  By the time you receive the email message listing your nodes, the DETER configuration system will have ensured that your nodes are fully configured and ready to use. If you have selected one of the DETER-supported operating system images <a href="/core/os-images/">see supported images</a>), this configuration process includes:
    * loading fresh disk images so that each node is in a known clean state;
    * rebooting each node so that it is running the OS specified in the NS script;
    * configuring each of the network interfaces so that each one is "up" and talking to its virtual LAN (VLAN);
    * creating user accounts for each of the project members;
    * mounting the projects NFS directory in /proj so that project files are easily shared amongst all the nodes in the experiment;
    * creating a /etc/hosts file on each node so that you may refer to the experimental interfaces of other nodes by name instead of IP number;
    * configuring all of the delay parameters;
    * configuring the serial console lines so that project members may access the console ports from users.deterlab.net.

As this point you may log into any of the nodes in your experiment. You will need to use <a href="/core/DETERSSH/">Secure Shell (ssh)</a> to log into `users.deterlab.net`
Your login name and password will be the same as your Web Interface login and password.  

!!! note
    Although you can log into the web interface using your email address instead of your login name, you must use your login name when logging into `users.deterlab.net`.

Once logged into users you can then SSH to your nodes.  You should use the `qualified name' from the nodes mapping table so that you do not form dependencies on any particular physical node.  For more information on using SSH with DETER, please take a look at the <a href="/core/DETERSSH/">DETER SSH</a> wiki page.
