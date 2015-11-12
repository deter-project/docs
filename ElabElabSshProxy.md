# Setting up FoxyProxy

This only needs to be done once.

Install the [FoxyProxy extension](https://addons.mozilla.org/en-US/firefox/addon/2464/) for Firefox. Restart your browser to complete the installation.

Follow these steps to set up the proxy. Text you should input is *bold*.

Click the __A__dd New Proxy button

* P__r__oxy Details tab
   * use __M__anual Proxy Configuration.
   * __H__ost: *localhost_' __P__ort: '_1080*
   * Check the box for SOCKS 5 proxy
* URL __P__atterns tab
   * click __A__dd New Pattern
   * __P__attern Name: *elab in elab* (or anything you want)
   * __U__RL pattern: *https?://myboss\..*deterlab\.net/_' (for MacOS, append '_.**)
   * change "Pattern Contains" to Regular expression
   * click OK
* __G__eneral tab
  * give it a good name, like *Elab in Elab tunnel*
  * click OK
* Use the Move __U__p button to move the new pattern to the top of the list
* Change the Mode at the top to *Use Proxies based on their pre-defined patterns and priorities*

# Connecting to Inner Boss

Once you've set up FoxyProxy, whenever you want to connect to inner boss you must start an SSH SOCKS proxy. To do this using the standard OpenSSH command line client on linux, *BSD, or OsX :
	
	ssh -D 1080 username@users.isi.deterlab.net
	

You can also do this under windows using the PuTTY client:

In the PuTTY configuration window expand "Connection", then "SSH", and click on tunnels.
Hit the radio button for dynamic, fill in the port 1080, and click ADD.

Don't specify the host here - do it after clicking on the main Session Category.
If you save the parameters you won't have to do this again.


You may then access inner boss using the url:
	
	http://myboss.${experiment_name}.${project_name}.isi.deterlab.net/
	
Fill in ` ${experiment_name} ` and ` ${project_name} ` with your experiment and project. For instance, the experiment *test123_' in the '_example* project would use this URL:
	
	http://myboss.test123.example.isi.deterlab.net/
	

Once you are done, you may close the SSH tunnel connection. You may have to use Ctrl-C if it does not disconnect after you log out.