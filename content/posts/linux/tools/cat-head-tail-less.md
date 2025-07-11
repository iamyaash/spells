---
date: '2025-07-04T21:40:45+05:30'
draft: false
title: 'Linux Tools: Basic File Viewing & Handling'
summary: 'Read and preview file contents using commands like cat, head, tail, less.'
tags:
- linux
- tools
params:
    author: "Yashwanth Rathakrishnan"
    author: "Yashwanth Rathakrishnan"
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowBreadCrumbs: true
    ShowToc: true
    TocOpen: true
    
---

# `cat` - Concatenate And Display File Contents
The `cat` command is used to **print the content of one or more files to the standard output**(_terminal_). It can also be used to combine multiple files into one.

## Essential Options
| Options                              | Description                                 |
|--------------------------------------|---------------------------------------------|
| `cat file.txt`                       | Display the contents of a file.             |
| `cat file1.txt file2.txt`            | Display contents of multiple files in order |
| `cat file1.txt file2.txt > both.txt` | Combine both files into a new file          |
| `cat -n file.txt`                    | Number all output lines                     |
| `cat -b file.txt`                    | Number non-blank lines only                 |
| `cat -s file.txt`                    | Squeeze multiple blank lines                |
| `cat -E file.txt`                    | Show `$` at end each line                   |

## Example
Use this sample file: `notes.txt`
```sh
Line 1: This is the first line.

Line 2: This line has trailing spaces.    
     
Line 3: This line is followed by multiple blank lines.


Line 4: The end of the sample file.    
```

1. Number all lines in `notes.txt`
```sh
cat -n notes.txt
```
2. Number only the non-blank `notes.txt` file
```sh
cat -b notes.txt
```
3. You have a file `notes.txt` with many consecutive blank lines. Display it with all multiple blank lines reduced to a single blank line.
```sh
cat -s notes.txt
```
4. How do you know where the lines ends?
```sh
cat -E notes.txt
```

# `head` | `tail` - Show The First/Last Lines Of A File
The `head` command displays the first **`N`** lines of a file (_default is 10_). The `tail` command displays the last **`N`** lines of a file (_default is 10_).

## Example
```sh
head file.txt               # first 10 lines
head -n 8 file.txt         # first 8 lines
head -n 2 file.txt          # Only the first 2 lines
```
```sh
tails file.txt               # last 10 lines
tails -n 8 file.txt         # last 8 lines
tails -n 2 file.txt          # Only the last 2 lines
```

> **Note**: `tail -f`, this flag is used to show the text files's live update. Meaning, it follows the files as it grows. AKA, that's how logging work, you see the last update (_recently happened ones_).

# `less` - Interactive Pager For Viewing Large Files
the `less` command allows you to **view and scroll through large files interactively**, making it easier to navigate logs, reports, or any lengthy text files **withtout loading the entire file into memory**.

## Essential Options
| Key        | Description                  |
|------------|------------------------------|
| `/pattern` | Search forward for `pattern` |
| `n`/`N`    | Goto next/prev search match  |
| `b`        | Page up                      |
| `f`        | Page down                    |

## Examples
1. View `notes.txt` and search for "yum"
```sh
less notes.txt
# Press -> /yum -> Enter Button
```
2. How to page up and down while inside the `less` view
- `b` = Page Up
- `f` = Page Down
3. How to go to next/prev search matches
- `n` = Next
- `N` = Previous