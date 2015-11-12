[[TOC]]

# History of an individual file
Text mode
	
	git log -p <filename>
	

Graphically
	
	gitk <filename>
	

# Find revision by date
This is kind of obtuse, and I really recommend ` git log ` or ` gitk `. If you insist:
	
	git rev-list -n 1 --before="2009-07-27 13:37" master
	
This finds one revision (-n 1) before a certain date. You can use this with ` git checkout ` (see below).

# Check out old version of a file
Find the old revision by using ` git log ` (see above).
	
	git checkout <revision> <file>
	

Reverting to the current version (HEAD):
	
	git checkout HEAD <file>
	

# Set file modifcation times to last commit

Here's a [attachment:git-touch.py little script] to walk through `git log ` output, find the commit times for each file and call `touch` on them.  Call it from the root of the checked out repository.  `git` and `touch` need to be in your path.  I was able to set times on the `abac` git repository by:
	
	$ cd abac
	$ python ../git-touch.py
	

No warranty.  As is.
