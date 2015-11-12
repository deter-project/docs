This note attempts to give some information for using
the new Controlled eXternal Access sytem (CXA).

CXA attempts to be backwards compatible with experiments created under
the previous Risky Experiment mechanism, but gives some additional capabilites.

# Caveats and testing

Please note that like the risky experiment facility that it extends, *you cannot use ping (icmp) to verify that the access is functioning*.

The system gives specific access with different port sets to TCP and UDP and does not support ICMP at all.

# Dynamic modification/access

If you have an an existing experiment, and you want to grant it external access, you can do so , even if it is already swapped in, without restarting the experiment.

You use a web page `https://<testbed>/expcxa.php?pid=<pid>&eid=<eid>` and fill out the same form that is used by the "Make Experiment Risky" page, parsed with almost the same rules.

For *Outside nodes* - triples <dotted quad>/<port>/<proto>,
It is now permitted to specify a host of 0.0.0.0 (meaning any IP address),
and/or a port number of 0,  (meaning any port).

In the future, but not now, we would like to have the host part be
regular DNS names, or to allow the use of commas as separators instead
of slashes so that the hostpart could be an IP subnet.

There is also a bug that you have to click the check the box
for "Experiment need outside connetctivity" even if you've already
granted it.

To dynamically *remove* access granted either by using the CXA webpage, or as a result of the NS File extensions described
below, us the CXA webpage again, and delete the entries in the boxes as you would for modifying a risky experiment.

If your experiment already has specified nodes with external
connectivity in its ns file, it will issue commands to reconfigure
the *LAST* external node in your nsfile, instead of the shared gateway,
if the node is running some flavor of BSD; otherwise it just
modifies the risky experiment tables in the database.

# NS file extensions for shared external access

We have made a minor change to the parsing of the ns extension *tb-allow-external*

	
	      tb-allow-external $node [<cookietype> [key1 value1] [key 2 value2] .... ]
	

if the cookieype is "shared", then only the keyN valueN pairs will
be entered in virt_parameters table in the testbed database, and no pseudonode with vname
external_ipaddr<N> will be requested by the experiment.

The CXA backend will examine the virtual parameters specified above whenever an
an ns file is (re-)parsed and will (re-)initialize the risky_experiment
table entries in the testbed database, based on the values for two
specific keys, namely "nat" and "rdr".

The terminology is borrowed from the BSD packet filter; "nat" indicates (towards in the internet) network address translation
(for otherwise unroutable testbed nodes), and "rdr" indicates in-bound (toward experiment nodes) port redirection or forwarding.

Each of these keys may be specified a maximum of one time.

The values are a quoted string of whitespace separated targets,
such as the slash delimited triples that can be entered in section 1
above.

Alterations made by the webpage above persist only until
modifyexp or endexp is run on the testbed.

We allow some abbreviations for convenience.

For "rdr" targets, one may use triples as in the web page.

For pairs, the target is interpreted as be <port>/<proto>,
and the node part is assumed to be the node specified
in the tb-allow-external call.

For singletons, it is assumed to be <port> which the <proto>
defaulting to tcp.

For "nat" targets, one may use triples as in the web page.

Pairs are interpreted as <host>/<port>, the proto defaulted to tcp.
and singletons, it is assumed to be <host> which the <proto>
defaulting to tcp and the <port> default to 0 meaning all ports.

Here's an example of all six forms:

	
	        tb-allow-external $node shared nat "192.154.6.22/13/udp 192.154.6.21/25 128.32.112.228" rdr "22 web/80 othernode/13/udp"
	 

This allows any node in the experiment to send traffic to udp port 13 or boss.ucb.deterlab.net (which must be specified by dotted quad,
to the SMTP port on 192.154.6.21 and to any TCP port on 128.32.112.228.  hosts on the internet can also connect to an address and
port and protocol which will be listed on the experiment page, and variously forward to the SSH port on the node named "node",
the HTTP port on the experiment node named "web" and to the daytime UDP port on the experiment host called "othernode".

For any experiment having a tb-allow-external call in the ns file (even with no parameters), a swap-modify will *overrule* any changes
instituted using the dynamic CXA webpage above; however if there *no_' calls in the ns file, then a swap-modify '_will not revoke or changes any access dynamically granted*.


# DNS stuff

In the interest of backwards compatibility, even when using "shared"
external access there will still be a CNAME created for each
node named with a tb-allow-external call.  The value will be the
IP address of the shared NAT box.

Additionally, any nodes designated as targets of inbound
redirects will also have CNAMEs created for them, whether or not
the targets were created dynamically via a web page, or statically
in the NS file.  If all targets for a node specified in the NS file
were removed via the web, then no CNAME will be generated.