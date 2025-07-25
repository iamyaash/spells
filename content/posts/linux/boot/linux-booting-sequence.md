---
date: '2025-07-25T19:33:51+05:30'
draft: false
title: 'Linux: Booting Process'
summary: "High-level explanation of how the Linux is booted."
tags:
- linux
- booting
cover:
    image: posts/linux/boot/booting-process.png
    alt: systemd-screenshot
    
params:
    author: "Yashwanth Rathakrishnan"
    ShowToc: true
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---

# Major Steps in Booting Sequence
| Stage                 | Description                                                                    |
|-----------------------|--------------------------------------------------------------------------------|
| BIOS/UEFI             | Initializes hardware components and POST to ensure system is ready to boot     |
| Bootloader (GRUB/etc) | Loads Linux kernel and optional initramfs from disk into memory                |
| Kernel                | Initializes device drivers, mounts root filesystems, and starts PID 1 process  |
| Init/Systemd          | PID 1 lauches user-space services as defined by system configuration profiles. |
| Runlevel/Target       | Configures and starts services as defined by system configuration profiles     |
| Login                 | Presents users with login prompt or graphical interface                        |


# Linux Booting Sequence
The Linux booting sequence is a systematic process with distinct stages that prepare the operating system for user interaction.

## 1. BIOS/UEFI Initialization:
It **checks whether the hardware components in your system are functional and ready to boot** the operating system. Hardware components are keyboard, mouse, monitor, storage devices and etc.

- **BIOS** (_Basic Input/Output System_)
    - It can **only use MBR** (_Master Boot Record_).
    - Using MBR **limits the disk size to 2TB**.
    - Slower booting time.
    - Less secure boot.

- **UEFI** (_Unified Extensible Firmware Interface_)
    - Uses GPT (_GUID Partition Table_)
    - Offering faster booting time.
    - Better security than BIOS.
    - Breaks the 2TB limit and allows using more disk size.
    - UEFI supports multiple bootloaders and fasters, more flexible booting. 

## 2. POST (Power-On Self Test)
POST is executed by the BIOS/UEFI firmware to verify that essential hardware components (RAM, CPU, keyboard, etc.) are functioning properly. If any issue is detected, an error is displayed or signaled using beep codes.

## 3. Bootloader Execution
After the BIOS/UEFI checks, now it needs to find and load up the bootloader software from the boot device's MBR or EFI partition. The bootloader presents boots options and loads the selected Linux kernel and an optional initial RAM disk (_initramfs_).

The common bootloaders are `GRUB2` or `LILO`. `GRUB2` is most fully features and widely used today. It can handle booting multiple operating sytems. Apart from that, it provides more features such as looks, graphical changes and some power-user specific features as well.

> The system firmware (BIOS/UEFI) checks the configured boot order and loads the bootloader (e.g., GRUB2) from the appropriate device.

> In simple terms, the bootloader locate the operating system kernel on the disk, load the kernel into memory and start the kernel

## 4. Kernel Initialization
The **Linux kernel is loaded into memory after Bootloader**, decompresses itself, initializes hardware(_via device drivers_), and mounts the root file system. 

Once the bootloader loads the kernel into memory, the kernel takes over the computer's resources and starts initializing all the background processes and services.
- First, it decompresses itself into the memory.
- Checks the hardware and loads device drivers and other kernel modules.
- Next, the kernel start the PID 1 process  (_i.e, Systemd/SysV.._) aka init process.

## 5. Init/Systemd Launch
The first user-space process started by the kernel is assigned PID 1. On modern systems, this is typically systemd, which takes over as the init system and launches other services.

## 6. Runlevel/Target Process
The `systemd` uses target configuration files to decide which mode it should be booting into, such as `multi-user.target` for text only or `graphical.target` for UI based.

# Things to Know
## Master Boot Record (MBR)
The MBR is the first sector of a hard disk or any storage device.

It stores three things:
1. Bootloader Code  (`446 Bytes`)
2. Partition Table (`64 Bytes, for upto 4 partitions`)
3. MBR Signature (`2 Bytes`)

- When a computer starts, the BIOS looks for the MBR, loads its bootloader code into memory, and uses it's partition information to find and start the operating system.
- MBR is essential for booting traditional BIOS-based systems, and the OS cannot load without it.
- However, it can only handle disks up to 2TB.
- Allows upto `4` primary partitions per disk.

### BIOS boots from MBR
- The firmware looks for the MBR, at the very first sector of the boot disk.
- The MBR contains small bootloader code and partition table.
- This code launches the full bootloader (**`GRUB2`**), which then loads the Linux kernel into memory.

## GUID Partition Table (GPT)
It was created as part of the UEFI specification, replacing the older MBR system. GPT is a modern standard for organizing partition tables on storage devices like hard drives and SSDs.
- It supports large drives than MBR; theoretically up to `9.4ZB`.
- Allows upto `128` partitions per disk.
- Stores the partition table at both the start and end of the disk for backup, improving reliability against corruption

### UEFI boots from EFI System Partition (ESP)
- UEFI looks for a special `FAT32-formatted` partition called the EFI System Partition on disks usually formatted with GPT.
- This partition contains EFI executable files like bootloaders that UEFI loads directly.