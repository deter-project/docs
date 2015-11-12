Algorithm for _assign+_ is described in http://www.isi.edu/~mirkovic/publications/imc12-final.pdf

Code resides in assign_plus branch of the repository, in assign+ folder. There are three files:
* *assign+*
     * PURPOSE: reads resource requirements and available resources and finds an allocation with minimum interswitch bw use
     * INPUT: two command line arguments _ptopfile'' and ''topfile_. These files are usually produced in the process of resource assignment by assign_wrapper, now called mapper. There are a few other command line options, that should be self-explanatory when you run the code. If you want very verbose output run it with -d.
     * OUTPUT: textual output denoting nodes and links and their assignments that can be passed further to resource allocation
* *getptopdetail.pl*
      * PURPOSE: parse a _ptopfile_ into something human-readable. Assign+ also uses this output. 
      * INPUT: _ptopfile_
      * OUTPUT: human-readable summary of _ptopfile_
* *gettopdetail.pl*
      * PURPOSE: parse a _topfile_ into something human-readable. Assign+ also uses this output. 
      * INPUT: _topfile_
      * OUTPUT: human-readable summary of _topfile_

Testing code resides in assign_plus branch of the repository, in assign+/test folder. There are several files that jointly perform tests that compare performance of _assign'' and ''assign+_. 
* *removefixed.pl*
      * PURPOSE: Remove fixed nodes from a _topfile_
      * INPUT: _topfile_
      * OUTPUT: _topfile_ in correct format minus lines that talk about fixed nodes
* *makefixed.pl*
      * PURPOSE: Make a _topfile'' with fixed nodes taken from the output of ''assign'' or ''assign+_
      * INPUT: output-file-of-assign-or-assign+ _topfile_
      * OUTPUT: _topfile_ in correct format plus lines that enforce fixed nodes and fixed interfaces for links
* *parseinfo.pl*
      * PURPOSE: measure performance of _assign'' or ''assign+_
      * INPUT: a file containing output of _assign'' or ''assign+_
      * OUTPUT: success or failure of allocation, time the allocation took, number of nodes and interswitch links allocated
* *runtests.pl*
      * PURPOSE: run a number of tests with _assign'' and ''assign+_. The tests we run are the following:
          * t1. _assign'' with given ''ptopfile'' and ''topfile_
          * t2. _assign+'' with given ''ptopfile'' and ''topfile_
          * t3. _assign'' with given ''ptopfile'' and modified ''topfile_ to remove fixed nodes
          * t4. _assign+'' with given ''ptopfile'' and modified ''topfile_ to remove fixed nodes
          * t5. _assign'' with given ''ptopfile'' and modified ''topfile'' to remove fixed nodes, and then include fixed nodes and fixed interfaces from the output of ''assign+_ in step t4
      * INPUT: a file containing lines with _ptopfile'' and ''topfile_
      * OUTPUT: file _testresults_ that contains performance of these two allocation algorithms for each line of input
* *processresults.pl*
      * PURPOSE: process the results file generated in the previous step
      * INPUT: name of the results file
      * OUTPUT: statistics about successes and failures of _assign'' and ''assign+_. The code also produces files that contain inputs that lead to following potentially anomalous cases:
          * _checktests'' - ''assign+'' failed and ''assign_ didn't, i.e. t1 was a success and t2 was a failure
          * _failedtests'' - both ''assign+'' and ''assign_ failed, i.e. both t1 and t2 were failures
          * _weirdtests'' - ''assign+'' succeeded and ''assign_ didn't, i.e. t1 was a failure and t2 and t5 were a success
          * _impossibletests'' - ''assign+'' succeeded and ''assign'' didn't with fixed nodes from output of ''assign+'',  i.e. t1 was a failure, t2 was a success and t5 was a failure. This most often happens because ''assign_ cannot deal properly with fixed interfaces on links.

