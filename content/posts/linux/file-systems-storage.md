---
date: '2025-06-18T16:12:05+05:30'
draft: false
title: 'Linux: File Systems And Storage'
summary: 'How to manage file systems and storage in Linux operating systems.'
tags:
- linux
- file-systems
- disk-storage
params:
    author: "Yashwanth Rathakrishnan" 
    ShowCodeCopyButtons: true
    ShowReadingTime: true
    ShowToc: true
    TocOpen: true
---

# 1. Understanding File Systems
## What is a File System?

A file system controls _how data is stored and retrived_. Without a file system, the OS wouldn't know _where a file starts or ends_.

### Common Linux File Systems
| File System | Description                                        |
| ----------- | -------------------------------------------------- |
| `ext4`      | Default for many Linux distros; journaling support |
| `xfs`       | High-performance; good for large files             |
| `btrfs`     | Copy-on-write, snapshots, RAID built-in            |
| `vfat`      | Compatible with Windows, for USB drives            |
| `ntfs`      | Windows file system; needs special driver in Linux |

# 2.Listing Disks and Paritions

This displays all disks and partitions in a tree-like format, showing relationships between devices and their mount points.


| Command Example                  | What it does                                      |
|----------------------------------|---------------------------------------------------|
| `lsblk`                          | List all block devices (tree format)              |
| `lsblk -a`                       | Include empty devices                             |
| `lsblk -f`                       | Show filesystem info (type, label, UUID)          |
| `lsblk -b`                       | Show sizes in bytes                               |
| `lsblk -l`                       | Output as a list (not tree)                       |
| `lsblk --output NAME,SIZE,TYPE`  | Show only specific columns                        |

**Example Output**:
```sh
iamyaash@fedora:~/ $ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
zram0       251:0    0     8G  0 disk [SWAP]
nvme0n1     259:0    0 476.9G  0 disk 
├─nvme0n1p1 259:1    0   100M  0 part /boot/efi
├─nvme0n1p2 259:2    0    16M  0 part 
├─nvme0n1p3 259:3    0 174.7G  0 part 
├─nvme0n1p4 259:4    0     1G  0 part 
├─nvme0n1p5 259:5    0     1G  0 part /boot
└─nvme0n1p6 259:6    0 300.1G  0 part /home
                                      /
```

`nvme0n1` is your disk and `nvme0n1p1`...`nvme0n1p6` are partitions of a single disk.

# 3. Checking Disk Usage
## `df` (Disk Free)
The `df` (disk free) command is used to **display information about the available and used disk space on all mounted filesystems**.

Shows mounted file systems in human readable output and their usage:
```sh
df -h
```
**Example Output**:
```sh
iamyaash@fedora:~ $ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme0n1p6  301G   38G  262G  13% /
devtmpfs        4.0M     0  4.0M   0% /dev
tmpfs           7.6G   32K  7.6G   1% /dev/shm
efivarfs        128K   46K   78K  38% /sys/firmware/efi/efivars
tmpfs           3.1G  2.2M  3.1G   1% /run
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs           7.6G  2.9M  7.6G   1% /tmp
/dev/nvme0n1p6  301G   38G  262G  13% /home
/dev/nvme0n1p5  974M  474M  433M  53% /boot
/dev/nvme0n1p1   96M   47M   50M  49% /boot/efi
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
tmpfs           1.6G  3.8M  1.5G   1% /run/user/1000
```

### List of `df` Commands

| Command Example                | What it does                                             |
|-------------------------------|---------------------------------------------------------|
| `df`                          | Shows disk space for all mounted filesystems            |
| `df -h`                       | Human-readable output (KB, MB, GB)                      |
| `df -Th`                      | Human-readable with filesystem type                     |
| `df /home/user`               | Filesystem info for `/home/user`                        |
| `df -i`                       | Shows inode usage                                       |
| `df -x tmpfs`                 | Excludes `tmpfs` filesystems                            |
| `df -Tt ext4`                 | Only shows `ext4` filesystems                           |
| `df --output=source,avail,pcent` | Custom columns (filesystem, available, use%)         |
| `df -aTh`                     | All filesystems, with type and human-readable           |

> **Note:** The `df` command shows information about the filesystem’s available and used space, not the size or usage of individual files. If you use `df filename.ext`, it will display which filesystem contains the file and how much space is available on that filesystem, but it never shows properties or the actual size of the file itself.

