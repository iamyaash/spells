---
date: '2025-06-24T22:07:49+05:30'
draft: false
title: 'Linux: firewalld & iptables'
summary: 'Firewalls in Linux system administration, focussing on both firewalld and iptables.'
cover:
    image: posts/linux/firewalld/img/firewalld-screenshot.png
    alt: systemd-screenshot
tags:
- firewalld
- linux
- iptables
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
    TocOpen: true
---
# 1. What is Firewalls in Linux?
A **firewall** is a set of rules for controlling the incoming and outgoing network traffic based on criteria like **_IP address, port, and protocol_**. Linux offers multiple tools for firewall management with `firewalld` and `iptables` being the most common.

# 2. Key Concepts
- **Zones (firewalld)**: Logical groupings of rules that define the trust level of network connections (e.g., public, home, work)
- **Ports**: Numeric endpoints for network services (e.g., 80 for HTTP, 22 for SSH)
- **Protocols**: The type of network traffic (e.g., TCP, UDP)
- **ACCEPT/DROP**: 
  - ACCEPT: Allows traffic
  - DROP: Silently discards traffic (_no response to sender_)
- **Permanent vs Runtime Rules**: 
  - Runtime: Active until reboot or reload.
  - Permanent: Saves and applied after reboot.
# 3 Using `firewalld`
`firewalld` is a dynamic firewall manager that uses zones and services for easier configuration.
## Basic Commands
- List all current rules:
```sh
firewall-cmd --list-all
```

- Add a service (eg: SSH)
```sh
firewall-cmd add-service=ssh --permanent
```

- Remove a service
```sh
firewall-cmd --remove-service=ssh --permanent
```

- Add a port (eg: HTTP, port 80)
```sh
firewall-cmd --add-port=80/tcp --permanent #use --remove-port=80/tcp --permanent to remove the HTTP and port.
```

- Reload to apply changes
```sh
firewall-cmd --reload
```

- Set default zone
```sh
firewall-cmd --set-default-zone=public
```

- Add a rich rule to allow only a specific IP
```sh
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.31.100" accept'
```

# 4. Using `iptables`
`iptables` provides fine-grained control over firewall rules but **has a steeper learning curve**.

## Basic Commands
- List current rules
```sh
iptables -L
```

- Allow incoming SSH (Port 22)
```sh
iptables -A INPUT -p tcp -dport 22 -j ACCEPT
```

- Allow incoming HTTP (Port 80)
```sh
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

- Drop all incoming traffic
```sh
iptables -A INPUT -j DROP
```

- Save rules (using `iptables-save`)
```sh
iptables-save > /etc/sysconfig/iptables
```

- Restore rules
```sh
iptables-restore <  /etc/sysconfig/iptables
```

# Exercies
1. Open and close ports with `firewalld`
- Open port 80 for HTTP:
```sh
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload #to reflect the changes
```
- Close port 80
```sh
firewall-cmd --remove-port=80/tcp --permanent
firewall-cmd --reload
```

> Make sure to use `--reload` to reflect changes all over the device.

2. Allow/Deny services with `firewalld`
```sh
firewall-cmd --add-service=ssh --permanent #allow/add the service
firewall-cmd --reload

firewall-cmd --remove-service=ssh --permanent #deny/remove the service
firewall-cmd --reload
```

3. Secure system by allowing only trusted IP
```sh
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.31.100" service name="ssh" accept'
firewall-cmd --reload
```
**Purpose:** Adds a `rich rule` to the `public` zone of the firewall, allowing only the IP address `192.168.31.100` to access the SSH service (_port 22 by default_) over IPV4. All other IPs attempting to connect SSH will be blocked unless another rules is specified for that IP address.

- `--permanent` ensures the rules are saved even after reboot or service restart.
- `--zone=public` specifies the zone where the rule is added. The `public` zone is typically used for interfaces exposed to the internet or untrusted networks. So blocking other IPs except the specified IP actually makes sense.
- `--add-rich-rule` adds a rich rule, which **allows for more complex and granular firewall configurations** than simple port or service rules. 
- `rule family="ipv4"` specifies this rules only applies to IPV4 traffic.
- `source address="192.168.31.100"` restricts the rule to traffic originating from the IP address.
- `service name="ssh"` applies the rule to the SSH service (port 22).
- `accept` allows the matching traffic. (ACCEPT/DROP...)

4. Setup basic rules with `iptables`
```sh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -j DROP
```
Use this command, in case you want to save the rules.
```sh
iptables-save > /etc/sysconfig/iptables
```

5. Monitor firewall logs
```sh
journalctl -xe | grep firewalld
journalctl -xe | grep iptables
```
