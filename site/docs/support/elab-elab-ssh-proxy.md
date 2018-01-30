# Setting Up FoxyProxy

This only needs to be done once.

Install the [FoxyProxy extension](https://addons.mozilla.org/en-US/firefox/addon/2464/) for Firefox. Restart your browser to complete the installation.

Follow these steps to set up the proxy. Text you should input is '''bold'''.

Click the "Add New Proxy" button

* *Proxy Details* tab:
    * Use "Manual Proxy Configuration".
        * Host: ```localhost``` Port: ```1080```
        * Check the box for SOCKS 5 proxy
* *URL Patterns* tab:
    * Click "Add New Pattern"
    * Pattern Name: '''elab in elab''' (or anything you want)
    * URL pattern: '''https?://myboss\..*deterlab\.net/''' (for MacOS, append '''.*''')
    * Change "Pattern Contains" to Regular expression
    * Click OK
   
* *General* tab:
    * Give it a good name, like '''Elab in Elab tunnel'''
    * Click OK
  
* Use the "Move Up" button to move the new pattern to the top of the list
* Change the Mode at the top to ```Use Proxies based on their pre-defined patterns and priorities```.

## Connecting to Inner Boss

Once you've set up FoxyProxy, whenever you want to connect to inner boss you must start an SSH SOCKS proxy. 

To do this using the standard OpenSSH command line client on linux, BSD, or OsX:

```
ssh -D 1080 username@users.isi.deterlab.net
```

You can also do this under windows using the PuTTY client:

In the PuTTY configuration window expand "Connection", then "SSH", and click on tunnels.
Hit the radio button for dynamic, fill in the port 1080, and click ADD.

Don't specify the host here - do it after clicking on the main Session Category.
If you save the parameters you won't have to do this again.

You may then access inner boss using the url:
```
http://myboss.${experiment_name}.${project_name}.isi.deterlab.net/
```

Fill in ```${experiment_name}``` and ```${project_name}``` with your experiment and project. For instance, the experiment ```test123``` in the ```example``` project would use this URL:

```
http://myboss.test123.example.isi.deterlab.net/
```

Once you are done, you may close the SSH tunnel connection. You may have to use Ctrl-C if it does not disconnect after you log out.