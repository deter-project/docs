# Hostnames for your nodes

We set up names for your nodes in DNS and `/etc/hosts` files for use on the nodes in the experiment. Since our nodes have multiple interfaces (the control network, and, depending on the experiment, possibly several experimental interfaces) determining which name refers to which interface can be somewhat confusing. The rules below should help you figure this out.

  * **From users.deterlab.net** - We set up names in the form of `node.expt.proj` in DNS. This name always refers to the node's control network interface, which is the only one reachable from `users.deterlab.net`. 
  * **On the nodes themselves** - There are three basic ways to refer to the interfaces of a node. The first is stored in DNS, and the second two are stored on the node in the `/etc/hosts` file.
    1. *Short form* - Within your experiment you should use just the node name (e..g, `nodeA`) to refer to the nodes. This ensures that traffic between nodes in your experiment goes over the links you created
    1. *Node-link form* - You can refer to an individual experimental interface by suffixing it with the name of the link or LAN (as defined in your NS file) that it is a member of. For example, `nodeA-link0` or `server-serverLAN`. This is the preferred way to refer to experimental interfaces, since it uniquely and unambiguously identifies an interface.
    1. *Fully-qualified hostnames* - These names are the same ones that use use on users.deterlab.net and look like `node.expt.proj`. This name always refers to the control network interface.

!!! note
    It is a bad idea to pick virtual node names in your topology that clash with the physical node names in the testbed, such as "pc45".