Additionally, the folder contains a version of _assign_ I have used in testing, that will run on boss. It also contains two sets of test cases:
* _expinfotests_ - all attempted allocations from start of DeterLab until Spring 2013
* _expfailedtests_ - all failed allocations roughly from Jan 2012 until Spring 2013

# Expinfotests

There were total of 109,326 tests. Historically, in real operation some of these allocations succeeded and some failed.

||Category|| Count|| Percentage || Reason ||
|| Both _assign'' and ''assign+_ succeeded || 98,641 || 90% || n/a ||
|| _assign'' succeeded, ''assign+'' failed || 98 || 0.08% || In 93 of these cases ''assign'' doesn't detect a disconnected switch topology nor oversubscribed interswitch bandwidth, but it should. In 2 cases we overestimate what we need in one vclass. I can fix this issue but it will have to wait. In 3 cases the ''ptopfile'' has an error - two interfaces on a physical node are called the same. ''assign'' doesn't pick up on this but ''assign+'' does, which should be correct behavior. So effectively in only 2 out of 109,326 ''assign'' is better than ''assign+_. ||
||  Both _assign'' and ''assign+_ failed || 6,341 || 5.8% || n/a ||
|| _assign'' failed, ''assign+'' succeeded, ''assign'' succeeded with fixed nodes from ''assign+'' || 666 || 0.61% || There is a good solution but ''assign_ cannot find it in a given number of trials.|| 
|| _assign'' failed, ''assign+'' succeeded, ''assign'' failed with fixed nodes from ''assign+'' || 3,580 || 3.24% || This happens because ''assign_ cannot properly deal with fixed interfaces. I checked quite a few of these solutions manually and they are possible solutions. || 

# Expfailedtests

There were total of 9,861 tests. Historically, all these allocations failed.

||Category|| Count|| Percentage || Reason ||
|| Both _assign'' and ''assign+'' succeeded || 300 || 3% || ''assign_ sometimes fails due to "luck". There is a good solution but it runs out of trials to find it. ||
|| _assign'' succeeded, ''assign+'' failed || 4 || 0.04% || In one case there was a disconnected switch topology. In other 3 cases ''assign'' does not properly check for OS support and ends up assigning nodes that cannot load a requested OS. Thus effectively there were 0 cases in these tests where ''assign'' was better than ''assign+_. ||
||  Both _assign'' and ''assign+_ failed || 9,409 || 95.4% || n/a ||
|| _assign'' failed, ''assign+'' succeeded, ''assign'' succeeded with fixed nodes from ''assign+'' || 147 || 1.49% || There is a good solution but ''assign_ cannot find it in a given number of trials. || 
|| _assign'' failed, ''assign+'' succeeded, ''assign'' failed with fixed nodes from ''assign+'' || 1 || 0.01% || This happens because ''assign_ cannot properly deal with fixed interfaces. I checked quite a few of these solutions manually and they are possible solutions. || 

# Performance Results

[[Image(time.jpg)]]

The image above shows the ratio of time taken by _assign+'' vs ''assign'' on y axis vs time taken by ''assign+'' on x axis. Values of y smaller than 1 (blue line) are better. We can see that the ratio varies a lot for short times, e.g., under 10 seconds. Sometimes ''assign'' is better and sometimes ''assign+''. As we go to more complex topologies that take longer to allocate ''assign+'' becomes decidedly better, often taking 1/10 of the time that ''assign'' needs. In the extreme this is 1 minute for ''assign+'' vs 10 minutes for ''assign_.



[[Image(nodes.jpg)]]

The image above shows the ratio of the nodes allocated by _assign+'' vs ''assign'' on y axis vs number of nodes allocated by ''assign+_ on x axis. All values are very close to 1 (blue line) indicating that both algorithms allocate similar numbers of nodes for a given topology. 


[[Image(isw.jpg)]]

The image above shows the number of interswitch links allocated by _assign'' on y axis vs number of interswitch links allocated by ''assign+'' on x axis. Values of y greater than 1 (above blue line) are better. We can see that ''assign+'' often allocates 10-100 times fewer interswitch links than ''assign_. 
