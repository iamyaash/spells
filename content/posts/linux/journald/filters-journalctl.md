---
date: '2025-06-30T10:38:19+05:30'
draft: false
title: 'Linux: Advanced Filtering and Analyzing System Logs with journalctl'
sumarry: "How to journalctl filters to narrow down the log entries for precise logging."
tags:
- linux
- logging
- journalctl
- filter
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
---

# What is `journalctl` Filters?

You can use filters with `journalctl` to narrow down and control which log entries are displayed. `journalctl` supports a wide range of filtering options, both by structured fields and by command-line flags.
- Structured Fields: `SYSLOG_IDENTIFIER`, `_SYSTEMD_UNIT`, `_UID`, etc
- Command-Line Fields: `--since`, `--until`, `-u`, `-p`, `--grep`, etc

## Common `journalctl` Filters
| Filter Type     | Example Command                     | Description                             |
|-----------------|-------------------------------------|-----------------------------------------|
| By Time         | `journalctl --since "8 hours ago"`  | Shows logs since a specific time        |
| By Service/Unit | `journalctl -u nginx.server`        | Show logs for a specific server/unit    |
| By Priority     | `journalctl -p warning`             | Show logs at/above a certain severity   |
| By Field        | `journalctl SYSLOG_IDENTIFIER=sudo` | Show logs where a field matches a value |
| By Boot         | `journalctl -b -1`                  | Shows logs from the previous boot       |
| By Keyword      | `journalctl --grep "error"`         | Shows logs containing a keyword         |

### Advanced `journalctl` Filters
| Filter Type             | Example Command                               | Description                                                    |
|-------------------------|-----------------------------------------------|----------------------------------------------------------------|
| By User ID              | `journalctl _UID=user_id`                     | Filter logs by the user ID of the process that generated them  |
| By Group ID             | `journalctl _GID=group_id`                    | Filter logs by the group ID of the process that generated them |
| By Process ID           | `journalctl _PID=process_id`                  | Filter logs by process ID                                      |
| By Process name         | `journalctl _COMM=nginx`                      | Filter by process name (eg. `_COMM=nginx`)                     |
| By Hostname             | `journalctl _HOSTNAME=hostname`               | Filter logs by hostname                                        |
| By Executable Path      | `journalctl _EXE=exe_path`                    | Filter logs by executable path (eg: `/usr/local/bin/hugo`)     |
| By Boot Session         | `journalctl _BOOT_ID=boot_id`                 | Filter logs by a specific boot session                         |
| By Audit Session        | `journalctl _AUDIT_SESSION=session_id`        | Filter logs by audit session ID                                |
| By Syslog Facility Code | `journalctl _SYSLOG_FACILITY=facility_number` | Filter  by syslog facility code                                |

**Alternatively**, you can find the available filters in `journalctl` by using:
```sh
journalctl --fields
```

## Example
1. View logs since yesterday
2. Filter logs for a specific service
3. Show only error messages
4. Filter by time range
5. Show logs from the previous boot
6. Filter logs by user
7. Search for a keyboard
8. Limit the number of output lines