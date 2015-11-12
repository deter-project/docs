Access to the EARS cluster is filtered by a bastion host.  We figured the easiest way to provide secure access to users was to use SSH as a proxy from a bastion host.  Here is an overview of the steps.

* Get access to egate.deterlab.net which is the bastion host for the EARS testbed.
* Use egate.deterlab.net as a SOCKS proxy to access the web interface at https://www.ears.deterlab.net/
* Apply to your project on EARS.

# Logging into EGATE, the bastion host

* First, create a SSH key pair and email the public key, as an attachment, to us.  Also let us know what your preferred username is.
* Once you get word that your account has been created, please try to SSH to *egate.deterlab.net_'  The '_-D 1080* will open a SOCKS proxy port on your local machine. 

    	
	$ ssh jjh@egate.deterlab.net -D 1080
	Last login: Thu Jul 18 16:40:33 2013 from pod.isi.edu
	FreeBSD 9.1-RELEASE-p3 (EGATE) #2: Fri Jun  7 17:48:53 PDT 2013
	
	Welcome to FreeBSD!
	
	
	Handy bash(1) prompt:  PS1="\u@\h \w \!$ "
			-- David Scheidt <dscheidt@tumbolia.com>
	[jjh@egate ~]$ 
	    

You can also edit your .ssh/config file to automatically setup forwarding every time you login to elate:

	
	# Ears cluster
	Host egate
	        HostName egate.deterlab.net
	        DynamicForward 1080
	

# Using the Proxy for the EARS web interface


* You can now configure your browser to use the SOCKS port.  There are two ways to do this.  For both we recommend using Firefox.

## Sending all Firefox traffic through egate.deterlab.net

This is the easiest way to get going, but all web traffic will be sent through egate.deterlab.net.  

* Open Firefox settings window and select the *Advanced* tab
   [[Image(FirefoxSettings.png)]]

* Now select the *Settings...._' button on the top right of the page under the '''Connection''' heading.  Select '''Manual Proxy Configuration''' and put '''127.0.0.1''' in as the '''SOCKS Host''' and '''1080''' as the port.  Select the '_SOCKS v5* radio button.

   [[Image(FirefoxConnection.png)]]

## Sending only web traffic destined for www.ears.deterlab.net through the proxy

We recommend using Firefox with the FoxyProxy Standard extension.  This extension allows finer grained control of how the proxy is used.

* Once the FoxyProxy Standard plugin is installed, you can go to *Tools -> FoxyProxy -> Options*
   [[Image(AddOns.png)]]
* Click the "Add New Proxy" button on the right.
   [[Image(AddNewProxy.png)]]
* Under the proxy Details tab, fill in 127.0.0.1 for the *Host or IP Address_' field, select the '''SOCKS proxy?''' check box, and select '_SOCKS v5*
   [[Image(ProxyDetails.png)]]
* Now click the *URL Patterns* button at the top.  Add in the following pattern for EARS:
   [[Image(URLPattern.png)]]
* Now in the main window, make sure *Select Mode:_' at the top is set to '_Use proxies based on their pre-defined patterns and priorities*
   [[Image(SelectMode.png)]]

* Now you should be able to access the web interface of the EARS cluster.

# Accessing the Web Interface

* Once you have your proxy properly configured, you can access the web interface of the EARS cluster at [https://www.ears.deterlab.net/](https://www.ears.deterlab.net) 

* If you are new to the EARS cluster, you will need to [Join an Existing Project](https://www.ears.deterlab.net/joinproject.php)
# Logging into users

You can log into users.ears.deterlab.net from egate.  You will need to apply to a project and be approved before you can log into users since the EARS testbed is distinct from the ISI testbed.