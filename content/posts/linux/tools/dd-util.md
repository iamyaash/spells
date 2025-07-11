---
date: '2025-06-22T22:09:10+05:30'
draft: false
title: 'Linux Tools: dd Utility Tool'
summary: "dd is a Linux tool, and it widely used for Linux system administration and is essential for many low-level tasks involving disks, partitions, and files at the block level."
tags:
- linux
- tools
params:
    author: "Yashwanth Rathakrishnan"
    ShowCodeCopyButtons: true
---
# What is `dd`?
The `dd` command is a powerful utility in Linux used for copying and converting data at the block level, often employed for tasks like creating disk images, cloning disks, securely wiping data, and more.

## Essential Commands and Subcommands
**Note**: `dd` command uses **operands** that how data is read, written, or converted.

| Option    | Description                                                  |
|-----------|--------------------------------------------------------------|
| `if=`     | Input file (source)                                          |
| `of=`     | Output file (destination)                                    |
| `bs=`     | Block size for reading/writing(eg:`1M` for 1 megabytes)      |
| `count=`  | Number of blocks to coyp                                     |
| `skip=`   | Skip a specified number of blocks at the start of the input  |
| `seek=`   | Skip a specified number of blocks at the start of the output |
| `status=` | Control progress display(`progres`, `noxfer`, `none`)        |
| `conv=`   | Apply data conversions (eg: `sync`, `noerror`, `notrunc`)    |
| `iflag=`  | Input flags (eg: `direct`, `fullblock`)                      |
| `oflag=`  | Output flags (eg: `direct`, `sync`)                          |

## Exercises

1. Create a file filled with zeros:
```sh
dd if=/dev/zero of=file.txt bs=1M count=100
```
2. Copy a disk partition to a file:
```sh
dd if=/dev/sda1 of=backup.img bs=4M
```
3. Restore a disk image to a partition:
```sh
dd if=backup.img of=/dev/sda1 bs=4M
```
4. Create a bootable USB drive:
```sh
dd if=ubuntu.iso of=/dev/sdb bs=4M status=progresser
```
5. Copy only part of a file:
```sh
dd if=/dev/zero of=largefile.img bs=1M count=10 #create a file with zeros
dd if=largefile.img of=partfile.img bs=1M count=1 #let copy part of the file for 1mb
```
6. Wipe a File(Overwrite with zeros/randomly):
```sh
dd if=/dev/zero of=partfile.img bs=1M
#keep on filling zero until it reaches the original size of the file
```
```sh
dd if=/dev/urandom of=partfile.img bs=1M
#keeps filling random data until it reaches the original size of the file
```
7. Backup the Master Boot Record (MBR)
```sh
sudo dd if=/dev/sda of=mbr_backup.img bs=512 count=1
```
8. Restore the Master Boot Record from Backup
```sh
sudo dd if=mbr_backup.img of=/dev/sda bs=512 count=1
```
9. Monitor Progress of a Large Copy
```sh
dd if=largefile.img of=largefile_copy.img bs=1M status=progress
```
