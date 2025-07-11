---
date: '2025-06-21T14:50:43+05:30'
draft: false
title: 'Linux: Systemd And Service Management'
summary: "What is systemd and how it works? What are units, services, targets in systemd? Essential commands like systemctl & journalctl, and creating & managing custom services."
tags:
- linux
- systemd
cover:
    image: posts/linux/systemd/img/systemd-screenshot.png
    alt: systemd-screenshot
    
params:
    author: "Yashwanth Rathakrishnan"
    author: "Yashwanth Rathakrishnan"
    ShowToc: true
    TocOpen: true
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---

# What is `systemd`?

`systemd` is the **init system and service manager** used in most Linux distributions (Fedora, Ubuntu, Arch, etc). It is the **first process (PID 1)** that runs after the kernel boots and is _responsible for bringing up the rest of the system_. 

_It is designed to provide a robust framework for managing the system's lifecycle, starting from early boot and continuing until system shutdown_.

# Role and Functionality of `systemd`?
- ### PID 1 Process
`systemd` runs as the **first process during the boot sequence**, orchestrated by the Linux kernel. All the other user-space processes are started directly by `systemd` or it's child processes.

- ### Service Management
`systemd` manages the startup, shutdown, monitoring, and lifecycle of system services. It replaces older init systems like `SysV` init and offer backward compatibility with traditional init scripts.

- ### Parallelization
Unlike traditional init systems that starts services one second after another, systemd can start services in parallel, significantly reducing boot times.

- ### Dependency Management
`systemd` handles dependencies between services and other system resources, ensuring that services start in the correct order and only when required.

- ### Resource Management
It uses Linux control groups (_cgroups_) to track and manage system resources, providing better control and isolation of processes.

- ### Logging
`systemd` includes a **_built-in logging mechanism called `journalctl`_**, which collects and manages logs from all system services, making troubleshooting easier.

#### List of Commands

| Action                   | Command Example                       | Description / Usage                                        | Extra Commands & Tips for Beginners            |
|--------------------------|---------------------------------------|------------------------------------------------------------|------------------------------------------------|
| **Start a service**      | `sudo systemctl start `               | Starts the specified service immediately                   | `systemctl status ` (check if running)         |
| **Stop a service**       | `sudo systemctl stop `                | Stops the specified service immediately                    | `systemctl is-active ` (check if stopped)      |
| **Restart a service**    | `sudo systemctl restart `             | Restarts the specified service                             |                                                |
| **Reload a service**     | `sudo systemctl reload `              | Reloads configuration without full restart                 |                                                |
| **Enable a service**     | `sudo systemctl enable `              | Enables the service to start at boot                       | `systemctl is-enabled ` (check enabled)        |
| **Disable a service**    | `sudo systemctl disable `             | Disables the service from starting at boot                 |                                                |
| **Check service status** | `systemctl status `                   | Shows detailed status of the service                       |                                                |
| **Check if active**      | `systemctl is-active `                | Returns "active" or "inactive" for the service             |                                                |
| **Check if enabled**     | `systemctl is-enabled `               | Returns "enabled" or "disabled" for the service            |                                                |
| **Mask a service**       | `sudo systemctl mask `                | Prevents a service from starting, even manually            | `sudo systemctl unmask ` (to undo)             |
| **Show service info**    | `systemctl show `                     | Displays detailed properties of the service                | `systemctl show  -p `                          |
| **List dependencies**    | `systemctl list-dependencies `        | Lists units that depend on or are required by this service | `--before` and `--after` flags for order[1][2] |
| **List all services**    | `systemctl list-units --type=service` | Lists all active service units                             |                                                |
| **Reload systemd**       | `sudo systemctl daemon-reload`        | Reloads all unit files and updates systemd after changes   |                                                |

# What is journalctl?
`journalctl` is the primary command-line tool for viewing and managing logs collected by `systemd`'s journald service. Instead of traditional plain-text log files are created around the system, `systemd` centralizes logs in structured, binary format, making it easier to search, filter and analyze system and application events.


