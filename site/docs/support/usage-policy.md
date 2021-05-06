# Deterlab Usage Policy

## Be a good citizen

DETER is a shared resource. We expect users to be good citizens by not abusing or wasting the resources we make available to them for free. We ask that you:

- **Read the [Core tutorial](/core/core-guide/)** and give us feedback!
- **Do not share accounts.** We will close accounts that we suspect to be shared.
- **Use good passwords.** We are a computer security testbed, so please use a strong password. For more details, see our [Passwords page](/support/passwords/).
- **Swap out your experiment when it is finished.** People forget to do this all the time. We do have an idle detection mechanism, but it is not perfect and may keep thinking your experiment is active long since you have collected your results, published your paper, and achieved tenure. Please log back in and **free up your nodes so that other researchers can use them**.
- **Do not abuse the no idle-swap feature.** Only turn off idle swap if there is a true need. Take the time to script the setup process for your experiment or create custom disk images.
- **Make good use of disk space.** Our goal at DETER is to assist you in running experiments. We are happy to provide you with all the storage necessary to accomplish your experimental goals. Also, we maintain nightly backups going back a few weeks. However, we are not a substitute for personal or institutional storage.
    - **We are not a backup service.** Please keep your important files backed up offsite at your institution. Our main machine room is technically subject to earthquakes, tsunamis, and liquefaction. Take a look at *rsync*.
    - **We are not an archive.** Please clean up or move offsite any large log files and traces after your experiment is done and paper is published. This makes sure that storage is available to researchers who are actively using the testbed.
    - **Keep things tidy.** Remove unused custom operating system images. Experts tell us that 22% of custom operating system images are never used even once. Why keep that around on disk so that it is backed up day after day? It slows down our backups and crash recovery disk checks, and takes resources away from other researchers.
    - **If you do need more space, just contact us.** Quota limits and housekeeping requests allows us to have extra space available to allocate to you when you need it.
    - **Let us know if you are done with your project.** - We'll clean it up for you!
- **Talk to us if you need something - we are here to help you.** We often can provide useful suggestions about running experiments on the testbed.

## First come, first served. Sort of…

- **We don't have an advanced scheduler.** Unfortunately, our software does not support advance reservations. But we are always willing to work with users to help them acquire nodes they need on time, and then help them hold those nodes as long as they need them. Sometimes this involves blocking the nodes out for a period of time. Other times this involves swapping the experiment in the night before the demo, when most nodes are free. [Please submit a ticket](https://trac.deterlab.net/newticket) if you need a reservation and we will work with you.
- **We may swap out idle experiments.** We audit the testbed for idle experiments. When the testbed is close to full we will ping the users with long-running, idle experiments and ask if they can be swapped out. If no response is received within 8 hours, we will swap out the experiment. Note that you may prevent this by promptly replying to our email and telling us you need the nodes.
- **Very rarely, we may restrict use to a part of the testbed.** There are times when a large-scale demonstration requires us to block off a part of our testbed. At these times, you will see reduced node availability but your swapped in experiments will not be disturbed. We will inform you about these planned events at least two weeks ahead, via news items on DETERLab's web page.
- **Watch out for downtimes.** We have regular weekly downtimes where we reserve the right to perform service-interrupting work on the testbed (most weeks we sail right through without any noticeable interruption of service) and sometimes special downtimes are required. We usually give a few days notice before the special downtimes. Keep an eye on the DETERLab News Page for notices.

## Privacy

DETER is a resource shared by users around the world. While we do our best to keep experiments separated from each other, we can not provide any guarantee of privacy between projects. If you are concerned about privacy, please make sure you understand how to use UNIX permissions and encrypt your files when they are stored on our main file server. Feel free to contact us if you have any questions.

Usage is also governed by the University of Southern California’s [Privacy Policy](https://policy.usc.edu/info-privacy/).