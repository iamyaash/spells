---
date: '2025-06-26T20:37:51+05:30'
draft: false
title: 'Linux: How To Mount And Un-Mount Permanently/Temporarily'
summary: "Know how to mount and unmount storage effectively for temporary and permanent storage."
tags:
- linux
- storage
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---

# Permanently Mounting The Disk
1. Find the UUID of the Device:
```sh
lsblk -f #displays the UUID
```
```sh
sudo blkid #displays the UUID
```

2. Create a Mount Point:
```sh
sudo mkdir /mnt/permanent-mount
```

3. Edit the `/etc/fstab`:
```sh
sudo nvim /etc/fstab
```
Add this line at the bottom:
```sh
UUID=your-uuid-here  /mnt/permanent-storage  ext4  defaults  0  2
```

- Replace `your-uuid-here with` the actual UUID from step 1.
- Replace `/mnt/permanent-storage` with your mount point.
- Replace `ext4` with your filesystem type if different.
- `defaults` are standard mount options.
- `0` means the partition will not be backed up with the dump utility.
- `2` means the partition will be checked by fsck after the root filesystem.

4. Test the Mount Before Rebooting:
```sh
sudo mount -a
```

# Temporarily Mounting The Disk
1. Create a Mount Point and Mount the Disk Here:
```sh
sudo mkdir /mnt/temp-storage #make sure to create directory and it can be created and mounted anywhere
sudo mount /dev/sda1 /mnt/temp-storage 
```
> **Note**: Never unplug/remove the device without un-mounting it from the system.
```sh
sudo umount /mnt/temp-storage
```
