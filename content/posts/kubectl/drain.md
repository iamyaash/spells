---
date: '2026-07-07T13:47:33+05:30'
draft: false
title: "Kubectl: Safely Drain A Node"
summary: "This post explains how to safely evict pods using the drain command. It covers how the drain command works behind the scenes, includes the essential commands you need, and ends with a practical example to demonstrate its usage."
author: "Yashwanth Rathakrishnan"
tags:
- k3s
- kubectl
- kubectl drain
cover:
    image: posts/kubectl/img/kubectl_cover.png
    alt: kubectl command
ShowToc: true
TocOpen: true 
ShowReadingTime: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
---
# What is **`drain`**?
**`kubectl drain`** is a command used in Kubernetes to [safely evict all pods](https://docs.yaasharc.me/posts/kubectl/rename-node/#standard-procedure-to-change-node-name) from a node in preparation for maintenance or updates, ensuring minimal disruption to services.

It marks a node as unschedulable ([**`cordon`**]()) and then it gracefully evicts all running pods, allowing them to be reschedulable on other nodes. This command ensures preventing service interruptions, and handles everything smoothly during maintenance.

```sh
kubectl drain NODE_NAME
```

# Detailed Explanation
The **`drain`** command **_marks the node unschedulable to prevent new pods from arriving_**. It evicts the pods if the [API server](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) supports eviction, else it will delete the pods.

The Daemon set-managed pods cannot be drain'ed without using **`--ignore-daemonsets`**, because those pods would immediately be replaced by the daemon set controller, which ignores unschedulable markings.

```sh
kubectl drain NODE_NAME --ignore-daemonsets
```

If there are any pods that are neither _mirror pods_ nor managed by a:
- _Replication Controller_
- _Replica Set_
- _Daemon Set_
- _Stateful Set_
- _Job_

then, the **`drain`** will not delete any pods unless you use **`--force`**, which will allow deletion to proceed if the managing resource of one or more pods is missing.

```sh
# drain even if they are not managed by (above mentioned)
kubectl drain NODE_NAME --force
```

```sh
# abort drain if they are not managed by (above mentioned)
kubectl drain NODE_NAME --grace-period=900
```

# Essential Commands
- Local data used by pods are deleted when the node is drained.
```sh
kubectl drain NODE_NAME --delete-emptydir-data
```
- DELETE pods even if eviction is supported. (Bypasses checking `PodDisruptionBudgets`)
```sh
kubectl drain NODE_NAME --disable-eviction
```
- Terminating pods gracefully within the given seconds/time
```sh
kubectl drain NODE_NAME --grade-period=8 #-1 uses the default value specified in pod
```
- Duration before giving up, (0 = infinite)
```sh
kubectl drain NODE_NAME --timeout-duration
```

> The above mentioned commands are the one you'll most probably use everyday, but checkout the [official documentation](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_drain/#options) to learn more about other available options.

# Example
Using `drain` command to rename the nodes, [Checkout this post to learn more](https://docs.yaasharc.me/posts/kubectl/rename-node/).

In order to rename the node:

1. Drain the node (**_On Control Plane_**)
```sh
kubectl drain NODE_NAME --ignore-daemonsets --delete-emptydir-data
```
2. Stop the systemd service and rename the hostname (**_On Worker Node_**)
```sh
sudo systemctl stop k3s-agent.service
sudo hostnamectl set-hostname NEW_HOSTNAME
```
3. Update the records in `/etc/host`(**_On Worker Node_**)
```sh
#  i.e: rename `OLD_HOSTNAME` to `NEW_HOSTNAME` 
sudoedit /etc/hosts
```
4. Delete the node (**_On Control Plane_**)
```sh
kubectl delete node NODE_NAME
```
5. Reinstall `k3s-agent` (**_On Worker Node_**)
- Copy node-token
```sh
sudo cat /var/lib/rancher/k3s/server/node-token
```
- Execute the installation script
```sh
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.31.11:6443 K3S_TOKEN=<token> K3S_NODE_NAME=<NEW_HOSTNAME> sh -
```

> This is one of the way I use **`drain`** often times to re-register k3s-agents. But there are other ways to use it as well, this is just an example to give you an overall idea of how **`drain`** command plays a vital role in evicting pods without breaking stuff.