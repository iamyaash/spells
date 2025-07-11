---
date: '2025-06-22T11:22:47+05:30'
draft: false
title: 'Linux: Networking Tools'
summary: "Linux networking tools for system administration: ip, ss, netstat, ping, and more."
tags:
- linux
- networking-tools
params:
    author: "Yashwanth Rathakrishnan"
    ShowToc: true
    TocOpen: true
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---

# Networking in Linux

## 1. `ip` Command
The `ip` command is a modern tool for managing network interfaces, IP addresses, and routing tables. It replaces older tools like `ifconfig` and is part of the `iproute2` suite.

- #### Essential Commands
- `ip link`: Show and manage network interfaces.
- `ip address(ip a, ip addr)`: Show and manage IP addresses.
- `ip route (ip r)`: Show and manage routing tables.

- #### Usage
| Command                                        | Description                                                   |
|------------------------------------------------|---------------------------------------------------------------|
| `ip link`                                      | List all network interfaces and their status                  |
| `ip addr`                                      | Show IP addresses assigned to interfaces                      |
| `ip route`                                     | Show the routing table                                        |
| `sudo ip link set <interface> up \| down`      | Bring an interface `up or down`                               |
| `sudo ip addr add <IP>/<mask> dev <interface>` | Add an IP addresses to an interface (gets reset after reboot) |

- #### Example
1. **Find you gateway and try adding static IP route**
```sh
ip route
```
```sh
# make sure to copy the IP address that start after "default via" (that's the default gateway of your network)
sudo ip route add 192.168.31.13 via 192.168.31.1
```

2. List all network interfaces and note their names
```sh
ip link
```

3. Check the current IP address of your main interface
```sh
ip r #to display the current network interface and it will you show you the ip address as well
ip a #to display all the network interface
```

4. Display the routing table and identify your default gateway
```sh
ip r # the IP address that's showed after "default via" is your default gateway address
```

## 2. `ss` Command
`ss` is a tool to monitor network sockets and connections. It is faster and more informative than `netstat` and is preferred in modern Linux systems.

- #### Essential Commands
- `ss -a`: Show all sockets (_listening and established_).
- `ss -l`: Show only listening sockets.
- `ss -n`: Show numerical addresses instead of resolving hostnames.
- `ss -p`: Show the process using the socket.
- `ss -t`: Show TCP connections.
- `ss -u`: Show UDP connections.

- #### Usage
| Commands   | Description                                       |
|------------|---------------------------------------------------|
| `ss -a`    | List all listening and established connections    |
| `ss -lt`   | List only listening TCP sockets                   |
| `ss -t -p` | Show all TCP connections with process information |
| `ss -u`    | Show all UDP connections                          |

- #### Example
1. List all listening TCP ports on your system.
```sh
ss -lt
#l shows only listening sockets
#t show only the listening TCP sockets
```

2. Find out which process is using port 88 (_SSH_)
```sh
ss -pa | grep ":88" #filter both listening and non-listening sockets
ss -tuln | grep ":88" #more specific 
```

3. List all established TCP connections
```sh
ss -at
```

## 3. `netstat` Command
`netstat` is a legacy tool for displaying network connections, routing tables, and interface statistic. It is less efficient than `ss` but still useful.

- #### Essential Commands
- `netstat -a`: Show all sockets.
- `netstat -n`: Show numerical addresses.
- `netstat -t`: Show TCP connections.
- `netstat -u`: Show UDP connections.
- `netstat -r`: Show routing table.
- `netstat -i`: Show network interface statistic.

- #### Usage
| Commands      | Description                      |
|---------------|----------------------------------|
| `netstat -a`  | Show all sockets                 |
| `netstat -at` | Show all TCP connections         |
| `netstat -r`  | Show routing table               |
| `netstat -au` | Show all UDP connections         |
| `netstat -i`  | Show network interface statistic |

- #### Example
1. List all active network connections
```sh
netstat -a
```

2. Display the routing table
```sh
netstat -r
```

3. Check statistics for your network interfaces
```sh
netstat -i
```

## 4. `ping` Command
`ping` is used to test connectivity between your system and another host on the network. In simple terms, `ping` command is used to test if a host is reachable.

- #### Essential Commands
- `ping -c`: Number of packets to send.
- `ping -i`: Interval between packets.
- `ping -s`: Packet size.

- #### Usage
| Command                | Description                                                  |
|------------------------|--------------------------------------------------------------|
| `ping google.com`      | Ping a host (_it's continuous by default, stop with CTRL+C_) |
| `ping -c 4 bing.com`     | Send only 4 packets                                          |
| `ping -i 2 bing.com`   | Change the interval between packets                          |
| `ping -s 100 bing.com` | Specify packet size                                          |
    
- #### Example
1. Ping _bing.com_ and observe the output
```sh
ping bing.com
#stop with CTRL+C after some time
```

2. Ping you local gateway
```sh
ping 192.168.31.1
```

3. Send 5 packets with a 3 second interval to a known IP
```sh
ping -i 2 -c 4 192.168.61.123
```

## Bonus
### `traceroute` Command
`traceroute` traces the path packets take to reach a destination, showing each hop and the response time. It helps identify where a connection slows or fails.
- #### Essential Commands
- `-m`: Set the maximum number of hops. (_aka ping -c_) (`traceroute -m 10 bing.com`)
- `-n`: Show IP addresses instead of hostnames (`traceroute -n bing.com`)
- `-I`: ICMP echo requests instead of UDP (`traceroute -I bing.com`)
- `-w`: Set timeout for each probe (`traceroute -w 2 bing.com`)

- #### Example
1. Trace the route to bing.com and note number of hops
```sh
traceroute bing.com
```
```sh
#output
traceroute to bing.com (2620:1ec:33::10), 30 hops max, 80 byte packets
```

2. Repeat with the `-n` option to see only IP addresses.
```sh
traceroute -n
```

3. Limit the trace 8 hops
```sh
traceroute -m 8 bing.com
```

### `dig` and `nslookup`
These tools query DNS records, helping you check domain resolution and DNS server usage.
## `dig`
- #### Usage
```sh
dig bing.com
```
- #### Subcommands
- `+short`: Shows only the answer (`dig bing.com +short`)
- `+trace`: Trace the DNS query path from the root servers down to the authoritative server for the domain (`dig bing.com +trace`)

## `nslookup`
- #### Usage
```sh
nslookup bing.com
```
This returns the resolved IP address and the DNS server used for the lookup.

**Interactive Mode**:
```sh
nslookup
> google.com
> set type=mx
> google.com
> exit
```
