---
date: '2026-07-08T13:21:43+05:30'
draft: false
title: 'Linux: Fundamentals of Swap Space'
summary: "Linux swap memory is a portion of disk storage used as virtual memory to supplement RAM, allowing the system to continue running when physical memory is full."
author: "Yashwanth Rathakrishnan"
tags:
- linux
- linux swap space
- linux swap file
ShowToc: true
TocOpen: true 
ShowReadingTime: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
---
# Introduction
**Swap Space** plays a vital role in managing memory on Linux for maintaining performance. When your system runs out of RAM,  it can use the swap space to keep runningg applications, but it's slower a than RAM and depends on the storage device you use on your system.

# How It Works?
When a system starts running low on RAM, the Linux operating system uses a **swap space** to prevent applications from crashing. Instead of immediately terminating processes, the kernel identifies memory pages that are inactive or least recently used and moves them from RAM to a reserved area on disk known as **Swap**.

This process is called **paging**. By freeing up RAM in this way, the system can continue running active processes smoothly. If a process later needs data access that was moved from _RAM to Swap_, it can swap out other inactive pages to make space.

**Swap Space** can be,
- Dedicated Partition
- Swap File
- Combination of Swap Partitions & Swap Files
> _`btrfs` doesn't support swap space_.

However, **swap space must not be considered a full replacement for RAM**, since swap space are located in storage devices(HDD, SSD) which have slower memory R/W speed. A heavy reliance on swap can lead to noticeable performance degradation, often referring to as **thrashing**. (where system spends more time swapping than executing tasks.)

Modern Linux systems also uses additional optimizations such as :
- **Swappiness**: A kernel parameter that controls how aggressively the system swap space.
- **`ZRAM`/`ZSwap`**: Compressed in-memory swap techniqures that reduce disk I/O and improve performance.
- **Page Cache Management**: The kernel may drop cached data before swapping, depending on memory pressure.

## Recommended Swap Space?
> In years past, the recommended amount of swap space increased linearly with the amount of RAM in the system. However, modern systems often include hundreds of gigabytes of RAM. As a consequence, recommended swap space is considered a function of system memory workload, not system memory. Checkout this [Recommended System Swap Space](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-swapspace#tb-recommended-system-swap-space).

| RAM in System | Recommended Swap Space     | Recommended Swap Space (allowing hibernation) |
|---------------|----------------------------|-----------------------------------------------|
| <= 2GB        | 2x the amount of RAM       | 3 times the amount of RAM                     |
| > 2GB - 8GB   | Equal to the amount of RAM | 2 times the amount of RAM                     |
| > 64GB        | At least 4GB               | Hibernation not recommended                   |
| > 8GB - 64GB  | At least 4GB               | 1.5 times the amount of RAM                   |

# Increase Swap Memory (Swap File)
> **Note**: This method is **_only suitable for non-btrfs_** type filesystems.
1. Check the available swap memory:
```sh
# Lists active swap devices/files
swapon --show
```
```sh
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition   8G   0B  100
```
Note: Many modern Fedora systems use zram (compressed RAM swap) by default instead of disk-based swap.
```sh
# Shows overall memory and swap usage
free -h
```
```sh
               total        used        free      shared  buff/cache   available
Mem:            15Gi       6.9Gi       1.9Gi       148Mi       6.8Gi       8.2Gi
Swap:          8.0Gi          0B       8.0Gi
```
2. Creating a swap file:
```sh
sudo fallocate -l 1G /swapfile
```
`fallocate` is fast because it allocates space without writing zeros.

```sh
# use dd if fallocate is not supported
sudo dd if=/dev/zero of=/swapfile bs=1024 count=65536
```

3. Set the right permission for the created swap file:
```sh
sudo chmod 600 /swapfile
```
This restricts access so only root can read/write the swap (required for security + recommended)

5. Making swap file:
```sh
sudo mkswap /swapfile # prepares the swapfile to be used as swap space
```

4. Make Swap Persistent:
Without this, the swap will disappear after reboot.
```sh
echo '/swapfile          swap            swap    defaults        0 0' | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
# ensures the swap file automatically enabled at boot.
```

6. Activating swap file:
```sh
sudo swapon /swapfile # activates the swapfile immediately (non-persistent)
```

7. Verify the change:
```sh
swapon --show
free -h
```
You should now see `/swapfile` listed alongside any existing swap.

> Checkout this post to know how to [create swap partition]() which is recommended on **`btrfs`** file type filesystems.