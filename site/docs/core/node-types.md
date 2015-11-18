This is not a complete list of all node types available at DETERLab, but below are the primary types.

* <a href="#dl380g3">dl380g3</a>
* <a href="#MicroCloud">MicroCloud</a>
* <a href="#pc2133">pc2133</a> (including pc2133 and bpc2133)
* <a href="#pc3000">pc3000</a> (including pc3000, bpc3000, pc3060, bpc3060, and pc3100)
* <a href="#bvx2200">bvx2200</a>
* <a href="#bpc2800">bpc2800</a>
* <a href="#netfpga2">netfpga2</a>

## dl380g3

There are 120 dl380g3 class nodes available at <a href="/ISIUCB/">ISI</a>.

Machine: <a href="http://www8.hp.com/us/en/products/proliant-servers/product-detail.html?oid=5177953">HP Proliant DL360 G8 Server</a>

Each node has:

* Dual <a href="http://ark.intel.com/products/75784/Intel-Xeon-Processor-E5-2420-v2-15M-Cache-2_20-GHz">Intel(R) Xeon(R)</a> hexa-core processors running at 2.2 Ghz with 15MB cache
    * Intel VT-x support
* 24GB of RAM
* One 1Tb SATA HP Proliant Disk Drive 7.2k rpm G8 (boot priority)
* One 240Gb SATA HP Proliant Solid State Drive G8
* Two experimental interfaces:
    * One Dual port PCIe Intel Ten Gigabit Ethernet card for experimental ports
    * One Quad port PCIe Intel Gigabit Ethernet card, presently with one port wired to the control network

## MicroCloud

There are 128 MicroCloud nodes at <a href="/ISIUCB/">ISI</a>.

Machine: High Density <a href="http://www.supermicro.com/products/system/3U/5037/SYS-5037MC-H8TRF.cfm">SuperMicro MicroCloud</a> Chassis that fits 8 nodes in 3u of rack space.

Each node has:

* One <a href="http://ark.intel.com/products/52275/Intel-Xeon-Processor-E3-1260L-(8M-Cache-2_40-GHz)">Intel(R) Xeon(R) E3-1260L</a> quad-core processor running at 2.4 Ghz
    * Intel VT-x and VT-d support
* 16GB of RAM
* One 250Gb SATA Western Digital RE4 Disk Drive
* 5 experimental interfaces
    * One Dual port PCIe Intel Gigabit Ethernet card for the control network and an experimental port
    * One Quad port PCIe Intel Gigabit Ethernet card for experimental network

## pc2133

This node type includes pc2133 and bpc2133:

* There are 63 pc2133 nodes at <a href="/ISIUCB/">ISI</a>.
* There are 64 bpc2133 nodes at <a href="/ISIUCB/">UCB</a>.

The pc2133 and bpc2133 machines have the following features:

* Dell PowerEdge 860 Chasis
* One Intel(R) Xeon(R) CPU X3210 quad core processor running at 2.13 Ghz
* 4GB of RAM
* One 250Gb SATA Disk Drive
* One Dual port PCI-X Intel Gigabit Ethernet card for the control network (only one port is used).
* One Quad port PCIe Intel Gigabit Ethernet card for experimental network.

### CPU flags:

fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl '''vmx''' est tm2 ssse3 cx16 xtpr lahf_lm

## pc3000

This node type includes pc3000, bpc3000, pc3060, bpc3060, and pc3100.

There are:

* 0 pc3000 nodes at <a href="/ISIUCB/">ISI</a>
* 32 bpc3000 nodes at <a href="/ISIUCB/">UCB</a>
* 17 pc3060 nodes at <a href="/ISIUCB/">ISI</a>
* 32 bpc3060 nodes at <a href="/ISIUCB/">UCB</a>
* 4 pc3100 nodes at <a href="/ISIUCB/">ISI</a>

pc3000 and bpc3000 have the following features:

* Dell PowerEdge 1850 Chassis.
* Dual 3Ghz Intel Xeon processors.
* 2 GB of RAM
* One 36Gb 15k RPM SCSI drive (bpc machines may be configured with two).
* 4 Intel Gigabit experimental network ports.
* 1 Intel Gigabit experimental network port.

pc3060 and bpc3060 machines are the same as the pc3000/bpc3000 machines except that they have one more experimental network interface.

pc3100 machines have a total of 9 experimental interfaces and 1 control network interface.  There are only 4 of these type of machine.

## bvx2200

There are 31 bvx2200 nodes at <a href="/ISIUCB/">UCB</a>.

bvx2200 has the following features:

* Sun Microsystems Sun Fire X2100 M2 Chassis.
* Dual-Core 1.8 Ghz AMD Opteron(tm) Processor 1210.
* One 250Gb 7200 RPM SATA drive.
* 1 Broadcom NetXtreme Gigabit experimental network port.
* 2 Nvidia nForce MCP55 experimental network ports.
* 2 Intel Gigabit experimental network ports.

## bpc2800

There are 30 bpc2800 at <a href="/ISIUCB/">UCB</a>.

The bpc2800 machines have the following features:

* Sun Microsystems Sun Fire V60 Chassis
* One Intel(R) Xeon(R) CPU dual core processor running at 2.8 GHz
* 2 GB of RAM
* One 36 GB SCSI Disk Drive
* Two Dual port PCI-X Intel Gigabit Ethernet cards, 1 port for control network and 3 ports for experimental network
* One Single port PCI-X Intel Gigabit Ethernet card for experimental network

## CPU flags

fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr

## netfpga2

There are 10 netfpga2 class nodes in the testbed. These are pc2133 class machines. Each of these nodes has a single <a href="http://netfpga.org/">NetFPGA card</a> installed.

