# The standard image format

Images are stored in a custom Emulab format called imagezip.  The extension is '.ndz'.  This represents the raw data that will be loaded on the testbed node disks.  It does not contain any of the necessary metadata about partitions, what sort of OS the image contains, etc.  We have a XML file that contains this called the image descriptor file. 


# Downloading the Standard Operating System images

By default, we *now* ship a collection of OS images with the Boss VMware image.  If you want to make sure you have the most recent images, you can download them again from
the web. Standard Testbed images are located at [http://www.deterlab.net/~jjh/Deter%20OS%20Images/].
The standard location for testbed-wide images is on boss in /usr/testbed/images.

There is a simple script called "fetch_images" located in the install directory of the testbed source to automate downloading these images.
	
	[jjh@boss ~/testbed/install]$ ./fetch_images 
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100  2045  100  2045    0     0   162k      0 --:--:-- --:--:-- --:--:--  665k
	Fetching CentOS5.ndz
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100  604M  100  604M    0     0  65.2M      0  0:00:09  0:00:09 --:--:-- 74.2M
	Fetching FBSD8-STD.ndz
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100  443M  100  443M    0     0  74.2M      0  0:00:05  0:00:05 --:--:-- 75.2M
	Fetching FBSD62-STD.ndz
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100  295M  100  295M    0     0  67.5M      0  0:00:04  0:00:04 --:--:-- 67.6M
	Fetching Ubuntu1004-STD.ndz
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100  849M  100  849M    0     0  72.9M      0  0:00:11  0:00:11 --:--:-- 73.5M
	[jjh@boss ~/testbed/install]$ cd /usr/testbed/images/
	[jjh@boss /usr/testbed/images]$ ls
	CentOS5.ndz		FBSD62-STD.ndz		FBSD8-STD.ndz		Ubuntu1004-STD.ndz
	[jjh@boss /usr/testbed/images]$ 
	

# Loading the image descriptors

There is a perl script to load the appropriate image descriptors in ~<builduser>/obj/install:

	
	[jjh@boss ~/obj/install]$ perl load-descriptors ~/testbed/install/descriptors.sql
	