---
date: '2025-06-29T16:17:54+05:30'
draft: false
title: 'Linux: Task Scheduling with systemd Timers'
summary: "Practical guide to systemd timers, covering the differences from cron, the structure of timer files, key directives, and hands-on exercises."
tags:
- linux
- systemd
- timer
- cron
cover:
    image: "posts/linux/systemd/img/systemd-screenshot.png"
    alt: systemd-screenshot

params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
    TocOpen: true
---

# Systemd Timers
A _systemd timer_ is a moderl scheduling tool that's part of the `systemd` init system used by most of the Linux distributions. Unlike `cron`, systemd timers can trigger tasks based not just on time, but also on events(_reboot,specific service starts, when a file change, etc._).

They require bot a service file(_defines what to run_) and a timer file (_defines when/how to run_). Systemd timers offer advanced features like dependency management, built-in logging, resource limits, and fine-grained control over the execution environment. 

_They also ensure that only one instance of a task runs at a time, preventing overlaps, and making them ideal for complex or critical automation scenarios._

> **Best for complex scheduling, dependency management, event-based triggers, and when you need robust logging and resource control.**

# Cron Jobs
A _cron job_ is a simple, time-based scheduler built into nearly all Unix-like operating systems. It lets you run scripts or command at specific times or intervals by editing a configuration file (_`crontab -e`_).

Cron is easy to setup and widely used for basic automation tasks like backups or log rotation, and limited logging and environment control. 

_Each job runs independently, and multiple instance of the same job can overlap if ones takes too long._

> **Best for simple, time-based tasks where portability and simplicity are the key.**

# File Structure
## .timer Filer

A `.timer` file defines when and how a service is triggered. It works in tandem with `.service` file, which defines what to run.

**Key Sections and Directive**:
- `[Unit]`: Description and dependencies
- `[Timer]`: Timing and scheduling directive.
- `[Install]`: Where to enable the timer.

### Important Directive
- **`OnBootSec`**: Run the service after a specified time interval following the system boot. (`OnBootSec=5m` runs 5 minutes after boot.)
- **`OnUnitActiveSec`**: Run the service after a specified time interval following the last activation of the unit. (`OnUnitActiveSec=5s` runs every hour after the last run).
- **`OnCalendar`**: Schedule the service to run at specific calender times(_like `cron`_; `OnCalendar=*-*-* 02:00:00`) Runs everyday at 2AM.
- **`AccuracySync`**: Allow a time window for the timer to fire (_for efficiency_; `AccuracySync=10m` timer can run anytime within 10 min window )
- **`RandomizedDelaySec`**: Add a random delay to prevent many timers from running at the same time.
- **`Persistent=`**: If `true`(_bool_), ensures the timer runs immediately at boot if it misssed its schedules time while the system was off.
- **`Unit=`**: Specify which unit to activate if the service name does not match the timer name.

### Defining Dependency
- **`WantedBy=`** or **`Requires=`** in the `[Install]` or `[Unit]` section: Specifies dependencies or when the timer should be activated.
- Dependencies between units (services/timer): You can make one unit depend on another by using `After=`, `Requires=`, or `Wants=` in the `[Unit]` section.

### Example
```timer
[Unit]
Descriptio=My Systemd Timer

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h
AccuracySec=1m
RandomizedDelay=30s

[Install]
WantedBy=timers.target
```

## `crontab` File
Cron itself does not have directives for dependencies or advanced scheduling, but the format is very simple.
### Important Crontab Fields
```sh
minute hour day-of-month month day-of-week command
```
Example:
```cron
30 2 * * * /usr/local/bin/backup.sh
```

### Defining Dependency in Cron:
- _Cron has no built-in dependency management_. Each cron job is independent. If you want ensure one job runs after another, you  can use `journalctl` logs find out what happened.

---

# Example
1. Automate daily backups of an important directory using systemd timers, similar to what many organizations or users do for data safety.
Script File Location: `/usr/local/bin/backup-docs.sh`

- Systemd File Location: `/etc/systemd/system/backup-docs.service`
```service
[Unit]
Description=Backups Docs Directory

[Service]
Type=oneshot
ExecStart=/usr/loca/bin/backup-docs.sh
User=username
```

- Timer File Location: `/usr/systemd/system/backup-docs.timer`
```timer
[Unit]
Description=Daily Backup of Docs Directory

[Timer]
OnCalendar=*-*-* 02:00:00
RandomizedDelaySec=3m
Persistent=true

[Install]
WantedBy=timers.target
```

- Enable and Start the `timer`
```sh
sudo systemctl daemon-reload
sudo systemctl enable backup-docs.timer
sudo systemctl start backup-docs.timer
```

- Verify
```sh
systemctl status backup-docs.timer
systemctl list-timers
```