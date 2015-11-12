[[TOC]]

We have two OS images with support for [The Click Modular Router](http://read.cs.ucla.edu/click): Ubuntu804-click and Ubuntu1004-click20.

We support click 1.8 (in Ubuntu804-click) and click 2.0 (in Ubuntu1004-click20).

## Ubuntu804-click

Ubuntu804-click is based on Ubuntu804-STD with the following modifications
* loads as a full disk image with about 15 GB free on /
* kernel 2.6.24.7-click
   * vanilla 2.6.24.7 with click patch
   * [attachment:linux-2.6.24.7-click.config kernel config]
* click 1.8.0 installed in /usr/local
* click and kernel source in /usr/src

## Ubuntu1004-click20

Ubuntu1004-click20 is based on Ubuntu1004-STD with the following modifications
* loads as a full disk image with about 12 GB free on /
* stock Ubuntu kernel
* click 2.0 installed in /usr/local
* click source in /usr/src

## Ubuntu1204-64-Click

Ubuntu1204-64-Click is click on Ubuntu 12.

# Using click

click is installed in `/usr/local`. If you do not require custom modules, the images should be usable out of the box.

## Running the example

For a simple example, download [attachment:test.click test.click] and copy it to your home directory on users.

On a node running Ubuntu804-click or Ubuntu1004-click20, run the following command:

	
	sudo click-install test.click
	

This will install the example configuration into click running in the kernel. If it succeeds, you should see output similar to the following by running `dmesg` or reading `/var/log/kern.log`:

	
	[66530.612983] chatter: ok:   40 | 45000028 00000000 401177c3 01000001 02000002 13691369
	[66530.620905] chatter: ok:   40 | 45000028 00000000 401177c3 01000001 02000002 13691369
	[66530.628821] chatter: ok:   40 | 45000028 00000000 401177c3 01000001 02000002 13691369
	[66530.636725] chatter: ok:   40 | 45000028 00000000 401177c3 01000001 02000002 13691369
	[66530.644618] chatter: ok:   40 | 45000028 00000000 401177c3 01000001 02000002 13691369
	

# Building custom modules

The source for click is in `/usr/src/click-1.8.0` or `/usr/src/click-2.0`.

Custom modules are typically built in the local elements folder. Copy your source files into `/usr/src/click-1.8.0/elements/local` or `/usr/src/click-2.0/elements/local` and give configure the `--enable-local` flag.

## Ubuntu804-click
In click 1.8, you must give configure the path to the kernel source.
	
	$ sudo -s
	# cd /usr/src/click-1.8.0
	# ./configure --with-linux=/usr/src/linux-2.6.24.7 --enable-local
	

## Ubuntu1004-click20
	
	$ sudo -s
	# cd /usr/src/click-2.0
	# ./configure --enable-local
	

## Building and installing
At this point building and installing is as simple as:

	
	# make && make install
	

# Further Reading

* [Click Module Router](http://read.cs.ucla.edu/click)
* [click examples](http://read.cs.ucla.edu/click/examples)
* [UbuntuImage general Ubuntu image info]