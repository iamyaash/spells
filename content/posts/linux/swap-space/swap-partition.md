---
date: '2026-07-08T15:29:31+05:30'
draft: true
title: 'Linux: Swap Partition'
author: "Yashwanth Rathakrishnan"
tags:
- linux
- linux swap space
- linux swap partition
ShowToc: true
TocOpen: true 
ShowReadingTime: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
---
## Swap Partition Method
1. Create the LVM2 logical volume of size 2GB:
```sh
lvcreate VolGroup00 -n LogVol02 -L 2G
```
- `-L 2G` sets the size
- `-n LogVol02` logical volume name
- `VolGroup00` volume group name `vgs`

2. Format the new swap space:
```sh
sudo mkswap -L swap_lvm /dev/VolGroup00/LogVol02
```
Writes swap metadata so the kernel recognizes it as usable swap space.

3. Add the following entry to the `/etc/fstab` file:
```sh
/dev/VolGroup00/LogVol02   none     swap    defaults     0 0
```
Use `none` as the mount point for swap

Also use you use UUID for reliability:
```sh
blkid /dev/VolGroup00/LogVol02
```
```sh
UUID=xxxx-xxxx   none     swap    defaults     0 0
```

4. Regenerate mount units so that your system registers the new configuration:
```sh
systemctl daemon-reload
```


5. Activate swap on the logical volume:
```sh
swapon -v /dev/VolGroup00/LogVol02
#or
sudo swapon -a # activates all entries from fstab
```

6. Verify
```sh
cat /proc/swaps
free -h
```