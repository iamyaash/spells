---
date: '2025-06-30T16:00:03+05:30'
draft: false
title: 'Linux Tools: Transform & Edit'
summary: 'Modify or reformat text streams or files; Command: awk & sed'
tags:
- linux
- tools
- transform
params:
    author: "Yashwanth Rathakrishnan"
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
---

# `sed` - Stream Editor
It read line by line and allows you to **substitute, delete or transform text** streams.
```sh
sed [options] 'command' file
```

## Essential Commands & Options
| Command                   | Description                                       |
|---------------------------|---------------------------------------------------|
| `s/pattern/replacement`   | Substitute pattern with replacement (first match) |
| `s/pattern/replacement/g` | Substitute all matches in line                    |
| `d`                       | Delete line                                       |
| `p`                       | Print line                                        |
| `-n`                      | Suppress automatic printing                       |
| `-i`                      | Edit file in place                                |

## Example
```sh
sed 's/decline/accept' status.txt # replace "decline" with "accept"
sed 's/decline/accept/g' status.txt # replace all "decline" with "accept"
sed '/^#/d' code.py #deletes all the comments
sed -n '/error/p` code.py' #print lines that only contains 'error'
```

## Exercises
1. In `server.conf`, replace all occurences of `localhost` with `127.0.0.1`, and save changes in place.
```sh
sed -i 's/localhost/127.0.0.1/g' server.conf #edits the file in place
```
2. In `logfile.txt`, delete all lines that start with `#`.
```sh
sed -i '/^#/d' logfile.txt
```
3. In `users.txt`, print only lines that contain the word `admin`.
```sh 
sed -n '/admin/p' users.txt #-n suppresses default output
```
4. In `data.txt`, add the string `"END"` to the end of every line.
```sh
sed 's/$/"END"/' data.txt
```
5. In `report.txt`, replace the first occurence of `ERROR` with `WARNING` in each line, but only print lines where substitution happened.
```sh
sed -n 's/ERROR/WARNING/p' report.txt
```

# `awk` - Text  And Field Processing
`awk` processes text line by line and splits each into fields(_columns_). Great for reports, CSVs, logs.
```sh
awk 'pattern { action }' file
```

## Built-In Variables
| Variable      | Descriptio                |
|---------------|---------------------------|
| `$0`          | Entire Line               |
| `$1`, `$2`... | First, second field, etc. |
| `NF`          | Number of fields          |
| `NR`          | Line number               |

## Example
```sh
awk '{print $1}' file.txt #print only the first line
awk -F ':' '{print $1}' /etc/password #print usernames 
awk '$3 > 50' data.txt #print lines where third field > 50
awk '{sum += 2} END {print sum}' prices.csv #sum of 2nd field
awk '/error/' log.txt #print lines containing 'error'
```

## Exercises
1. In `report.csv`(_comma-separated_), print only the first and third columns.
```sh
awk -F, '{print $1 "," $3}' report.csv
```
2. In `sales.txt`(_space-separated_), print all lines where the second field (column) is greater than 500.
```sh
awk '$2 > 500' sales.txt
```
3. In `scores.txt`, calculate the average of values in the third column and print the result.
```sh
awk '{sum += $3; count++} END {print sum/count}' scores.txt
```
4. In `/etc/passwd`, print usernames (first field) and their default shells (last field)
```sh
awk -F: '{print $1, $NF}' /etc/passwd
```
5. In `data.csv`, print lines where the first field equals `"FAILED"`
```sh
awk -F, '$1 == "\"FAILED\""' data.csv
```
