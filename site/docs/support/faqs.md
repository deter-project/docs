# Frequently Asked questions

## Why can't I log in?

Too many failed attempts to log into the web interface will result in your account being locked. You will get a message saying that your account has been frozen if you trigger it. If you are a student, please contact your TA. Otherwise, please ​[contact us](https://www.deter-project.org/contact).

Also:
- You must use your **actual account name**, not an email address, to log into `users.deterlab.net`. 
- Too many failed attempts to log into `users.deterlab.net` will result in an **IP address ban**. We automatically whitelist all IP addresses that have successfully logged into the [​web interface](https://www.isi.deterlab.net/) and this list is synchronized every 15 minutes. So if you find yourself banned from connecting to `users.deterlab.net` please log into the ​web interface and then wait 15 minutes.

## How do I copy files from my workstation to a node in an experiment?

Your home directory from `users` is available on the nodes in your experiment. Copy your files to `users.deterlab.net` using `scp` or `sftp` to make them available on your nodes.

## How can I copy files from a node in the testbed to my workstation?

The reverse of the previous question: copy the files you want to your home directory, then download them from `users.deterlab.net` using `scp` or `sftp`.

## How can I install software on my nodes?

The currently supported operating system images (see the ​[Recommended list for currently supported OS images](https://www.isi.deterlab.net/showosid_list.php3)) have access to full package repositories on a local mirror. Depending on your OS you may use `yum`, `apt-get`, or `pkg_add` to install software that has been pre-packaged for each OS.

If there is no package for the software you wish to install, you may install from source. Copy the source tarball to the testbed (see [our guide to file coping](../core/interact.md#transfer-files) or use `wget` or `curl` on `users`), then follow the package's installation instructions.

While we will do everything we can to assist any issues you face, we do not have the resources to help individual users install software.

## I try to swap in and get the error: Admission Control: $project/$experiment has too many nodes allocated!

**If you are a class user:** the maximum number of nodes that can be allocated for a class is limited (see [Class Resource Limits](../../education/course-setup/#resource-limits) for details). Wait for some of your classmates to free up resources before trying to swap in again.

You are less likely to encounter this during non-peak hours (late night and early morning) and when deadlines are distant.

**If you are NOT a class user:** please [file a ticket](https://trac.deterlab.net/newticket), because something is broken.

## I try to swap out and get the error: /usr/testbed/bin/nfree: Please cleanup the previous errors.

This may not be so frequent an error, but may arise when the experiment deliberately brings an interface down without bringing it back up prior to swap out. Try scheduling the link back up before the end of experiment.

## Your site claims that my new password is in the dictionary. I checked the dictionary and 'qwerty1234' is not in it.

Please see our [Passwords page](../passwords/).