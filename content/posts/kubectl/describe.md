---
date: '2026-07-09T12:47:35+05:30'
draft: false
title: 'Kubectl: Show Details of Specific/Group Resources'
summary: "This post explains how to get detailed description of the specific or group resources using describe command. This provides a human-readable overview of k8s resources on status, events, configs and relationships with other components. "
author: "Yashwanth Rathakrishnan"
tags:
- kubectl
- kubectl describe
cover:
    image: posts/kubectl/img/kubectl_cover.png
    alt: kubectl command
ShowToc: true
TocOpen: true 
ShowReadingTime: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
---
# Overview
The **`kubectl describe`** command is used to inspect K8s resources in detail, `describe` command provides detailed information while `get` commands provides a summarized output. It aggregates information from multiple source to give a comprehensive snapshot of a resource's lifecycle including _resource configuration, status, events, dependencies and more_. This command is particularly useful for **debugging and troubleshooting** as it highlights why a resource may not be functioning as expected.

# Main Sources for Aggregating Information
When you `kubectl describe`, Kubernetes API server dynamically queries 3 distinct data sources to build your output:

> **Sources**:
> - `etcd` database via API server.
> - `kubelet` process running on the active worker node.
> - The Kubernetesd `Event` resource database.

1. The Desired State (`etcd`)
- Pulls the information about the container images, environment variables, storage volume, definitions, resource requests/limits, and node selectors.

2. The Current Live Status
- Pulls the information about real-time diagnostics straight from the container runtime engine such as `containerd`.
- Outputs 
	- **Current status** such `running`, `waiting`, `terminated`, `pending`...
	- **IP address** allocated to the pod
	- **Last State & Exit Code**
	- Total **Restart Counts**
