	
	# Place all config file global variables. Eg. variables to be used as string interpolation
	# for the rest of the file.
	#
	topdir = /Users/gbartlet/Research/TrafGen/
	datadir = /tmp
	
	[logging]
	        log_file = /tmp/fred
	        log_level = 1
	
	[nodes]
	
	[[isi.deterlab.net]]
	gateway = users.isi.deterlab.net
	username = gbartlet
	nodes = n1, n2, r1
	
	[[isi.edu]]
	nodes = steel
	username = gbartlet
	
	[[usc.edu]]
	nodes = hpc
	username = gbartlet
	
	
	[groups]
	        # In this section we define how we group the hosts defined in the 'nodes' section.
	        # Group names can be anything as long as they are only are comprised of nothing but
	        # alphanumeric characters, plus the underscore character. Eg. "my_hosts3" or "web_servers".
	        #
	        # Groups definitions can be nested, up to a default of 3 nestings.
	        #
	        # Groups may be modified and added to by blocks in the 'resource allocation' section.
	        #
	        # If you are using blocks which will fill in group members for you,
	        # it's ok to leave a group name blank. (eg. "my_group_x = ")
	        group6 = group3, host5, localhost, localhost, localhost, localhost, localhost, localhost, group3, hos
	        group1 = n1.click-test.trafgen.isi.deterlab.net
	        group2 = group1, host2
	        group3 = group2, host6
	        my_group_x =
	
	[extraction]
	        order = blah2
	        actions = none
	        [[blah2]]
	        def = ${topdir}/alias/legoTGinterface.py
	
	[resource allocation]
	        order = blah
	        actions = none
	        [[blah]]
	
	[experiment]
	        # First we use the keyword 'order' to define the order of precidence
	        # that blocks should be called in.
	        order = alias
	
	        # Actions which define an experiment and the order these are called in.
	        #
	        # Default is "install, setup, test, status, start, status"
	        #
	
	        actions = install, setup, test, status
	        # In the following subsections (eg. [[ ]]) we give the block names (which can be anything)
	        # and where to find the interface file (keyword 'def') and which target groups or hosts
	        # this block will be run on (keyword 'target').
	        #        
	        # Note that multiple blocks can use the same interface definition file, but with different
	        # targets and variables.
	        #
	        # Each block needs a unique name. (eg. none of the names within the following [[ ]] brackets
	        # should be the same.
	        #
	        # Needs lists the files which the block depends on. This list is checked to make sure
	        # these files have been created by the appropriate block.
	        #
	        #
	        # The [[[variables]]] section of each block is optional. Variable names should match
	        # the class variable names in the interface file specified in 'def'.
	        #
	        [[alias]]
	                filename = FRED
	                def = ${topdir}/alias/legoTGinterface.py
	                target = group1
	                needs = ${datadir}/frank/%host.ips
	                creates = ${datadir}/frank/%host.out, $filename
	
	                [[[input]]]
	                my_var = value2
	
	        [[alias two]]
	                def = ${topdir}/alias/legoTGinterface.py
	                target = group1
	
	                [[[input]]]
	                my_var = stuff
	
	        [[route]]
	                def = ${topdir}/route/legoTGinterface.py
	                target = group1
	
	                [[[input]]]
	
	