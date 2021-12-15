# Creating Custom Operating System Images

## What is an Operating System ID (OSID) versus an Image ID?

In order to make the best use of custom operating system images, it is important to understand the difference between these two concepts.

 * An **Image ID** is a descriptor for a disk image.  This can be an image of an entire disk, a partition of a disk, or a set of partitions of a disk.  By supporting multiple partitions, we can technically support different operating systems within the same disk image.  These are referred to as *combo images*.  The Image ID points to a real file that is stored in the directory `/proj/YourProjectName/images`.  Other critical information is associated with the Image ID, such as what node types are supported by the images and what operating systems are on each partition.  You can view the Image IDs on the <a href="https://www.isi.deterlab.net/showimageid_list.php3">List ImageIDs page</a>, which is in the *Experimentation* drop down menu on the testbed web interface.

 * An **OSID** describes an operating system which resides on a partition of a disk image.  Every Image ID will have at least one OSID associated with it.  In typical testbed usage, the Image ID and OSID will be the same since we usually do not put multiple operating systems on a single image.  You can view the OSIDs on the <a href="https://www.isi.deterlab.net/showosid_list.php3">List OSIDs page</a>, which is in the *Experimentation* drop down menu on the testbed web interface.

## Standard Testbed Images

We provide a number of supported testbed images here at DETERLab.  These images can be viewed by looking at the <a href="https://www.isi.deterlab.net/showosid_list.php3">Operating System ID list</a>.  

Most new operating system images that we support are whole disk images, which is different from the more traditional scheme of using partition 1 for FreeBSD and partition 2 for Linux.  To view what nodes a particular operating system image runs on and what sort of partition scheme it uses, please refer to the <a href="https://www.isi.deterlab.net/showimageid_list.php3">Image ID list page</a>.

The supported testbed images are listed on DETERLab (click on *Experimentation* from the top menu, then on *Images*).

## <a name="CustomOS"></a>Custom OS Images

If your set of operating system customizations cannot be easily contained within an RPM/TAR (or multiple RPM/TARs), then you can create your own custom OS image. DETERLab allows you to create your own disk images and load them on your experimental nodes automatically when your experiment is created or swapped in. 

Once you have created a custom disk image (and the associated <a href="https://www.isi.deterlab.net/newimageid_ez.php3"> ImageID/OSID descriptor</a> for it, you can use that OSID in your NS file. When your experiment is swapped in, the testbed system will arrange for your disks to be loaded in parallel using a locally written multicast disk loading protocol. 

!!! note
    Experience has shown that it is much faster to load a disk image on 10 nodes at once, then it is to load a bunch of RPMS or tarballs on each node as it boots. So while it may seem like overkill to create your own disk image, we can assure you it is not.

The most common approach is to use the <a href="https://www.isi.deterlab.net/newimageid_ez.php3">New Image Descriptor</a> form to create a disk image that contains a customized version of a standard Linux or the FreeBSD image. All you need to do is enter the node name in the form, and the testbed system will create the image for you automatically, notifying you via email when it is finished. You can then use that image in subsequent experiments by specifying the descriptor name in your NS file with the <a href="ns-commands/#tb-set-node-os">`tb-set-node-os`</a> command. When the experiment is configured, the proper image will be loaded on each node automatically by the system.

## Creating Your Custom Image 

A typical approach to creating your own disk image is using one of the default images as a base or template. To do this:

1. Create a single-node Linux or FreeBSD experiment. In your NS file, use the appropriate `tb-set-node-os` command, as in the following example:

        tb-set-node-os $nodeA FBSD-STD
        tb-set-node-os $nodeA Ubuntu-STD

1. After your experiment has swapped in (you have received the email saying it is running), log into the node and load all of the software packages that you wish to load. If you want to install the latest version of the Linux kernel on one of our standard disk images, or on your own custom Linux image, be sure to arrange for any programs that need to be started at boot time. It is a good idea to reboot the node and make sure that everything is running as expected when it comes up.
1. Note the physical (`pcXXX`) name of the machine used!
1. Create an image descriptor and image using the <a href="https://www.isi.deterlab.net/newimageid_ez.php3">New Image Descriptor</a> form.
1. Wait for the email saying the image creation is done.
1. Now you can create a second single-node experiment to test your new image. In your NS file, use `tb-set-node-os` to select the OSID that you just created. Be sure to remove any RPM or tarball directives. Submit that NS file and wait for the email notification. Then log into the new node and check to make sure everything is running normally.
1. If everything is going well, terminate both of these single-node experiments. If not, release the experiment created in the previous step, and then go back and fix the original node (`pcXXX` above). Recreate the image as needed:

        create_image -p <proj> <imageid> <node>

1. Once your image is working properly, you can use it in any NS file by using the `tb-set-node-os` command. If you ever want to reload a node in your experiment, either with one of your images or with one of the default images, you can use the `os_load` command. Log into `users` and run:

        os_load -p <proj> -i <imageid> <node>

    This program will run in the foreground, waiting until the image has been loaded. At that point you should log in and make sure everything is working okay. If you want to load the default image, then simply run:

        os_load <node>

##  Hints When Making New OS Images 

1. Please, **never** try to create an image from a node or type that begins with the letter **b**, e.g. **bpc183** or  **bpc2133**. These nodes are located in Berkeley which is physically located 400 miles away from the `boss` and `users` servers.
2. After you have created an image, load it back and watch what happens through the serial port.

    Consider creating a **two** node experiment, one to create the image and the other to load it back.

    There is a command called `os_load` available on the `users` server:

        users% which os_load
        /usr/testbed/bin/os_load
        users% os_load -h
        option -h not recognized
        os_load [options] node [node ...]
        os_load [options] -e pid,eid
        where:
            -i    Specify image name; otherwise load default image
            -p    Specify project for finding image name (-i)
            -s    Do *not* wait for nodes to finish reloading
            -m    Specify internal image id (instead of -i and -p)
            -r    Do *not* reboot nodes; do that yourself
            -e    Reboot all nodes in an experiment
          node    Node to reboot (pcXXX)

    While the second node is reloading, watch its progress in real time using the console command from the `users` server, ie:

        users% console pc193

3. If you think you've got a good image, but it flounders while coming up, create another experiment with an NS directive that says *"Even if you think the node has not booted, let my experiment swap in anyway."* This may allow you to log in through the console and figure out what went wrong. An example of such a directive is:

        tb-set-node-failure-action $nodeA "nonfatal"

4. Create whole disk images on a smaller machine rather than a single partition image.


## Updating your Custom Image 

Once you have your image, it is easy to update it later by taking a new snapshot from a node running your image. Assuming you have swapped in an experiment with a node running your image and you have made changes to that node, use the DETERLab web interface to navigate to the descriptor page for your image:

1. Use the *Experimentation* drop down menu, and choose *List ImageIDs* to see the entire list of Images you may access.
1. Find your custom image and click on it.
1. In the *More Options* menu, click on *Snapshot Node ...*
1. Fill in the name of the node that is running your image, and click on *Go*.
1. As in the above instructions, wait for the email saying your image has been updated before you try and use the image.
