# Windows XP

Microsoft **Windows XP** is supported as one of the operating system types for experiment nodes in DETER.

As much as possible, we have left Windows XP "stock". Some Windows services are shut down: Messenger, SSDP Discovery Service, Universal Plug and Play Device Host, and Remote Registry. Other setting changes are described under <a href="#Network_config">Network config</a> and <a href="#Routing">Routing</a> below.

Before booting the node at swap-in time, DETER loads a <a href="#Experiment_setup">fresh image of Windows XP</a> onto the experiment nodes in parallel, using our `frisbee` service. DETER software automatically configures each Windows XP node, providing the expected experiment user environment including: user accounts and DETER SSH keys; remote home, project, and shared directories; and network connections.

The <a href="#Cygwin">Cygwin GNU</a> environment is provided, including Bash and TCSH shells, the C/C++, Perl and Python programming languages, and several editors including Emacs, vim, nano and ed. <a href="#Cygwin">Cygwin</a> handles both Unix and Windows-style command paths, as described <a href="#Cygwin_arcana">below</a>.

The DETERLab web interface manages a separate <a href="#Windows_Passwords">Windows password</a> in the user profile, as well as making <a href="#Login_connections">login connections</a> to the experiment nodes. Remote Desktop Protocol service supports Windows Desktop logins from the user's workstation screen to the experiment node. SSH and Serial Console command-line connections are also supported.

Windows XP installations are more hardware dependent than Linux or FreeBSD. At present, this Windows XP image runs on only <a href="/core/node-types/#pc3000">pc3000 class</a> machines.

## Differences from FreeBSD and Linux

The biggest difference of course, is that this is **Windows**, with Cygwin layered on top, and DETERLab management services added. In particular, this is Windows XP (NT 5.1), with various levels of service packs and updates (see <a href="#Experiment_setup">below</a>.)


### <a name="File_sharing"></a>File Sharing

The second-biggest difference is that shared directories are provided not by the NFS (Network File System) protocol, but instead by the **SMB** (Server Message Block) protocol, otherwise known as Windows File Sharing.

