---
date: '2025-06-30T15:20:08+05:30'
draft: false
title: 'Linux Tools: Search & Filter'
summary: "Searches for patterns in text (files or streams) using regular expressions and Searches for files and directories based on name, size, date, permissions, etc."
tags:
- linux
- tools
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
---

# `grep` - Global Regular Expression Print
It basically **searches for patterns** in text(_files or streams_) using _regular expressions_.
```sh
grep [option] pattern [file..]
```

## Essential Options
| Option         | Description                                                      |
|----------------|------------------------------------------------------------------|
| `-i`           | Ignore case                                                      |
| `-r`/`-R`      | Recursive search in directories                                  |
| `-n`           | Show line number                                                 |
| `-v`           | Invert match (Shows text that **don't match**)                   |
| `-c`           | Count matching lines                                             |
| `-l`           | List filenames with match                                        |
| `-H`           | Show filename with match (_useful when grepping multiple files_) |
| `--color=auto` | Highlight matches                                                |
| `-E` / `-e`    | Use extended regex (like `egrep`)                                |
| `-F`           | Fixed string search (_no regex + faster_)                        |

## Example
```sh
grep "error" /var/log/syslog # shows text that matches "error"
grep -i "warning" *.log # case insensitive
grep -r "failed password" /var/log
grep -v "^#" /etc/ssh/ssh_config #invert match, in this case it excludes the comments
grep -c "404" access.log #show 404 line precisely
```
## Exercises
1. Find all case-insensitive matches of the worf `failed` in `/var/log/auth.log`.
```sh
grep -i failed /var/log/auth.log
```
2. Search all `.conf` files in `/etc` for lines containing `PermitRootLogin`.
```sh
grep -r PermitRootLogin /etc --include="*.conf"
```
3. List files under `/var/log` that contain the word `kernel`.
```sh
grep -rl kernel  /var/log
```
4. Show all non-comment lines from `/etc/fstab`.
```sh
grep -v "^#" /etc/fstab
```
5. Count how many times the word `sshd` appears in `/var/log/messages`.
```sh
grep -c sshd /var/log/messages
```

# `find` Locate Files Based On Attributes
It basically searches for files and directories based on name, size, date, permissions, etc. In simple terms, it searches using metadata of the files and directories rather than just using the name of the file.
```sh
find [path] [expression]
```
## Essential Options
| Option                    | Description                                                 |
|---------------------------|-------------------------------------------------------------|
| `-name "pattern"`         | Match file/directory name (_case-sensitive_)                |
| `-iname "pattern"`        | Match file/directory name  (_case-insensitive_)             |
| `-wholename "pattern"`    | Matches the whole file/directory name  (_case-insensitive_) |
| `-type f/d`               | File(`f`) or directory (`d`)                                |
| `-size [+/-]N[c/k/M/G]`   | File size                                                   |
| `-mtime [+/-N]`                | Modified exactly N days ago (`+N` older \|`-N` newer)       |
| `-newer file`             | Modified after a specific date                              |
| `-perm`                   | Permissions (eg: `644`/`u+w`)                               |
| `-user` / `-group`        | Owned by user/group                                         |
| `-exec CMD {} \;`         | Execute command on result                                   |
| `-delete`                 | Delete matching files (not recommended for beginners)       |
| `-maxdepth` / `-mindepth` | Limit directory traversal                                   |

## Example
```sh
find / -name "iamyaash"
find /etc -type f -iname "*.conf"
find /home -type f -size +100M
find /var/log -mtime -2
find /tmp -type f -user iamyaash
find . -type f -name "*.log" -exec grep -H "error" {} \;
```

## Exercises
1. Find all `.log` files modified in the last 2 days in `/var/log`.
```sh
find /var/log -type f -mtime -2 -name "*.log"
```
2. Search for files larger than `10MB` in your home directory
```sh
find /home/iamyash -type f -size +10M
```
3. Find all `.ssh` scripts and list their permissions
```sh
find . -type f -name "*.ssh" -exec ls -l {} \;
```
4. Delete all `.tmp` files in `/tmp` older than 7 days
```sh
find /tmp -type f -name "*.tmp" -mtime +7 -exec rm -rf {} \;
```
5. Combine `find` and `grep` to search for "database" in all `.conf` files under `/etc`.
```sh
find /etc -type f -name "*.conf" -exec grep "database" {} \;
```