## 1. Viewing and Following Logs

| Command Example         | Description / Purpose                                |
|-------------------------|------------------------------------------------------|
| `journalctl`            | View all logs                                        |
| `journalctl -f`         | Follow (tail) logs in real-time                      |


## 2. Filtering Logs by Service

| Command Example                | Description / Purpose                                |
|---------------------------------|------------------------------------------------------|
| `journalctl -u `  | View logs for a specific service                     |


## 3. Filtering Logs by Time and Boot

| Command Example                      | Description / Purpose                                |
|---------------------------------------|------------------------------------------------------|
| `journalctl -n `              | Show the last N log entries                          |
| `journalctl --since ""`    | Show logs since a specific time                      |
| `journalctl -b`                       | Show logs from the current boot                      |
| `journalctl -b -1`                    | Show logs from the previous boot                     |


## 4. Filtering Logs by Priority and Content

| Command Example                | Description / Purpose                                |
|---------------------------------|------------------------------------------------------|
| `journalctl -r`                 | Show logs in reverse order (newest first)            |
| `journalctl -p `      | Filter by log priority (e.g., `-p err`, `-p info`)   |
| `journalctl -g ""`     | Search logs for a pattern                            |
| `journalctl _PID=`         | Show logs for a specific process ID                  |


## 5. Output Formatting

| Command Example         | Description / Purpose                                |
|-------------------------|------------------------------------------------------|
| `journalctl -o json`    | Output logs in JSON format                           |
| `journalctl -o cat`     | Output only the message content (no metadata)        |
| `journalctl --no-pager` | Dump logs directly to terminal (no pager)            |


## 6. Maintenance and Disk Usage

| Command Example                            | Description / Purpose                                |
|---------------------------------------------|------------------------------------------------------|
| `journalctl --disk-usage`                   | Show journal disk usage                              |
| `sudo journalctl --vacuum-time=`      | Remove logs older than specified time                |

# Units, Services & Target
## What is Units?
A **unit** is any resource that systemd can manage. Each unit is described by a configuration file(aka _unit file_) with a specific extension indicating its type.
### Common Units
- `.service`
- `.target`
- `.socket`
- `.device`
- `.mount`
- `.automount`, `.swap`, `.path`, `.timer`, `.slice`, and `.scope`

### Example
A unit file can be,
- `etc/systemd/system/example.service` (service unit), 
- `etc/systemd/system/my-mount.mount` (mount unit),
- `etc/systemd/system/daily-backup.time` (time unit)

## What is Services?

A **service** unit (`.service`) is used to manage applications or daemons running on the system. It defines how to start, stop, restart, or reload a service, and it's dependencies.

### Example

A simple service unit file for a custom script (`/etc/systemd/system/myscript.service`):
```service
[Unit]
Description= My Custom Script Service

[Service]
ExecStart=/usr/loca/bin/myscript.sh

[Install]
WantedBy=multi-user.target
```

## What is Targets?
A **target unit** (.target) is a group of units used to synchronize the system's state. Targets are used to bring the system to a specific state, such as booting to a graphical or multi-user environment.

### Common Targets
- **multi-user.target**: System is ready for multiple users, but without a graphical interface.
- **graphical.target**: System is ready for multiple users with a graphical interface.
- **rescue.target**: System is in single-user rescue mode.
### Example:
The `multi-user.target` is a standard target for non-graphical, multi-user system. When the system boots, it tries to reach this target, starting all services that are required for this state.

## Summary of Units, Services & Target

| Unit Type | Example Name       | Purpose/Example Use                                   |
|-----------|--------------------|-------------------------------------------------------|
| service   | myscript.service   | Manages a custom script or application                |
| target    | multi-user.target  | Groups services for multi-user, non-graphical boot    |
| socket    | sshd.socket        | Activates a service when a network connection arrives |
| device    | dev-sda5.device    | Manages a hardware device                             |
| mount     | mnt-data.mount     | Manages a filesystem mount point                      |
| timer     | daily-backup.timer | Schedules tasks (like cron jobs)                      |
