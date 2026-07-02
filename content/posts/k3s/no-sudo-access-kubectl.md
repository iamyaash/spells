---
date: '2026-06-28T15:31:27+05:30'
draft: false
title: 'K3s: Running kubectl Without sudo (and Fixing Permission Warnings)'
summary: "This guide outlines three proven methods to configure passwordless non-root kubectl access in a K3s cluster. It covers setting up your local user context, adjusting system file permissions, and permanently silencing annoying configuration permission warnings. "
author: "Yashwanth Rathakrishnan"
tags:
- k3s
ShowToc: true
TocOpen: true 
ShowReadingTime: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
---
# Overview
K3s locks the cluster configuration file (`/etc/rancher/k3s/k3s.yaml`) to the root user by default. By default, you are forced to prefix every command with `sudo` just to authenticate with the API server. If you ever get tired of typing `sudo` before every single command, you can give your regular `$USER` user permission to read the cluster config.

# Method 1
```sh
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
```
Once you do that, you can drop the `sudo` entirely and just run:
```sh
kubectl get pods
```
If you still get this warning try the "**METHOD 2**":
```sh
WARN open /etc/rancher/k3s/config.yaml: permission denied
```
# Method 2
You can completely silence these permissions warnings by telling `kubectl` to only look at your local user config file. Run this command on your Raspberry Pi 5:
```sh
echo "export KUBECONFIG=\$HOME/.kube/config" >> ~/.bashrc
source ~/.bashrc
```

# Method 3
> If the `KUBECONFIG` trick didn't silence it on `K3s`, your `kubectl` command is actually a symlink running `k3s kubectl` under the hood.
> Before it even looks at your pod configuration, the core `k3s` wrapper binary always checks `/etc/rancher/k3s/config.yaml` to see if there are global cluster configuration options.

Because your standard user account lacks read permissions for that system configuration directory, the K3s CLI wrapper throws those annoying warning lines. We can fix this permanently by updating the file permissions::
```sh
sudo chmod 644 /etc/rancher/k3s/config.yaml
```

This basically allows the standard user `$USER` to safely read (`644`) the basic configuration parameters _without giving away any administrative root or write access_:

Now try `kubectl` without `sudo`:
```sh
kubectl get pods
```