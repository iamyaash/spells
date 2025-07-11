---
date: '2025-07-04T20:42:38+05:30'
draft: false
title: 'Linux Tools: Data Extraction & Manipulation'
summary: 'Focuses on shaping, refining, or deduplicating data using cut, sort, uniq commands.'
tags:
- linux
- tools
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowBreadCrumbs: true
    ShowToc: true
    TocOpen: true
    
---
# `cut` - Extract Section From Each Line
The `cut` command is used to **extract specific fields or character positions from each line of input**. It is especially useful for processing text files, logs, or command output where you need to isolate columns or substrings.

## Essential Options
| Option                        | Description                                      |
|-------------------------------|--------------------------------------------------|
| `-d <delimiter>`              | Specify the delimiter (default `TAB`)            |
| `-f <list>`                   | Select fields (columns), separated by delimiter  |
| `-c <list>`                   | Select character positions                       |
| `--complement`                | Show everything _except_ the selected field/char |
| `-s`                          | Suppress lines without the delimiter             |
| `--output-delimiter <string>` | Use a custom output delimiter (GNU cut)          |

## Examples
Use this sample file: `employee.txt` 
```sh
ID,Name,Department,Salary,Location
1,Alice,Engineering,85000,New York
2,Bob,Sales,65000,San Francisco
3,Charlie,HR,60000,Chicago
4,David,Engineering,90000,Boston
5,Eva,Marketing,70000,Seattle
```

1. Extracting fields by delimiter
```sh
cut -d',' -f2 emp.txt
```
2. Extract name and salary
```sh
cut -d',' -f2,4 emp.txt
```
3. Extract the first 3 characters of each line
```sh
cut -c1-3 emp.txt
```
4. Skip the header and extract "Deparment" and "Location"
```sh
cat emp.txt | cut -d',' -f3,5
```
5. Replace output delimiter with `:` instead of `,`
```sh
cut -d',' -f1,2 --output-delimiter=':' emp.txt
```
6. Display everything except the ID
```sh
cut -d ',' -f1 --complement emp.txt
```

# `sort` - Sort Lines Of Text Files
The `sort` command arranges lines in text files in **alphabetical, numerical or custom column-based** order. It's a powerful tool for _organizing data, finding duplicates, and preparing files for further processing_.

## Essential Options
| Option    | Description                                    |
|-----------|------------------------------------------------|
| `sort -n` | Numeric Sort                                   |
| `sort -r` | Reverse (_descending_) Sort                    |
| `sort -k` | Specify Sort Key (_field/column_)              |
| `sort -u` | Unique Lines (_remove duplicates_)             |
| `sort -t` | Specify Delimiter For Fields (_default:space_) |

## Examples
Use this sample file: `emp.csv`
```csv
OrderID,Customer,Amount,Date
1003,Alice,250,2025-07-01
1001,Bob,100,2025-06-29
1005,Charlie,300,2025-07-03
1002,Eva,150,2025-06-30
1004,David,100,2025-07-02
```
1. Sort by Amount (_3rd Column_) numerically
```sh
sort -t ',' -k3,3 -n emp.csv
```
We need to separate the fields in order to access the 3rd column,
- Use `-t ","` to specifiy delimiter which separates the lines with `,(comma)` as delimiter. 
- Then we specify `-k3,3` which selects the 3rd column (_because the fields are separated_)
- and finally, we can sort it numerically by using `-n`.
2. Sort by Date (_4th column_) alphabetically
```sh
sort -t ',' -k4,4 emp.csv #sort alphabetically by default
```
3. Sort by Customer Name (_2nd column_) in reverse order
```sh
sort -t ',' -k2,2 -r emp.csv
```
4. Remove duplicate lines while sorting by amount
```sh
sort -t ',' -k3,3 -u emp.csv
```
5. Sort by OrderID (_1st column_) numerically
```sh
sort -t ',' -k1,1 -n emp.csv
```

# `uniq` - Report Or Filter Repeated Lines
The `uniq` command is used to **remove duplicate adjacent lines from a file or output**. It is most effective when used after `sort`, as only consecutive duplicate lines are filtered.

## Essential Options
| Option | Description                               |
|--------|-------------------------------------------|
| `-c`   | Prefix lines by the number of occurrences |
| `-d`   | Only print duplicate lines                |
| `-u`   | Only print unique lines                   |

## Examples
Use this sample file: `hosts.txt`
```sh
server1.example.com
server2.example.com
server1.example.com
server3.example.com
server2.example.com
server2.example.com
server4.example.com
server5.example.com
server5.example.com
server5.example.com
```

1. Show unique hostnames
```sh
sort hosts.txt | uniq
```
2. Count occurrences of each hostname
```sh
sort hosts.txt | uniq -c
```
3. Show only hostnames that appear more than once
```sh
sort hosts.txt | uniq -d
```
4. Show only hostnames that appear exactly once
```sh
sort hosts.txt | uniq -u
```

# `tr` - Translate or Delete Characters
The `tr` command is used to **translate (replace), squeeze, or delete characters from standard input**. It's great for quick, in-place text transformations.

## Essential Options
| Option/Pattern      | Description                           |
|---------------------|---------------------------------------|
| `tr 'a' 'A'`        | Replace all `a` with `A`              |
| `tr 'a-z' 'A-Z'`    | Convert lowercase into uppercase      |
| `tr -d '0-9'`       | Delete all the digits                 |
| `tr -s ' '`         | Squeeze repeated spaces into one      |
| `tr -cd 'A-Za-z\n'` | Delete all except letter and newlines |

## Examples
1. Convert all lowercase letters to uppercase letters
```sh
echo "Hello Bro!" | tr 'a-z' 'A-Z'
```
2. Delete all digits from input
```sh
echo "abc123" | tr -d '0-9'
```
3. Squeeze multiple spaces into single space
```sh
echo "a     b       c" | tr -s ' '
```
4. Replace commas with tabs
```sh
echo "a,b,c" | tr ',' '\t'
```