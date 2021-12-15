# Manual traffic generation

There are many tools that can be used to generate traffic. Below we give an overview of some frequently used tools. This list is not exhaustive. If you discover a useful tool that is not on the list, please let us know.

## Ping traffic

To just generate any traffic between two nodes, A and B, you can type on node A:

```
	ping B
```

This will generate one packet per second from A to B, and B will then send one-packet reply to A. If you want higher-intensity traffic try

```
	sudo ping -f B
```

This will generate a flood of packets between A and B.

## Steady, simple TCP or UDP traffic

To generate steady, simple traffic between A and B, where A just sends lots of data to B you can use `iperf` program. You may need to install this program on your nodes by typing `sudo apt install iperf`. 

On node B type
```
	iperf -s
```

and on node A type

```
	iperf -c B
```

There are many different parameters you can set for this program, such as length of running, how many parallel flows to create, how much bandwidth to use per flow, which transport protocol to use and if the traffic is unidirectional or bidirectional. Type `man iperf` to learn about these options.


## Complex, TCP traffic

You can use Mimic tool to generate complex TCP traffic, which is congestion-responsive. For example you can use this tool to generate flows that are not filling up the whole bandwidth, but rather pausing between sending some traffic chunks to emulate server and user think time. You can use Mimic tool to generate made-up traffic (similar to `iperf` use) or you can use it to extract data from a pcap trace and replay it in your experiment. While this tool is more complex than iperf it can also generate more complex and realistic traffic scenarios.

Clone the tool from [https://github.com/STEELISI/mimic](https://github.com/STEELISI/mimic) into your home directory on 	`users.deterlab.net`, then go on to your experimental nodes to  compile and use it.


## Web traffic

You can generate Web traffic between A and B, by running a web server on B and requesting files from A. Here are the necessary steps:

On B:
```
	sudo apt install apache2
```
Then, manually create some files in /var/www/html on B.

On A:
```
	wget B/one-of-files-you-created
```

The above will just generate one request for one file. If you want to continuously request files from B you can do the following

    1. store file names you created into a file, e.g., list.txt
    2. on A create `run.sh` with the following code:
```
    while :
    do
          for file in `cat list.txt` ; do
              wget B/$file &
          sleep 1
          done
    done
```
Then run the code on A with `bash run.sh`

This script will request one file per second in a forever loop.

If you want to request files more aggressively you can use `httpperf` program on A, instead of writing your own scripts. You will likely have to install it by typing `sudo apt install httpperf`. Then type `man httpperf` to learn how to use it.

## DNS traffic

You can install a DNS server on node B by typing `sudo apt install bind9`. Then you can follow steps outlined [here](https://www.linuxbabe.com/ubuntu/set-up-authoritative-dns-server-ubuntu-18-04-bind9) to set it up as authoritative server for some domain, e.g., `www.example.com`.

You can use `dnsperf` tool on A to generate client DNS traffic. Information on how to install and use `dnsperf` is given [here](https://www.dns-oarc.net/tools/dnsperf).

## DDoS traffic

You can use `flooder` tool to generate DDoS traffic between your nodes. To install it type on your experimental node `sudo /share/education/TCPSYNFlood_USC_ISI/install-flooder`. After that, type `floder --help` to see the attack options. Some examples on how to use flooder are [here](https://www.isi.edu/~mirkovic/tapia/flooder.html).

## Scanning traffic

You can use `nmap` tool to scan a machine on Deterlab. You will likely need to install it by typing `sudo apt install nmap`.

To scan B from A you would type on A `nmap B`. Type `man nmap` to learn about many different options that nmap has.

