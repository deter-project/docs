# User Do's and Don'ts

**If you are a student: DO read the [Student Introduction to DETERLab](/education/student-intro/).**

## Preserving our Control Network

- DON'T use control network unless absolutely necessary. This means:

    - DON'T use full node names such as `ping node1.YourExperiment.YourProject`

        - DO use short names such as `ping node1`. This ensures that traffic goes over experimental network.

    - DON'T generate traffic to `192.168.x.x` network.

        - DO use addresses of experimental interfaces. These can be from any IPv4 address range, depending on your NS file, but are often from the `10.10.x.x` address range.

## Preserving our File System

- DON'T store large files (e.g. uncompressed kernel source) in your home or project directory unless you need them in multiple experiment instances.

    - DO store these files locally on a node, e.g., in `/tmp` folder. If you need more disk space on a Linux or FreeBSD node you can mount more to `/mnt/local` by doing
        
        ```sudo /usr/local/etc/emulab/mkextrafs.pl /mnt 
        user='whoami' 
        sudo chown $user /mnt/local
        ```
        
        or on an XP node, SSH in and set a root password:
        
        `% passwd root`
        
        then through rdesktop log in as root, and use _start -> control panel -> performance and maintenance -> administrative tools -> computer management -> storage -> disk management (local)_ to create a new partition. After the partition formats, log out of the root account and the storage will be available to your usual identity.
        
    Transfer the files to your home directory before you swap out to save them.

- DON'T transfer large (>500 MB) files frequently between your home or project directories and a local directory on your experimental machine.

    - If you need to regularly save and read large files that persist between experiment instances [create a ticket](https://trac.deterlab.net/wiki/GettingHelp) and we will help you use our ZFS storage.

- DON'T perform large (> 500 MB) or frequent (< 10 s) reads/writes on your experimental nodes into your home or project directory

    - DO perform these reads/writes on a local disk (`/tmp` or `/mnt/local` on experimental machines)

- DON'T compile software or kernels in your home directory

    - DO compile them on a local disk (`/tmp` or `/mnt/local` on experimental machines)

## Preserving CPU Cycles on users

- DON'T compile large files or run CPU intensive jobs on `users.deterlab.net`.

    - DO allocate experimental nodes, store files locally and compile/run jobs there.
