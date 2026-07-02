---
date: '2026-07-02T11:28:42+05:30'
draft: false
title: 'K3s: Renaming the Nodes'
author: "Yashwanth Rathakrishnan"
ShowToc: true
TocOpen: true 
ShowReadingTime: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
---

# TLDR
Changing **`/etc/hosts`** or even the system hostname does not always rename an already-joined `k3s` node in place; Kubernetes node objects are tied to the name used at registration time. SO if the agent was installed when the hostname was `debian`, the cluster will keep showing `debian` until that node rejoins as `k3s-agent`.

## Standard Procedure To Change Node Name
On the machine you want to change the name, stop the agent and reinstall or restart it with the new node name explicity set as `k3s-agent`.

**On the worker node**: (We're changing name of your agent only)
1. Stop the `k3s` service:
```sh
sudo systemctl stop k3s-agent
```
2. Use `drain` command to evict the pods and other services:
```sh
sudo kubectl drain debian --ignore-daemonsets --delete-emptydir-data
```
3. Change the `<OLD_HOSTNAME>` using `hostnamectl`:
```sh
sudo hostnamectl set-hostname k3s-agent
```
4. Update the `<OLD_HOSTNAME>` from `/etc/hosts` to `k3s-agent`:
```sh
sudoedit /etc/hosts
```
5. Delete the `debian` node (**on Control Plane**):
```sh
kubectl delete node debian
```

## Reinstall `k3s-agent`
On the workder node, reinstall or re-run the agent:
```sh
# copythe node-token
sudo cat /var/lib/rancher/k3s/server/node-token
```
```sh
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.31.11:6443 K3S_TOKEN=<token> K3S_NODE_NAME=<NEW_HOSTNAME> sh -
```
> Enter the updated hostname in `<NEW_HOSTNAME>


On the control place, check the list of node:
```sh
kubectl get nodes
```

---

**What to do**:
If you want the old worker back in service, simply uncordon it:
```sh
kubectl uncordon debian
```
> That removes the unschedulable state and lets pods land there again.

In my case, all the existing pods are pointing to `hardware-type=media-server`, so I just have to update the new worker label:
```sh
kubectl label node k3s-agent hardware-type=media-server
```
```sh
kubectl get pods -w
```
> Kubernetes uses labels and selectors exactly for this kind of placement control, and a pod with a nodeSelector will only schedule onto nodes that match it.

**What to Expect**:
Once the node label matches, the Pending pods should begin scheduling if there are no other blockers like PVCs, taints, or resource limits.

## Caution
Do not remove labels from other nodes unless you mean to shift workloads away from them. Adding the label to the new node is usually safer than changing every manifest.