## `du` (Disk Usage)
The `du` (disk usage) command is a fundamental Linux tool for checking how much space files and directories occupy.

```sh
#top space-consuming directories
#folder-by-folder view
du -sh * 
# use .(dot), *(asterisk), (~)tilde... as exercise
```
```sh
#output
iamyaash@fedora:~$ du -sh *
4.0K    Desktop
208M    Documents
2.5G    Downloads
660M    Games
3.1G    go
238M    KDE Vaults
0       Music
134M    Pictures
4.4G    Projects
0       Public
4.0K    Scripts
0       Templates
0       Videos
```

### List of `du` Commands
| Command                           | What it does                                      |
|-----------------------------------|---------------------------------------------------|
| `du`                              | Usage of current directory                        |
| `du /home/user`                   | Usage of `/home/user`                             |
| `du -h /home/user`                | Usage in human-readable format                    |
| `du -sh /home/user`               | Total usage of `/home/user`                       |
| `du -ah /home/user`               | All files/dirs (including hidden) in `/home/user` |
| `du -c /home/user`                | Total for all listed directories                  |
| `du -d 1 /home/user`              | First-level subdirectories only                   |
| `du --exclude="*.log" /home/user` | Exclude `.log` files                              |
| `du -BM directory_name`           | Displays the size in megabytes(MB)                |
| `du -h file.txt`                  | Shows the size of a single file                   |
| `du -h /home/user \|  sort -h`    | Pipe to `sort` for sorted results                 |

# 4. Mounting and Unmounting Drives

**Mounting** connects a storage device (like a hard drive partition) to a directory in Linux so you can access its contents.

**Example:**
```bash
sudo mount /dev/nvme0n1p6 /mnt
```
This makes `/dev/nvme0n1p6` available at `/mnt`.  
You can use any empty directory instead of `/mnt`.

**Unmounting** safely removes access:
```bash
sudo umount /mnt
```
**Tip:** Always unmount before removing the device!

# 5. Creating File Systems
To format a partition with a file system:

**ext4**:
```sh
sudo mkfs.ext4 /dev/nvme0n1p6
```
**xfs**:
```sh
sudo mkfs.xfs /dev/nvme0n1p6
```
> Obviously, it's gonna **erase** all the data on the partition.


# 6. Mount On Boot Using `/etc/fstab`
To mount partitions automatically at boot: **`/etc/fstab`**

The `/etc/fstab` file is a configuration file that tells your Linux system which partitions to mount automatically at boot, where to mount them, and with what options. Each line in the file describes one filesystem and its mounting details.


### Format of an `/etc/fstab` Entry

Each line has six fields, separated by spaces or tabs:

```
<device> <mount point> <filesystem type> <options> <dump> <pass>
```

- **Device:** The storage device (e.g., `/dev/sda1`, `UUID=...`, or `LABEL=...`)
- **Mount point:** Directory where the device will be mounted (e.g., `/mnt/data`)
- **Filesystem type:** Type of filesystem (e.g., `ext4`, `ntfs`, `xfs`)
- **Options:** Mount options (e.g., `defaults`, `ro`, `noatime`)
- **Dump:** Backup flag (use `0` if you don’t use the `dump` tool)
- **Pass:** Filesystem check order (use `0` to disable, `1` for root, `2` for others)

---

### **Example Entry**

Suppose you want to automatically mount an ext4 partition with UUID `1234-5678` to `/mnt/data` at boot. Add this line to `/etc/fstab`:

```
UUID=1234-5678 /mnt/data ext4 defaults 0 2
```

> **Note**: Always use `UUID` or `LABEL` instead of `/dev/sdXY` to avoid issues if device names change. You can find the UUID of your partitions with **`lsblk -f` or `blkid`**.

# 7. Checking Disk Health
It needs `smartmontools`, which is installed on most of the Linux distros.
```sh
sudo smartctl -a /dev/nvme0n1p6
```

# List of Commands
| Command        | Purpose                      |
| -------------- | ---------------------------- |
| `lsblk`        | List block devices           |
| `df -h`        | Disk space usage             |
| `mount/umount` | Mount and unmount partitions |
| `mkfs.ext4`    | Format with ext4             |
| `lsblk -f`     | Show FS type, UUID           |
| `blkid`        | Show UUID and label          |
| `/etc/fstab`   | Persistent mount config      |
| `du -sh *`     | Directory sizes              |