3. The Cluster Event Log
- Pulls information on a completely separate stream of time-stamped cluster actions related to that specific pod.
- **_[The Events](https://kubernetes.io/docs/reference/kubernetes-api/events/event-v1/)_** section at the very bottom, it tells chronological story of the resource. Example: _Successfully Pulling Image -> Created Container -> Started Container -> Unhealthy -> Killing Container_

## Output Details
The output of `kubectl describe` typically includes:
- **`Metadata`**: name, namespace, labels, annotations
- **`Spec`**: resource config, container images, ports, and environment variables
- **`Status and Conditions`**: readiness, phase, and QoS class
- **`Volumes`**: mounted storage and persistent volume claims
- **`Events`**: lifecycle events such scheduling, image pulling, and error like `ImagePullBackOff` or `ErrImagePull`

# How to Use
Print a detailed description of the resource, you may select a singly object by 
- name, 
- type, 
- name prefix, 
- label selector, and more.

```sh
kubectl describe TYPE NAME_PREFIX
```

**Common Usage**
```sh
# describe a pod
kubectl describe pod uptime-kuma-deployment-7c78854f7d-vbfm5 

# describe a node
kubectl describe node k3s-agent

# describe all nodes
kubectl describe nodes
# descibe all pods
kubectl describe pods

# describe pods by label
kubectl describe pods -l name=LABEL_NAME
```

## Best Practices
1. Use `kubectl describe` as **first step in troubleshooting** before diving into logs.
2. Combine with **label selectors** to filter efficiently.
3. For large clusters, consider chunked output to avoid overwhelming the terminal. **`--chunk-size int`** _(default: 500)_
4. Remember that namespace context is ignored if listing across all namespaces with `-A` or `--all-namespaces`.

# Example
```sh
kubectl get pods -o wide
```
**Sample Pods List**:
```sh
NAME                                       READY   STATUS    RESTARTS       AGE     IP           NODE                      NOMINATED NODE   READINESS GATES
bazarr-deployment-76b9585465-29jp2         1/1     Running   0              15h     10.42.3.20   k3s-agent-debian-laptop   <none>           <none>
filebrowser-deployment-6cb698b868-vrphs    1/1     Running   0              15h     10.42.3.16   k3s-agent-debian-laptop   <none>           <none>
forgejo-deployment-5f585676d-h5snf         1/1     Running   2 (155m ago)   4d20h   10.42.2.18   k3s-server                <none>           <none>
grafana-deployment-699fdbc48d-2kcv6        1/1     Running   2 (155m ago)   7d18h   10.42.2.7    k3s-server                <none>           <none>
jellyfin-deployment-64f97df8cb-b68k4       1/1     Running   1 (155m ago)   3d22h   10.42.2.19   k3s-server                <none>           <none>
prowlarr-deployment-7c5f76dd7f-2kqhp       1/1     Running   0              15h     10.42.3.19   k3s-agent-debian-laptop   <none>           <none>
radarr-deployment-8566c6c7b6-m5w97         1/1     Running   0              15h     10.42.3.21   k3s-agent-debian-laptop   <none>           <none>
semaphore-deployment-97cc8965f-c7pn8       1/1     Running   2 (155m ago)   7d19h   10.42.2.3    k3s-server                <none>           <none>
sonarr-deployment-769bb45458-8bvwz         1/1     Running   0              15h     10.42.3.18   k3s-agent-debian-laptop   <none>           <none>
transmission-deployment-554fdbcf5d-hr222   1/1     Running   0              15h     10.42.3.17   k3s-agent-debian-laptop   <none>           <none>
trilium-deployment-75c7ff4655-dhd42        1/1     Running   2 (155m ago)   7d19h   10.42.2.9    k3s-server                <none>           <none>
uptime-kuma-deployment-7c78854f7d-vbfm5    1/1     Running   2 (155m ago)   7d19h   10.42.2.4    k3s-server                <none>           <none>
```

Looking closely at pods list, there is a very obvious clue here:
- Forgejo,
- Grafana,
- Trilinium,
- Uptime Kuma,

all restarted exactly 153 minutes ago. Because they all restarted at the exact same time while your other pods stayed online. This is the absolute perfect scenario to use `kubectl describe`.

To inspect the pods that recently restarted, you provide the resource type `pod` followed by the exact name:
```sh
# Investigate the Grafana restart
kubectl describe pod grafana-deployment-699fdbc48d-2kcv6
```
**Output**:
```sh
kubectl describe pod grafana-deployment-699fdbc48d-2kcv6 
Name:             grafana-deployment-699fdbc48d-2kcv6
Namespace:        default
Priority:         0
Service Account:  default
Node:             k3s-server/192.168.31.11
Start Time:       Wed, 01 Jul 2026 18:57:19 +0530
Labels:           app=grafana
                  pod-template-hash=699fdbc48d
Annotations:      kubectl.kubernetes.io/restartedAt: 2026-07-01T18:47:44+05:30
Status:           Running
IP:               10.42.2.7
IPs:
  IP:           10.42.2.7
Controlled By:  ReplicaSet/grafana-deployment-699fdbc48d
Containers:
  grafana:
    Container ID:   containerd://27bb751597488860d091f054053059351f53d29e0442006ee421d2d9cdfe3bfa
    Image:          grafana/grafana-enterprise:latest
    Image ID:       docker.io/grafana/grafana-enterprise@sha256:68a7ee3dc2c726e54b2be3533a9e1ac6baaed0893334947a6378520de28a6a76
    Port:           3000/TCP (grafana-port)
    Host Port:      0/TCP (grafana-port)
    State:          Running
      Started:      Thu, 09 Jul 2026 11:09:26 +0530
    Last State:     Terminated
      Reason:       Unknown
      Exit Code:    255
      Started:      Sun, 05 Jul 2026 14:55:37 +0530
      Finished:     Thu, 09 Jul 2026 11:08:48 +0530
    Ready:          True
    Restart Count:  2
    Environment:    <none>
    Mounts:
      /var/lib/grafana from grafana-storage (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-bb9w6 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  grafana-storage:
    Type:          HostPath (bare host directory volume)
    Path:          /grafana/data
    HostPathType:  Directory
  kube-api-access-bb9w6:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              hardware-type=heavy-compute
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
```

1. **Exit Code 255**:
Look closely at the `Containers:` block under `Last State:`:
```yaml
    Last State:     Terminated
      Reason:       Unknown
      Exit Code:    255
      Started:      Sun, 05 Jul 2026 14:55:37 +0530
      Finished:     Thu, 09 Jul 2026 11:08:48 +0530
```
- **The Timeline**: The container ran smoothly for 4 days straight (from July 5th to July 9th) until it abruptly died at exactly 11:08:48 AM today. It was successfully brought back up by K3s less than a minute later at 11:09:26 AM.
- **What this means**: `Exit Code 255` is a catch-all meaning the main process inside the container abruptly stopped with an exit status out of range or the underlying service runtime cut it off without a specific signal.

2. The Empty [Event](https://kubernetes.io/docs/reference/kubernetes-api/events/event-v1/) Log

**Why is it empty?** 
Kubernetes event logs only live in memory for 1 hour by default before they are wiped. Because the crash happened roughly 2.5 hours ago, the cluster-level event history for that exact crash window has already aged out.

> Events have a limited retention time and triggers and messages may evolve with time. Event consumers should not rely on the timing of an event with a given Reason reflecting a consistent underlying trigger, or the continued existence of events with that Reason. Events should be treated as informative, best-effort, supplemental data.

**What's the Problem?**: Well, in my case there has been power outage and it came back within a minute. I guess it explain why it stopped abruptly. When a container is gracefully stopped by Kubernetes, its receives a signal to shutdown cleanly and leaves an exit code like `0`. Why my control plane lost power it didn't have the time to clean up.  That's why the container lost its connection to the processes mid-execution. When the node booted back up, `containerd` looked at what happened right before the blackout, couldn't find a clean exit signature, and flagged it as `Exit Code: 255` with `Reason: Unknown`.