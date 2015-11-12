[[TOC]]
[wiki:CoreReference < Back to Core Reference]

# What is an Operating System ID (OSID) and an Image ID?

In order to make the best use of custom operating system images, it is important to understand the difference between these two concepts.

* An Image ID is a descriptor for a disk image.  This can be an image of an entire disk, a partition of a disk, or a set of partitions of a disk.  By supporting multiple partitions, we can technically support different operating systems within the same disk image.  These are referred to as _combo images_.  The Image ID points to a real file that is stored in the directory `/proj/YourProjectName/images`.  Associated with the Image ID is other critical information such as what node types are supported by the images and what operating systems are on each partition.  You can view the image ids on the [List ImageIDs page](https://www.isi.deterlab.net/showimageid_list.php3) which is in the Experimentation drop down menu on the testbed web interface.

* An OSID describes an operating system which resides on a partition of a disk image.  Every Image ID will have at least one OSID associated with it.  In typical testbed use, the Image ID and OSID will be the same, since we usually do not put multiple operating systems on a single image.  You can view the OSIDs on the [List OSIDs page](https://www.isi.deterlab.net/showosid_list.php3) which is in the Experimentation drop down menu on the testbed web interface.

We provide a number of supported testbed images here at DETER.  These images can be viewed by looking at the [Operating System ID list](https://www.isi.deterlab.net/showosid_list.php3).  Most new operating system images that we support are whole disk images, which is different from the more traditional scheme of using partition 1 for FreeBSD and partition 2 for Linux.  To view what nodes a particular operating system image runs on and what sort of partition scheme it uses, please refer to the [Image ID list page](https://www.isi.deterlab.net/showimageid_list.php3).

The supported testbed images are listed in the [wiki:OSImages Operating System Images] wiki page. 

#CustomOS

If your set of operating system customizations cannot be easily contained within an RPM/TAR (or multiple RPM/TARs), then you can create your own custom OS image. DeterLab allows you to create your own disk images and load them on your experimental nodes automatically when your experiment is created or swapped in. 

Once you have created a custom disk image (and the associated [ ImageID/OSID descriptor](https://www.isi.deterlab.net/newimageid_ez.php3) for it, you can use that OSID in your NS file. When your experiment is swapped in, the testbed system will arrange for your disks to be loaded in parallel using a locally written multicast disk loading protocol. Experience has shown that it is much faster to load a disk image on 10 nodes at once, then it is to load a bunch of RPMS or tarballs on each node as it boots. So, while it may seem like overkill to create your own disk image, we can assure you it is not!

The most common approach is to use the [New Image Descriptor](https://www.isi.deterlab.net/newimageid_ez.php3) form to create a disk image that contains a customized version of a standard Linux or the FreeBSD image. All you need to do is enter the node name in the form, and the testbed system will create the image for you automatically, notifying you via email when it is finished. You can then use that image in subsequent experiments by specifying the descriptor name in your NS file with the [wiki:nscommands#tb-set-node-os `tb-set-node-os`] directive. When the experiment is configured, the proper image will be loaded on each node automatically by the system.

# Creating your Custom Image

A typical approach to creating your own disk image using one of the default images as a base, goes like this:

    1. Create a single-node Linux or FreeBSD experiment. In your NS file, use the appropriate `tb-set-node-os` directive, as in the following example:
	
	    tb-set-node-os $nodeA FBSD7-STD
	    tb-set-node-os $nodeA Ubuntu1004-STD
	
    1. After your experiment has swapped in (you have received the email saying it is running), log into the node and load all of the software packages that you wish to load. If you want to install the latest version of the Linux kernel on one of our standard disk images, or on your own custom Linux image, be sure to arrange for any programs that need to be started at boot time. It is a good idea to reboot the node and make sure that everything is running as expected when it comes up.
    1. If you are creating a _Windows_ based image, you *must* "prepare" the node. The final thing to do before grabbing the image is to login on the [wiki:UsingNodes#SerialConsole console], drop to single user mode, and run the `prepare` script. This is described in detail in the [wiki:Windows#Custom_images custom Windows images] section of the Windows tutorial.
    1. Note the physical (`pcXXX`) name of the machine used!
    1. Create an image descriptor and image using the [New Image Descriptor](https://www.isi.deterlab.net/newimageid_ez.php3) form.
    1. Wait for the email saying the image creation is done.
    1. Now you can create a second single-node experiment to test your new image. In your .ns file, use `tb-set-node-os` to select the OSID that you just created. Be sure to remove any RPM or tarball directives. Submit that NS file and wait for the email notification. Then log into the new node and check to make sure everything is running normally.
    1. If everything is going well, terminate both of these single-node experiments. If not, release the experiment created in the previous step, and then go back and fix the original node (`pcXXX` above). Recreate the image as needed:
	
	    create_image -p <proj> <imageid> <node>
	 
    1. Once your image is working properly, you can use it in any NS file by using the `tb-set-node-os` command.
   If you ever want to reload a node in your experiment, either with one of your images or with one of the default images, you can use the `os_load` command. Log into `users` and run:
	
	    os_load -p <proj> -i <imageid> <node>
	
This program will run in the foreground, waiting until the image has been loaded. At that point you should log in and make sure everything is working okay. You might want to watch the console line as well (see the [wiki:UsingNodes#SerialConsole Node Console section]). If you want to load the default image, then simply run:
	
	    os_load <node>
	

#  Hints when Making New OS Images

1. Please, *never* try to create an image from a node or type that begins with the letter _b'', e.g. ''bpc183'' or  ''bpc2133_. These nodes are located in Berkeley which is physically located 400 miles away from the `boss` and `users` servers.

2. After you have created an image, load it back and watch what happens through the serial port.

Consider creating a *two* node experiment, one to create the image and the other to load it back.

There is a command called `os_load` available on the `users` server:
	
	 users% which os_load
	 /usr/testbed/bin/os_load
	 users% os_load -h
	 option -h not recognized
	 os_load [options] node [node ...]
	 os_load [options] -e pid,eid
	 where:
	     -i    - Specify image name; otherwise load default image
	     -p    - Specify project for finding image name (-i)
	     -s    - Do *not* wait for nodes to finish reloading
	     -m    - Specify internal image id (instead of -i and -p)
	     -r    - Do *not* reboot nodes; do that yourself
	     -e    - Reboot all nodes in an experiment
	   node    - Node to reboot (pcXXX)
	
while the second node is reloading, watch its progress in real time using the console command from the `users` server, ie:
	
	users% console pc193
	

3. If you think you've got a good image, but it flounders while coming up, create another experiment with an NS directive that says "Even if you think the node has not booted, let my experiment swap in anyway." This may allow you to log in through the console and figure out what went wrong. An example of such a directive is:
	
	tb-set-node-failure-action $nodeA "nonfatal"
	

4. Create whole disk images on a smaller machine rather than a single partition image.


# Updating your Custom Image

Once you have your image, it is easy to update it later by taking a
new snapshot from a node running your image. Assuming you have swapped
in an experiment with a node running your image, and you have made
changes to that node, use the DETER web interface to navigate to the
descriptor page for your image:

1. Use the "Experimentation" drop down menu, and choose "List ImageIDs" to see the entire list of Images you may access.
1. Find your custom image and click on it.
1. In the "More Options" menu, click on "Snapshot Node ..."
1. Fill in the name of the node that is running your image, and click on "Go"
1. As in the above instructions, wait for the email saying your image has been updated before you try and use the image.

[wiki:CoreReference < Back to Core Reference]