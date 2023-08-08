
!!! important
    This page is deprecated. Please use our <a href="https://launch.mod.deterlab.net/">new platform</a> and accompanying documentation.
 
# MAGI Development Codebase

The MAGI codebase is maintained in three branches.

- **Current/Released**: Stable released version

- **Development**: Stable with added features after the last release

- **Test**: Unstable

To be able to work with the development branch, you will need to change the bootstrap command.

**Instead of:**
~~~~
sudo python /share/magi/current/magi_bootstrap.py
~~~~

**Use:**
~~~~
sudo python /share/magi/dev/magi_bootstrap.py
~~~~

This will install MAGI from the development code base.

Also, if you run MAGI tools from the Deter Ops (``users.deterlab.net``) machine, then make the tools point to the development code base:
~~~~
export PYTHONPATH=/share/magi/dev_src
/share/magi/dev/magi_orchestrator.py -c bridgeNode -f eventsFile
~~~~

However, in case you use one of the experiment nodes to run MAGI tools, you can use them the same way as while running the current version of MAGI.