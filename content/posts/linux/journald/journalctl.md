---
date: '2025-06-22T14:15:38+05:30'
draft: false
title: 'Linux: Log Analysis and Journals'
summary: "Understanding Linux log locations, using journalctl, analyzing traditional logs, filtering and searching logs with grep, less and time filters."
tags:
- linux
- logging
- journalctl
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowToc: true
    TocOpen: true
    ShowCodeCopyButtons: true
---

# 1. Understanding Linux Logging Systems
`journalctl` is a tool to interact with `journald` which is an in-built tool in `systemd`. It helps logging easy and accessible because it was stored in binary format managed by `journald`. But, the traditional logs are stored in plain text files under `/var/log/`.

- ### `systemd` Journal
It centralizes logs in a binary format managed by `journald`, accessible via `journalctl`. Offers advanced filtering, real-time updates, and more context.
- ### Traditional Logs
Stores logs in a plain text files under `/var/logs/`. We have to use external tools like `grep`, `tail`, and `less` for analysis. It is still functional, but very old and there's no advanced filtering.

# 2. Using `journalctl` to View and Filter Logs
## `journalctl`
- Centralizes logs from the kernel, systemd, and services in a structured, searchable binary format.
- Provides advanced filtering, real-time monitoring, and boot-specific logs.
- Designed to overcome the limitations of tradition plain-text logging by offering more context and metadata.

### Subcommands and Essential Commands
| Command                         | Description                                                |
|---------------------------------|------------------------------------------------------------|
| `journalctl`                    | View all system logs (Chronological Order)                 |
| `journalctl -r`                 | View logs in reverse chronological order (newest first)    |
| `journalctl -n N`               | Show the last `N` entries                                  |
| `journalctl -k`                 | Show only kernel messages                                  |
| `journalctl -p LEVEL `          | Filter by log priority(e.g: `error` or `3`)                |
| `journalctl -u UNIT`            | Filter by `systemd` unit/service(e.g: `apache2.service`)   |
| `journalctl -f`                 | Follow logs in real time (aka `tail -f`)                   |
| `journalctl --since TIME`       | Show logs since a specific (Time) Sun Jun 22 14:44:52 2025 |
| `journalctl --until TIME`       | Show logs until a specific time                            |
| `journalctl --disk-usage `      | Show disk usage of journal logs                            |
| `journalctl --vacuum-size=SIZE` | Reduce logs size to specific amount                        |
| `journalctl _SYSTEMD_UNIT=UNIT` | Filter by `systemd` unit using field (aka `-u`)              |
| `journalct  _UID=UID`           | Filter by user ID                                          |

## Traditional Logs
- Stores traditional system logs in plain text files.
- Used for compatibility with tools and scripts.
- Allows quick access to logs for specific applications or subsystems
- Not as much flexible as `journald`

### Subcommand and Essential Commands
| Log File                             | Description                                                       |
|--------------------------------------|-------------------------------------------------------------------|
| `/var/log/message/`                  | General System Messages                                           |
| `/var/log/syslog` (Debian*)          | System Logs for Debian based distro and it's similar to `message` |
| `/var/log/auth.log`                  | Login attempts, sudo, ssh (`/var/log/secure` on RHEL/Fedora)      |
| `/var/log/kern.log`                  | Kernel Messages                                                   |
| `/var/log/dmesg`                     | Boot-time Kernel Messages                                         |
| `/var/log/httpd/`, `/var/log/nginx/` | Web Server Logs                                                   |

## Example
1. View all system logs
```sh
journalctl
```

2. View logs in reverse order
```sh
journalctl -r
```

3. Show only kernel messages
```sh
journalctl -k
```

4. View logs from the current boot
```sh
journalctl -b
```

5. Filter by priority (Error and Above)
```sh
journalctl -p err
# other flags: emerg,alert,crit,warning,notice,info,debugs
```

6. Filter by service
```sh
journalctl -u ssh.service
```

7. Show last 20 log entries
```sh
journalctl -n 20
```

8. Output in SON format
```sh
journalctl -o json-pretty
```

9. Monitor logs in real-time
```sh
journalctl -f
```

10. Investigate failed login attempts
```sh
journalctl | grep -i "failed password"
journalctl -u ssh.service | grep -i "failed password" #show failed login attempts for specific service
```

11. Track system errors over time and period
```sh
journalctl  --since "2025-06-24 08:08:08" --until "2025-06-24 17:17:17" -p err
```
> Mostly useful for post-analysis

12. View logs for a specific user
```sh
journalctl _UID=$(id -u)
```

13. Export logs for analysis
```sh
journalctl --since yesterday > textFile_logs.txt
```

14. Filter by Process ID
```sh
journalctl _PID=<pid>
```