# The Web Interface

This is in reference to the web interface.  Go to https://www.yousite and login.

# Logging in

The testbed setup process creates a default user called *elabman_' with the same password as '''deterbiuld''' on boss (unless you have set a '_root* password on boss which will take precedence for historical reasons) at the time of install (the password hash is copied and stored in the database).

# Creating the First Project

When you login as *elabman* you will automatically be presented with a "Create First Project" form.  At the top of the page after "Contact US" you should see a green dot.  Click this dot to enter into administrative mode.  It should now be red and an administration menu item will appear.

You can now fill out the form to create the first project and user.  The project will be automatically approved and created upon submission.  You should now log out and login as the user you created for the first project.  Do *not* continue to use the elabman user.

# Setup Mailing Lists on users

A lot of errors are only set out as email.  It is important to properly setup the email lists on users:

	
	root@users:/etc/mail/lists # ls -lart
	total 28
	-rw-r--r--  1 root  mailnull    0 Jan 11 18:38 testbed-www
	-rw-r--r--  1 root  mailnull    0 Jan 11 18:38 testbed-testsuite
	-rw-r--r--  1 root  mailnull    0 Jan 11 18:38 testbed-stated
	-rw-r--r--  1 root  mailnull    0 Jan 11 18:38 testbed-ops
	-rw-r--r--  1 root  mailnull    0 Jan 11 18:38 testbed-logs
	-rw-r--r--  1 root  mailnull    0 Jan 11 18:38 testbed-audit
	-rw-r--r--  1 root  mailnull    0 Jan 11 18:38 testbed-approval
	drwxr-xr-x  3 root  wheel     512 Jan 11 18:38 ..
	-rw-r-----  1 root  mailnull   90 Jan 11 21:27 emulab-widearea-users
	-rw-r-----  1 root  mailnull  233 Jan 14 15:09 emulab-allusers
	-rw-r-----  1 root  mailnull  149 Jan 14 15:09 emulab-project-leaders
	-rw-r-----  1 root  mailnull  155 Jan 14 15:09 emulab-ops-users
	-rw-r-----  1 root  mailnull   81 Jan 14 15:09 testbed-users
	drwxr-x---  2 root  mailnull  512 Jan 14 15:09 .
	root@users:/etc/mail/lists # echo 'user@bounce' >> testbed-www
	root@users:/etc/mail/lists # echo 'user@bounce' >> testbed-ops
	root@users:/etc/mail/lists # echo 'user@bounce' >> testbed-logs
	root@users:/etc/mail/lists # echo 'user@bounce' >> testbed-audit
	root@users:/etc/mail/lists # echo 'user@bounce' >> testbed-approval
	

# Enabling full administrative access

By default, the first testbed user does not have access to boss.  The script *tbadmin* will give this user (or any other), full administrative access to the testbed.  For example, if jhickey is the user I created as the head of the first testbed project, I can enable full access by simply running:

	
	[deterbuild@boss ~/testbed/account]$ sudo /usr/testbed/sbin/tbadmin jhickey
	Giving jhickey Red Dot on the web interface
	Setting local password and shell
	chpass: user information updated
	Adding /usr/testbed/sbin to shell rc files
	Adding user jhickey to group wheel in the database
	User jhickey is already in group wheel, skipping ...
	Updating groups for jhickey on control nodes
	Processing user jhickey: emulab-ops testbed
	Adding extra groups to list: tbadmin wheel
	Updating user jhickey record on local node.
	Updating user jhickey record on users.mini-isi.deterlab.net.
	Group Update Completed!
	[deterbuild@boss ~/testbed/account]$
	