# MAGI Desktop

## Step 1: Install the following dependencies. 

The source code for all of these is available on Deter Ops (```users.deterlab.net```) under ``/share/magi/tarfiles/``:

~~~~
python-yaml
python-pydot
python-networkx
py-matplotlib
Mongo DB
python-pymongo
Yaml C Library (required for c-based agents, otherwise too helps improve performance)
Mongo C Library (required only for c-based agents)
~~~~

All python packages can be installed using pip.

Install pip, if not already available.
~~~~
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
~~~~
~~~~
pip install pyyaml
pip install pydot
pip install networkx
pip install matplotlib
pip install pymongo
~~~~
    
## Step 2: Download and install MAGI

~~~~
$ git clone https://github.com/deter-project/magi.git
$ cd magi
$ sudo python setup.py install
~~~~

## Step 3: Run a simple two node MAGI setup.

~~~~
$ tools/magi_desktop_bootstrap.py -n node1,node2
# This should start two MAGI daemon processes with names node1 and node2
# The script creates sample config files and uses them to run MAGI daemons
# by default the config and logs files should be available under /tmp/<node_name>
~~~~

## Step 4: Check if both MAGI daemons are running.

~~~~
$ magi_status.py -b node1 -n node1,node2
# This should at the end say "Received reply back from all the required nodes"
~~~~