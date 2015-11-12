# FreeBSD on DETER


# Officially Supported Images 

* [FBSD8-STD](https://www.isi.deterlab.net/showosinfo.php?osid=1013) FreeBSD 8.x standard
* [FBSD9-64-STD](https://www.isi.deterlab.net/showosinfo.php?osid=1803) FreeBSD 9.x standard
* [FBSD10-STD](https://www.isi.deterlab.net/showosinfo.php?osid=1936) FreeBSD 10.x standard

# Working with FreeBSD

## First things first

FreeBSD comes with excellent documentation.  This includes complete manual pages that document everything from syscalls to command line utilities and a handbook that covers basic system administration tasks.

* [Web Interface for the FreeBSD man pages](http://www.freebsd.org/cgi/man.cgi)
* [The FreeBSD Handbook](http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/)
* [All FreeBSD documentation resources](http://www.freebsd.org/docs.html)

## Binary Packages

Binary packages for FreeBSD are mirrored on scratch.  In order to install binary packages from scratch,  the environment variable *PACKAGEROOT* is set.  To check that this is set, simple echo the variable:

	
	node0 ~]$ echo $PACKAGEROOT
	http://scratch
	[jjh@node0 ~]$ 
	

You can now use the [pkg_add](http://www.freebsd.org/cgi/man.cgi?query=pkg_add&sektion=1) command to install packages.  Using the '-r' option instructs [pkg_add](http://www.freebsd.org/cgi/man.cgi?query=pkg_add&sektion=1) to fetch the package from the remote host defined by the PACKAGEROOT variable.  This command needs to be run as root, so we use the sudo command.

	
	[jjh@node0 ~]$ sudo pkg_add -r tmux
	Fetching http://scratch/pub/FreeBSD/ports/i386/packages-7.3-release/Latest/tmux.tbz... Done.
	[jjh@node0 ~]$ 
	

To view the list of available packages, you can go to:
* [Packages available for FreeBSD 7.3](http://ftp.freebsd.org/pub/FreeBSD/ports/i386/packages-7.3-release/Latest)
* [Packages available for FreeBSD 8.2](http://ftp.freebsd.org/pub/FreeBSD/ports/i386/packages-8.2-release/Latest)

To learn more about managing packages on FreeBSD, please refer to [Section 4.4 of the FreeBSD Handbook](http://www.freebsd.org/doc/handbook/packages-using.html)
 
## Source for FreeBSD

For now, the source can be found in */share/freebsd*