The "Client for Microsoft Networks" software contacts the SMB server, in this case **Samba** running on the file server known as **Fs** (an alias for **Users**.) The SMB protocol authenticates using a plain-text user name and password, encrypted as they go across the network. (These Windows Shares are then accessed by UNC paths under Cygwin mounts, [#SMB_mounts described below].)

In Windows GUI programs, you can just type the UNC path into the Address bar or a file-open dialog with **backslashes**, e.g. `\\fs\share` or `\\fs\<username>`. User and project shares are marked "not browsable", so just `\\fs` shows only `share`.

If you want to serve files from one of your experiment nodes to others, see the section on [#netbt_command  The netbt command ].

### <a id="Windows_Passwords"></a>Windows Passwords

A separate **Windows password** is kept for use only with experiment nodes running Windows. It is presented behind-the-scenes to `rdesktop` for RDP logins by our Web interface under Unix, and for the Samba mount of shared directories like your home directory under an SSH login, so you don't have to type it in those cases. You *will* have to type it each time if you use the <a href="#Login_connections">Microsoft RDC (Remote Desktop Connector) client program</a> from a Windows machine.

The default Windows password is randomly generated. It's easy to change it to something easier to remember.

To see or edit your Windows password, log in to DETERLab, and click **Manage User Profile** and then **Edit Profile** under **User Options**. You will see **Windows Password** fields in addition to the regular DETERLab **Password** fields.

When you change your Windows password, you will also have to re-type it as a check. The new Windows password should propagate to the Samba server on Fs instantly, so you can swap in an experiment and log in to its Windows nodes with the new password.

If you have already swapped-in experiment nodes and changed your Windows password, the account information including passwords will be updated at the next DETERLab watchdog daemon `isalive` interval. This should be in 3 to 6 minutes.

### <a id="Experiment_setup"></a>Experiment setup for Windows nodes

All you have to do is put a line specifying a WINXP OS image in your experiment NS file, like this:

```
    tb-set-node-os $node WINXP-UPDATE
```

The Windows XP images are not specific to a particular hardware type. (See the <a href="#Changes">Change Log</a> for more information.) You may explicitly specify the hardware type to run on if you wish, for example:

```
    tb-set-hardware $node pc3000
```

Since the bandwidth of the connection between the ISI and Berkeley portions of the testbed is constrained, it is best to run Windows nodes only on the ISI side of the testbed. This can be accomplished by creating a custom hardware type with

```
    tb-make-soft-vtype my_custom_node_type {pc3060 pc3000 pc2133 pc2133x}
```

and then specifying that your Windows nodes must only swap-in on this custom type using 

```
    tb-set-hardware $node my_custom_node_type
```

See the <a href="#tb-set-node-failure-action">note below</a> on using the <a href="/core/ns-commands/#tb-set-node-failure-action">tb-set-node-failure-action</a> command for experiments with a large number of Windows nodes. This can save a swap-in with a large number of Windows nodes, or prevent a single node boot failure on a swapmod from swapping-out the whole experiment.

If you use these commands: ```tb-set-node-startcmd```, ```tb-set-node-tarfiles```, or ```tb-set-node-rpms``` you should read the sections on <a href="#Cygwin_permissions">Permissions</a> and <a href="#Cygwin_GUI">Windows GUI programs</a> below.

The only available Windows image currently is:

* **WINXP-UPDATE** - The most recent Windows XP-SP3+. It is updated periodically from Windows Update, typically after a Microsoft "Patch Tuesday", the second Tuesday of each month. All critical and security fixes are installed, up through the date we pull the image file. (See the date created field on the individual WINXP <a href="https://www.isi.deterlab.net/showimageid_list.php3">Image IDs</a>).

!!! note
    The Windows Firewall is disabled by default (as it will inform you repeatedly!)

### <a id="Network_config"></a>Network config

Some default Windows networking features are disabled. *NetBT (!NetBios over TCP)* (<a href="http://www.microsoft.com/technet/prodtechnol/windowsserver2003/library/DepKit/40c09844-a669-463c-94dc-7ccf7214083d.mspx">NetbiosOptions=2 </a>) and *DNS auto-registration* (<a href="http://support.microsoft.com/default.aspx?scid=kb;EN-US;q246804">DisableDynamicUpdate=1</a>) are disabled to allow network <a href="/core/swapping/#idleness">idle detection</a> by the slothd service. *TCP/IP address autoconfiguration* is disabled (<a href="http://www.microsoft.com/resources/documentation/Windows/2000/server/reskit/en-us/Default.asp?url=/resources/documentation/Windows/2000/server/reskit/en-us/regentry/58861.asp">IPAutoconfigurationEnabled=0</a>) so that un-switched interfaces like the sixth NICs on the pc3000's don't get bogus Microsoft class B network 169.254.0.0 addresses assigned.

The Windows **`ipconfig /all`** command only shows the configuration information for the enabled network interfaces. There will always be one enabled control net interface on the `192.168.0.0/22` network. The others are disabled if not used in your experiment. (See file `/var/emulab/boot/ipconfig-cache` for a full listing from boot time, including the interfaces that were later disabled.)

If you specified links or LANs in your experiment network topology, other interfaces will be enabled, with an IP address, subnet mask, and gateway that you can specify in the NS file. Notice that the Windows names of the interfaces start with **`Local Area Connection`** and have a number appended. You can't count on what this number is, since it depends on the order the NIC's are probed as Windows boots.

!!! note
    Often, we have seen `ipconfig` report an IP address and mask of `0.0.0.0`, while the TCP/IP properties dialog boxes and the `netsh` command show the proper values. Our startup scripts disable and re-enable the network interface in an attempt to reset this. Sometimes it doesn't work, and another reboot is done in an attempt to get the network up.

### Routing

Full-blown router nodes cannot run Windows, i.e. **`rtproto Session`** is not supported. However, basic routing between connected network components of your experiment topology works. The Windows command to see the routing tables is **`route print`**. The <a href="http://www.microsoft.com/windows2000/en/advanced/help/default.asp?url=/windows2000/en/advanced/help/sag_TCPIP_pro_EnableForwarding.htm">IPEnableRouter=1</a> registry key is set on multi-homed hosts in the experiment network, before they are rebooted to change the hostname.

**`rtproto Static`** is supported in all recent WINXP images, but not in WINXP-02-16 (2005) or before.

**`rtproto Static-old`** or **`rtproto Manual`** will work in any image.

There is more information on routing in the <a href="/core/core-guide/#Routing">Routing section of the Core Guide</a>.

### Windows nodes boot twice

Notice that Windows reboots an extra time after being loaded onto a node during swap-in. It must reboot after changing the node name to set up the network stack properly. Be patient, Windows XP doesn't boot quickly.

With <a href="#Hardware_independent">hardware-independent</a>, (<a href="#Sysprep">sysprep'ed</a>) images, the first boot is actually running `Mini-Setup` as well, setting up device drivers and so on.

It's best not to log in to the nodes until the experiment is fully swapped-in. (You may be able to log in briefly between the first two reboots; if you see the wrong `pcXXX` name, you'll know that a reboot is imminent.) You can know that the swap-in process is finished by any of these methods:

* Waiting until you get the "experiment swapped in" email from DETERLab.
* Checking the node status on the experiment status page in DETERLab. (You must refresh the page to see node status change.)
* Watching the realtime swap-in log to monitor its progress.

!!! note
    Sometimes Windows XP fails to do the second reboot. One reason is transient race conditions in the Windows startup, for example in the network stack when there are multiple network interface devices being initialized at the same time. We make a strong effort to recover from this, but if the recovery code fails, by default it results in a swap-in or swapmod failure.

At boot time, the startup service on Windows XP runs the `/usr/local/etc/emulab/rc/rc.bootsetup` script, logging output to `/var/log/bootsetup.log`. If you're having swap-in problems and `rc.bootsetup` doesn't finish sending `ISUP` to DETERLab within 10 minutes, the node will be rebooted. After a couple of reboot cycles without a `ISUP`, DETERLab gives up on the node.

You can cause these boot-time problems to be nonfatal by adding this line to your <a href="/core/ns-commands/">ns file</a> *for each Windows node*:

```
 tb-set-node-failure-action $node "nonfatal"
```

(where ```$node``` is replaced with the node variable, of course.)

DETERLab will still complain if it doesn't get the ISUP signal at the end of rc.bootsetup, but the swap-in or swapmod will proceed and allow you to figure out what's happening. Then you will probably have to manually reboot the failed Windows node to make it available to your experiment.

If you try to login to a node after swap-in to diagnose the problem and your Windows password isn't honored, use this command on Ops to remotely reboot the node:

```
 node_reboot pcxxx
```

If you are able to log in but your remote home directory isn't mounted, this is another symptom of a partial set-up. You have the additional option of executing this command on the node itself:

```
 /sbin/reboot
```

This gives Windows another chance to get it right.

### Login connections to Windows

You can manually start up the SSH or RDP client programs to connect and log in to nodes in your experiment, or use the `console` command on Ops. You will have to type your <a href="#Windows_Passwords">Windows Password</a> when logging in, except for SSH when you have ssh-agent keys loaded.

Or you can set up your browser to automatically connect in one click from the DETERLab web interface and pop up a connection window. Once you start swapping in an experiment, the *Experiment Information* page contains a table of the physical node ID and logical node name, status, and connection buttons. The captions at the top of the button columns link to pages explaining how to set up up mime-types in your browser to make the buttons work, from FreeBSD, Linux, and Windows workstations:

* **SSH** <a href="/core/DETERSSH/">(setup)</a> - The **SSH** connection button gives a Bash or TCSH shell, as usual. Your DETERLab SSH keys are installed on the node in a ```/sshkeys``` subdirectory.
* **Console** - The <a href="/core/serial-console/">serial console</a> is supported for Cygwin shell logins using the `agetty` and `sysvinit` packages. This is the only way in when network connections are closed down! You can also monitor the Frisbee loading and booting of the Windows image on the console.
* **RDP** - The **RDP** button starts up a Remote Desktop Protocol connection, giving a Windows Desktop login from the user's workstation screen to the experiment node.
* The **`rdesktop`** client software is used from Linux and Unix client workstations.
* A Microsoft **RDC** (Remote Desktop Connector) client program is included in Windows XP, and may be installed onto other versions of Windows as well. It has the feature that you can make it full-screen without (too much) confusion, since it hangs a little tab at the top of the screen to switch back. Unfortunately, we have no way to present your DETERLab Windows password to RDC, so you'll have to type it on each login.

!!! note
    If you import dot-files into DETERLab that replace the system execution search path rather than add to it, you will have a problem running Windows system commands in shells. Fix this by adding **`/cygdrive/c/WINDOWS/system32`** and **`/cygdrive/c/WINDOWS`** to your `$PATH` in `~/.cshrc` and either `~/.bash_profile` or `~/.profile`. Don't worry about your home directory dot-files being shared among Windows, FreeBSD, and Linux nodes; non-existent directories in the `$PATH` are ignored by shells.

When new DETERLab user accounts are created, the default CSH and Bash dotfiles are copied from the FreeBSD ```/usr/share/skel```. They replace the whole $PATH rather than add to it. Then we append a DETERLab-specific part that takes care of the path, conditionally adding the Windows directories on Cygwin.

!!! note
    The Windows **`ping`** program has completely different option arguments from the Linux and FreeBSD ones, and they differ widely from each other. There is a ping package in Cygwin that is a port of the 4.3bsd ping. Its options are close to a common subset of the Linux and FreeBSD options, so it will be included in future WINXP images:

```
 ping [ -dfqrv ] host [ packetsize [count [ preload]]]
```

You can load it yourself now using <a href="#Cygwin_packages">Cygwin Setup</a>.

!!! note
    There are no Cygwin ports of some other useful networking commands, such as **`traceroute`** and **`ifconfig -a`**. The Windows system equivalents are `tracert` and `ipconfig /all`.

### RDP details

Here are some fine points and hints for RDP logins to remote Windows desktops:

*   Microsoft allows only **one desktop login at a time** to *Windows XP*, although this is the same Citrix Hydra technology that supports many concurrent logins to Terminal Server or Server 2003. 

    The **Fast User Switching** option to XP is turned on, so a second RDP connection disconnects a previous one rather than killing it. Similarly, just closing your RDP client window disconnects your Windows Login session rather than killing it. You can reconnect later on without losing anything. SSH doesn't count as a desktop, so you can SSH in and use this command: **`qwinsta`** (Query WINdows STAtion) to show existing winstation sessions and their session ID's, and this one to reset (kill) a session by ID: **`rwinsta`**.


*   We rename **My Computer** to show the PCxxx physical node name, but it doesn't appear on the *Windows XP* desktop by default. The XP user interface incorporates "My Computer" into the upper-right quadrant of the "Start" menu by default, and removes it from the desktop. 

    You can go back to the "classic" user interface of Windows 2000, including showing "My Computer". Right-click on the background of the Taskbar which contains the "Start" button at the left, and choose "Properties". Select the "Start Menu" tab, click the "Classic Start menu" radio-button, and click "OK".
    
    Alternatively, you can force "My Computer" to appear on your XP desktop by right-clicking on the desktop background and choosing "Properties". Select the "Desktop" tab and click "Customize Desktop..." to get the "Desktop Items" dialog. Turn on the "My Computer" checkbox, then click "OK" twice.

*   There are several **Desktop icons** (i.e. "shortcuts") installed by default in the XP images: Computer Management, Bash and TCSH shells, and *NtEmacs*. You will notice two flavors of Bash and TCSH icons on the desktop, labeled `rxvt` and `Cygwin`.

*   The **`rxvt` shells** run in windows with **X**-like cut-and-paste mouse clicks:

    * **Left-click** starts a selection,
    * **Right-click** extends it, and
    * **middle-click** pastes.  These are the ones to use if you're connecting from an X workstation.

!!! note
    The default colors used in Bash and rxvt don't work well in 4-bit color mode under RDP. Make sure you update your rdp-mime.pl to get the rdesktop **`-a 16`** argument for 16-bit color. Or, you can over-ride the rxvt defaults by putting lines in your `~/.Xdefaults` file like this: 

        rxvt*background: steelblue

*   The **`Cygwin` shells** run in a Windows Terminal window, just as the Windows cmd.exe does. These are the ones to use if you're connecting from a Windows workstation.
    
    **Quick-edit mode** is on by default, so you can cut-and-paste freely between your local workstation desktop and your remote RDP desktops. In a Windows Terminal window on your RDP remote desktop, the quick-edit cut-and-paste mouse clicks are:

    * **Left-drag** the mouse to *mark* a rectangle of text, highlighting it.
    * **Type *Enter* or *right-click* the mouse when text is highlighted**, to *copy* the selected text to the clipboard. (***Escape*** *cancels* the selection without copying it.)
    * **Right-click the mouse with nothing selected** to *paste* the contents of the clipboard.

*   On the **first login by a user**, Windows creates the user's *Windows profile directory* under `C:\Documents and Settings`, and creates the *registry key* (folder) for persistent settings for that user.

    We arrange that early in the user's login process, a user **HOME** environment variable value is set in the user's registry. Otherwise Emacs wouldn't know how to find your *.emacs* setup file in your remotely mounted home directory.

	User "root" is special, and has a local home directory under `/home`. `/home` is a Cygwin symbolic link to `C:\Documents and Settings`.

*   The *Windows XP* Start menu has no **Shutdown** button under RDP. Instead, it is labeled **Disconnect** and only closes the RDP client window, leaving the login session and the node running. If you simply close the window, or the RDP client network connection is lost, you are also disconnected rather than logged out. When you reconnect, it comes right back, just as it was.

    To restart the computer, run **/sbin/reboot**, or use the "Shut Down" menu of **Task Manager**. One way to start Task Manager is to right-click on the background of the Taskbar at the bottom of the screen and select "Task Manager".

### The `netbt` command ###

The **NetBT** (Netbios over TCP) protocol is used to announce shared directories (folders) from one Windows machine to others. (See the Name and Session services in <http://en.wikipedia.org/wiki/Netbios>.)

The **SMB** (Server Message Block) protocol is used to actually serve files. (See <http://en.wikipedia.org/wiki/Server_Message_Block>.)

In DETERLab, we normally disable NetBT on experiment nodes, because it chatters and messes up slothd network idle detection, and is not needed for the usual SMB mounts of `/users`, `/proj`, and `/share` dirs, which are served from a Samba service on **fs**.

However, NetBT *does* have to be enabled on the experiment nodes if you want to make Windows file shares between them. The **`netbt`** script sets the registry keys on the Windows network interface objects. Run it on the server nodes (the ones containing directories which you want to share) and reboot them afterwards to activate. There is an optional `-r` argument to reboot the node.

```
    Usage: netbt [-r] off|on
```

If you use `netbt` to turn on NetBT, it persists across reboots.

No reboot is necessary if you use Network Connections in the Control Panel to turn on NetBT. It takes effect immediately, but is turned off at reboot unless you do `netbt on` afterward as well.

* Right-click Local Area Connection (or the name of another connection, if appropriate), click Properties, click Internet Protocol (TCP/IP), and then click the Properties button.
* On the Internet Protocol (TCP/IP) Properties page, click the Advanced button, and click the WINS tab.
* Select Enable or Disable NetBIOS over TCP/IP.

`ipconfig /all` reports "NetBIOS over Tcpip . . . : Disabled" on interfaces where NetBT is disabled, and says nothing where NetBT is enabled.

To start sharing a directory, on the node, use the `net share` command, or turn on network sharing on the Sharing tab of the Properties of a directory (folder.)

* On XP-SP2 or above, when you first do this, the "Network sharing and security" subdialog says:

        As a security measure, Windows has disabled remote access to this
        computer.  However, you can enable remote access and safely share files by
        running the _Network_Setup_Wizard_.
        _If_you_understand_the_security_risks_but_want_to_share_
        _files_without_running_the_wizard,_click_here._"

* Skip the wizard and click the latter ("I understand") link. Then click "Just enable file sharing", and "OK".
* Then you finally get the click-box to "Share this folder on the network".

The machine names for UNC paths sharing are the same as in shell prompts: `pcXXX`, where `XXX` is the machine number. These will show up in `My Network Places / Entire Network / Microsoft Windows Network / DETER` once you have used them.

IP numbers can also be used in UNC paths, giving you a way to share files across experiment network links rather than the control network.

There is an DETER-generated **`LMHOSTS`** file, to provide the usual node aliases within an experiment, but it is currently ignored even though "Enable LMHOSTS lookup" is turned on in the TCP/IP WINS settings. Try `nbtstat -c` and `nbtstat -R` to experiment with this. (See the <a href="http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/nbtstat.mspx?mfr=true">Microsoft doc for nbtstat</a>.

### Making Custom Windows OS Images

Making custom Windows images is similar to <a href="/core/custom-images/">doing it on the other DETER operating systems</a>, except that you must do a little more work to run the `prepare` script as user `root` since there are no `su` or `sudo` commands on Windows. This is optional on the other OS types, but on Windows, proper TCP/IP network setup depends on `prepare` being run.

*   Log in to the node where you want to save a custom image. Give the shell command to change the root password. Pick a password string you can remember, typing it twice as prompted:

        % passwd root
        Enter the new password (minimum of 5, maximum of 8 characters).
        Please use a combination of upper and lower case letters and numbers.
        New password:
        Re-enter new password:

    This works because you are part of the Windows <a href="#Cygwin_Administrators">Administrators group</a>. Otherwise you would have to already know the root password to change it.

    !!! note
        If you change the root password and reboot Windows __before running `prepare`__ below, the root password will not match the definitions of the DETER Windows services (daemons) that run as root, so they will not start up. 

* Log out all sessions by users other than `root`, because `prepare` will be unable to remove their login profile directories if they are logged in. (See <a href="#QWINSTA">QWINSTA</a>.)
* Log in to the node as user `root` through the Console or SSH, using the password you set above, then run the `prepare` command. (It will print "Must be root to run this script!" and do nothing if not run as root.)

        /usr/local/etc/emulab/prepare

    If run without option arguments, `prepare` will ask for the root password you want to use in your new image, prompting twice as the passwd command did above. It needs this to redefine the DETER Windows services (daemons) that run as root. It doesn't need to be the same as the root password you logged in with, since it sets the root password to be sure. The Administrator password is changed as well, since the Sysprep option needs that (below.)

* You can give the **`-p`** option to specify the root password on the command line:

        /usr/local/etc/emulab/prepare -p myRootPwd

* The **`-n`** option says not to change the passwords at all, and the DETER Windows services are not redefined.

        /usr/local/etc/emulab/prepare -n

* The **`-s`** option is used to make <a href="#Hardware_independent">hardware-independent</a> images using the Windows **`Sysprep`** deploy tool. If you use it with the `-n` option instead of giving a password, it assumes that you separately blank the Administrator password, or edit your Administrator password into the `[GuiUnattended]AdminPassword` entry of the sysprep.inf file.

        /usr/local/etc/emulab/prepare -s -p myRootPwd
    
    !!! note
        This must be done from a login on the **serial console**, because Sysprep shuts down the network. `prepare -s` refuses to run from an SSH or RDP login. 

    !!! note
        Currently, hardware-independent images must be made on a pc850, and will then run on the pc600, pc3000, and pc3000w as well. There is an unresolved boot-time problem going the other direction, from the pc3000 to a pc850 or pc600. 

        Windows normally casts some aspects of the NT image into concrete at the first boot after installation, including the specific boot disk driver to be used by the NT loader (IDE, SCSI, or SATA.) `Sysprep` is used by PC hardware manufacturers as they make XP installation disks with their own drivers installed. The `Sysprep` option to run an unattended `Mini-Setup` at first boot instead of the normal "Out Of the Box Experience" is used in some large corporate roll-outs. We do both.

    The DETER ` /share/windows/sysprep ` directory contains several versions of the XP deploy tools matched to the XP service pack level, appropriate device driver directories, and a draft `sysprep.inf` file to direct the automated install process.

    `Mini-setup` needs to reboot after setting up device drivers. XP also needs to [#Boots_twice reboot] after changing the host name. We combine the two by using a <a href="http://support.microsoft.com/?kbid=238955">`Cmdlines.txt` script</a> to run `rc.firstboot -mini` to set the host name at the end of `Mini-Setup`.

    Thus we only pay the extra time to set up device drivers and so on from scratch, about two minutes, rather than adding a third hardware and XP reboot cycle.

    !!! note
        As you create your Image Descriptor, set the **reboot wait-time** to **360** rather than 240 so that swap-ins don't time out.
* Then log out and <a href="/core/custom-os/">create your custom image</a>.

    !!! note
        Windows XP is too big to fit in the partitioning scheme used by FreeBSD and Linux, so it's necessary when making a Windows custom image to specify **Partition 1**, and click **Whole Disk Image.**

* When you're testing your custom image, it's a good idea to set the <a href="/core/ns-commands/#tb-set-node-failure-action">tb-set-node-failure-action</a> to "nonfatal" in the ns file so you get a chance to examine an image that hasn't completed the set-up process. See the <a href="#tb-set-node-failure-action">note below</a> for other useful ideas.

## Cygwin

Cygwin is <a href="http://www.cygwin.com/">GNU + Cygnus + Windows</a>, providing Linux-like functionality at the API, command-line, and package installation levels.

### Cygwin documentation

Cygwin is well documented. Here are some links to get you started:

  * <a href="http://cygwin.com/cygwin-ug-net/cygwin-ug-net.html">Users guide</a>
  * <a href="http://cygwin.com/cygwin-ug-net/highlights.html">Cygwin highlights</a>
  * <a href="http://cygwin.com/cygwin-ug-net/using-utils.html">Cygwin-added utilities</a>
  * <a href="http://cygwin.com/faq.html">FAQ</a>
  * <a href="http://cygwin.com/cygwin-api/cygwin-api.html">API compatibility and Cygwin functions</a>

### Cygwin packages

A number of optional Cygwin packages are installed in the image due to our building and running the DETER client software, plus some editors for convenience. These packages are currently agetty, bison, cvs, cygrunsrv, ed, file, flex, gcc, gdb, inetutils, make, minires-devel, more, nano, openssh, openssl-devel, patch, perl, perl-libwin32, psmisc, python, rpm, rsync, shutdown, sysvinit, tcsh, vim, wget, and zip.

The Cygwin command **`cygcheck -c`** lists the packages that are installed, and their current version number and status. Package-specific notes and/or documentation for installed packages are in `/usr{,/share}/doc/Cygwin/*.README` and `/usr/share/doc/*/README` files. The <a href="http://www.cygwin.com/packages/">Cygwin package site</a> lists the available pre-compiled packages and provides a search engine.

If you want to install more Cygwin pre-compiled packages, run the graphical installer:

    C:/Software/Cygwin/setup.exe

The Cygwin command **`cygcheck -l package-name`** lists the contents of an installed package, which may help you to make a tarfile or rpm from a package you have installed. You can then cause it to be installed automatically by DETER into all of the nodes of your experiment. See the [Tutorial#TARBALLS Tutorial] for more information about installing <a href="/core/core-guide/#installing-rpms-automatically">RPM's</a> and <a href="/core/core-guide/#installing-tar-files-automatically">tarballs</a>.

Watch out for post-install scripts in:

```
    /etc/postinstall/package-name.sh{,.done}
```

Many packages not in the Cygwin package site have also been ported to Cygwin already. Download the sources to an experiment node and try

```

    ./configure
    make
    make install

```

as usual.

### SMB mounts and Samba

User home directories and other shared directories are served by **fs**, another alias for Ops/Users, via the SMB protocol (Server Message Block, also known as Windows File Sharing) with the Windows Client connecting to the Samba server.

UNC paths with leading double-slashes and a server name, e.g. **`//fs`**, are used to access the SMB Shares under Cygwin. DETER then uses the <a href="#Cygwin_mounts">Cygwin mount command</a> to make them appear on the usual Unix paths for the DETER shared directories: `/users/<username>`, `/proj/<pid>`, `/group/<pid>/<gid>`, and `/share`.

The Cygwin **`mount`** command lists what you could access on the Samba server, with the UNC path in the first column. Unix file permissions may further limit your access on the Samba server. Log in to Ops to investigate.

**`/share/windows`** contains Windows software. See `/share/windows/README.bin` for descriptions of binary packages available for installation.

In Windows GUI programs, you can just type the UNC path into the Address bar or a file-open dialog with **backslashes**, e.g. `\\fs\share` or `\\fs\<username>`. User and project shares are marked "not browsable", so just `\\fs` shows only `share`.

*Windows limitation:* There is only **one protection mask** for everything in a whole mount/share under SMB. It's set in the "share properties" on the server (Samba config file in this case) so **`chmod`** will do you no good across SMB.

*Cygwin limitation:* There is a hard-coded **limit of 30 mount points** in Cygwin. Cygwin uses 4 of them, and DETER uses another 3 or 4. So some of your `/users` mounts will fail on Windows startup if you have more than 23 or 24 members in your project, unless they are grouped into smaller subgroups.

### Cygwin arcana

* **File paths**

    Cygwin accepts either flavor of slashes in paths, Unix/POSIX-style forward-slashes, or Windows-style back-slashes. In Unix shell commands, backslashes need to be quoted.

    Single-quotes work best. Doubling each backslash also works. This must also be done inside double-quotes. Examples: `'\single\quoted'`, `"\\double\\quoted"`, `\\un\\quoted`. (The difference between double and single quotes is that $variable references and back-quoted command execution are expanded in double-quotes.)

    When you invoke Windows (as opposed to Cygwin) commands, for example **`net use`**, they will know nothing about Unix-style paths in their arguments. The **<a href="http://cygwin.com/cygwin-ug-net/using-utils.html#cygpath">cygpath</a>** utility is an aid to converting paths between the Unix and Windows conventions.

    `cygpath -w` converts its arguments to Windows format, and `cygpath -u` converts its arguments to Unix format, e.g.

        $ cygpath -w /cygdrive/c/WINDOWS
        c:\WINDOWS
        $ cygpath -u 'c:\WINDOWS'
        /cygdrive/c/WINDOWS

* **Mount points**

    <a href="http://cygwin.com/cygwin-ug-net/using-utils.html#mount">Cygwin mount points</a> are shown by the **`mount`** and **`df`** commands.

    Note that there is a hard-coded limit of 30 mount points in Cygwin. Attempts to use the Cygwin `mount` command after that will fail.

    See the discussion of mount points and UNC `//machine` paths to SMB shares <a href="#SMB_mounts">above</a>.

    Another special case is the **Unix root**, "`/`". It's mounted to `C:\cygwin` in the Windows filesystem.

* **Drive letter mounts**

    Cygwin knows about drive letter prefixes like **`C:`**Â , which are equivalent to `/cygdrive/<drive-letter>`Â . However, `/cygdrive`, like `/dev`, isn't a real directory, so you can't `ls` it.

    Some Windows software requires drive-letter mounts to be created for its use.

    You can use the Windows **`net use`** command to associate drive letters with UNC paths to SMB shares, e.g.

        net use W: '\\fs\share\windows'

    You can use the Windows **`subst`** command to associate drive letters with local paths, e.g.

        subst T: 'C:\Temp'

    Filename completion in Cygwin shells with `<Tab>` doesn't work following a drive-letter prefix, but it works normally after a `/cygdrive/` prefix. Also, filename completion is case-sensitive, although the underlying Windows is case-insensitive, so a filename in the wrong case is still opened properly.

* **NTSEC**

    Cygwin is running in **<a href="http://cygwin.com/cygwin-ug-net/ntsec.html">NTSEC</a>** (NT Security) mode, so `/etc/passwd` and `/etc/group` contain Windows SID's as user and group ID's. Your Windows UID is the computer SID with a user number appended, something like `S-1-5-21-2000478354-436374069-1060284298-1334`.

    Cygwin commands, such as `id`, `ls -ln`, and `chown/chgrp`, use the numeric suffix as the uid, e.g. `1334`. This is different from your normal DETER Unix user ID number, and the Samba server takes care of the difference.
    
    The **`id`** command reports your user id and group memberships.

    Note that all users are in group **`None`** on XP. Contrary to the name, this is a group that contains **all users**. It was named `Everybody` on Windows 2000, which was a better name.

* **setuid**

    There is no direct equivalent of the Unix **setuid** programs under Windows, and hence no `su` or `sudo` commands.
    
    The Windows equivalent to running a Unix command as `root` is membership in the Windows **`Administrators`** group. DETER project members who have either `local_root` or `group_root` privileges are put in group **`wheel`**, another alias for `Administrators`. Project members with `user` privileges are not members of the wheel group.

    You can `ssh` a command to the node as the target user, as long as you arrange for the proper authentication.

    For C/C++ code, there is a `setuid()` function in the Cygwin library, which "impersonates" the user if proper setup is done first.

* **`root`**

    There is not normally a Windows account named **`root`**. `root` on XP is just another user who is a member of the `Administrators` group, see below.

    We create a `root` account as part of the DETER setup to own installed software, and to run services and Unix scripts that check that they're running with root privileges.

    You can log in as `root` via RDP, `ssh`, or the serial console if you change the root password as described in the <a href="#Custom_images">custom Windows OS images</a> section.

    The `root` user does not have any Samba privileges to access Samba shared mounts, including the `/proj`, `/groups`, and `/users`.

* **`Administrators` group**

    All users are members of the Windows `Administrators` group. (The DETER non-local-root user property is not implemented on Windows.)

    Membership in the Windows `Administrators` group is very different from being` root` on Unix, and is also different from being logged in as Administrator.

    `Administrators` group membership on Windows only means you can set the ownership, group, and permissions on any file using the Cygwin `chown`, `chgrp`, `chmod`, or their Windows equivalents. Until you have done that, you can be completely locked out by read, write, or execute/open permissions of the directory or files.

    Another subtlety is that the group called `None` on XP is what used to be named `Everybody` on Windows 2000. All users are automatically in group `None`, so in practice setting group `None` permissions is no different from setting public access permissions.

* **Permissions**

    Cygwin does a pretty good job of mapping Unix user-group-other file permissions to Windows NT security ACLs.

    On Windows, unlike Unix, file and directory permissions can lock out root, Administrator, or SYSTEM user access. Many Unix scripts don't bother with permissions if they're running as root, and hence need modification to run on Cygwin.

    This creates a potential problem with the tb-set-node-tarfiles and tb-set-node-rpms commands. The tb-set-node-tarfiles page says "Notes: 1. ... the files are installed as root". So you can easily install files that *your* login doesn't have permission to access.

    The solution is to `chmod` the files before making the tarball or rpm file to grant appropriate access permissions.

* **Executables**

    Cygwin tries to treat `.exe` files the same as executable files without the `.exe` suffix, but with execute permissions turned on. (See the <a href="http://cygwin.com/cygwin-ug-net/using-specialnames.html#id4729857">Cygwin Users Guide</a>.)

    This breaks down in Makefile actions and scripts, where `rm`, `ls -l`, and `install` commands may need an explicit `.exe` added.

* **Windows GUI programs**

    You cannot run Windows GUI (Graphical User Interface) programs under ssh, on the serial console, or by tb-set-node-startcmd. There is no user login graphics context until you log in via RDP.

    However, you *can* use a `startcmd` to set a Windows registry key that causes a GUI program to be run automatically for all users __when they log in to the node via RDP__, if that's what you want. The program can be one that is installed by tb-set-node-tarfiles.

    You can pick any regkey name you want and put it in the `Run` registry folder. It's good not to step on the ones already there, so choose a name specific to your program. Put the following in your `startcmd` script:

        regtool -s set /HKLM/SOFTWARE/Microsoft/Windows/CurrentVersion/Run/mypgm 'C:\mypgm\mypgm.exe'

    (where `mypgm` is the name of your program, of course.)

    Notice that the value string is single-quoted with `C:` and backslashes. Windows interprets this regkey, and wants its flavor of file path.

## NtEmacs

We don't include the Cygwin X server in our XP images to keep the bulk and complexity down. So <a href="http://www.gnu.org/software/emacs/windows/ntemacs.html">NtEmacs 21.3</a> is provided instead of the Cygwin **X** Emacs. *NtEmacs* "frames" are windows on the Windows Desktop, e.g. `^X-5-2` makes another one.

The `/usr/local/bin/emacs` executable is a symlink to `/cygdrive/c/emacs-21.3/bin/runemacs.exe`, which starts up an Emacs on the desktop. This only works under RDP, since SSH logins have a null desktop.

There is also a `/usr/local/bin/emacs-exe` executable, a symlink to `/cygdrive/c/emacs-21.3/bin/emacs.exe`, which is only useful as an Emacs compiler. It could be used to run Emacs in an SSH or Serial Console login window with the `-nw` (no windows) flag, except that it exits with `emacs: standard input is not a tty`. Another thing not to try is running `emacs-exe -nw` in a Bash or TCSH shell on the RDP desktop. It crashed *Windows XP* when I tried it.

* Can drag-and-drop files from *Windows Explorer* to *!NtEmacs* windows.
* `cygwin-mount.el` in `c:/emacs-21.3/site-lisp/` makes Cygwin mounts visible within *!NtEmacs*. It doesn't do Cygwin symlinks yet.
* Options - See `~root/.emacs`
  * `mouse-wheel-mode`
  * `CUA-mode` option ( `^C` copy / `^X` cut on selection, `^V` paste, `^Z` undo).
  * `Ctrl` and `Alt` key mappings, etc.