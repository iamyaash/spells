+++
date = '2025-02-23T18:16:08+05:30'
draft = false
title = 'Getting Started with nmcli (NetworkManager CLI)'
tags = [ "docs", "usage", "nmcli", "network"]

+++

# What is `nmcli`?
The `nmcli` means **NetworkManager Command Line Interface**. It's command-line utility tool used for controlling `NetworkManager` and reporting network status.

_In simple terms, we use that to interact with network related devices._

## How to use it?

I don't have proper way to explain, but let's learn it with a case-scenario:

### Connect to a wifi network:
1. Turn on the `wifi` module:
```sh
sudo nmcli radio wifi on
```
2. List the available networks:
```sh
sudo nmcli device wifi list
```
In case, it didn't display any network, please `rescan` the available network and list it:
```sh
sudo nmcli device wifi rescan
sudo nmcli device wifi list
```

3. Let's connect to the device:
Let's take an example and connect to that device
```sh
IN-USE  BSSID              SSID           MODE   CHAN  RATE        SIGNAL  BARS  SECURITY 
*       C8:D7:79:A6:28:24  JioFi2_A62824  Infra  7     130 Mbit/s  86      ▂▄▆█  WPA2     
```

```sh
sudo nmcli device wifi connect JioFi2_A62824 password "enter your password here inside dquotes"
```

## Modify the DNS Address of the Network
1. List the available networks
```sh
sudo nmcli connection show
```
> This will show the available networks connected to your device.
**Output:**
```sh
NAME                UUID                                  TYPE      DEVICE  
Wired connection 1  82aadf2b-xxxx-xxxx-a3ec-xxxxxxxxxxxx  ethernet  enp2s0  
lo                  e6b49b80-xxxx-xxxx-b8d7-xxxxxxxxxxxx  loopback  lo      
docker0             bfcf407f-xxxx-xxxx-bbfe-xxxxxxxxxxxx  bridge    docker0 
```

2. Modify the `Wired connection 1` network:
```sh
sudo nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.31.xx/24 ipv4.gateway 192.168.31.1  ipv4.dns "8.8.8.8 8.8.4.4" ipv4.method manual
```

- `ipv4.addresses 192.168.31.xx/24` - defines the custom address we want to assign to the network.
- `ipv4.gateway 192.168.31.1` - defines the default address of the router's IP address.
- `ipv4.dns "8.8.8.8 8.8.4.4"` - Assigning the custom DNS addresses
- `ipv4.method manual` - Setting the method of IPV4 DNS address assinging manually. 

3. **Restart the Connection**
Restart the connection after modifying it to apply the changes:
```sh
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"`
```

3. **Verify the New IP Address**
Check if the IP has been assigned successfully:
```bash
ip addr show wlan0 | grep inet
```
**Output**: (Shows something like this)
```sh
 docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 2a:fa:ba:87:b2:82 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
```
## Disabling IPv6

If you don't need IPv6, you can disable it for the specified connection:
```sh
sudo nmcli connection modify <connection-name> ipv6.method ignore
```
## Modify the Name of the Network
```sh
sudo nmcli connection modify <connection-name> connection.id <new-connection-name>
```
- `connection.id` - Responsible for changing the name of the connection.


# Troubleshoot (Reset to Original State)
If you ever messed up modifying the connections manually, you can simply revert back to default state which will solve the errors.

1. When the changes go wrong, it will raise conflicts between `systemd-resolved` & `NetworkManager`. At first, let's disable & stop the `systemd-resolved`.

```sh
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
```

Reset the `resolv.conf` and create a symlink as well.
```sh
sudo rm /etc/resolv.conf
sudo ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```
> **Note**: The symlink to `stub-resolv.conf` ensures system-default DNS resolution.

2. Now that it resets, we can restart the DNS services which is managed is by `NetworkManager`.
```sh
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo sytemctl restart NetworkManager
```

3. Verify the DNS configuration using `resolvectl`

```sh
resolvectl status
```
This will display the logs and status of the Network.

4. Check whether the configuration is reflected in `resolv.conf`
```sh
cat /etc/resolv.conf
```

**Summary**:
Basically, we first stop the services that manages the DNS, delete the file (`resolv.conf`) that holds the information for the DNS addresses and create the same file by symbolically linking it with `/run/systemd/resolve/stub-resolv.conf` (that's how it usually originated from anyway). Then we restart the services once again from the beginning which will reads the file and writes the default address based what is being written in the connection's configs.