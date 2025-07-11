---
date: '2025-07-05T10:13:55+05:30'
draft: false
title: 'Linux Tools: Getting Started with the tar Command'
summary: 'The tar command (short for tape archive) is a foundational tool in Linux for archiving and compressing files and directories'
tags:
- linux
- tools
- tar
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
    TocOpen: true
---

# What is `tar`?
`tar` is primarily used **for combining multiple files and directories into a single archive file** (aka _tarball_), simplifying storage, backup, and transfer. It can also compress these archives to save disk space.

**Syntax**
```sh
tar <operation> [options] <archive-files> <files/directories>
```
- **operation**: The main action (eg:_create,extract,list_).
- **options**: Additional behaviours (eg: _compression,verbosity_).
- **archive-files**: Name of the archive.
- **files/directories**: What to include or extract.

## Essential `tar` Options
| Option | Purpose                       |
|--------|-------------------------------|
| `-c`   | Create a new archive          |
| `-x`   | Extract files from an archive |
| `-t`   | List contents of an archive   |
| `-f`   | Specify archive file name     |
| `-v`   | Verbose output                |
| `-z`   | Use `gzip` compression        |
| `-j`   | Use `bzip2` compression       |
| `-J`   | Use `xz` compression          |

## Practical Usage
1. Create a basic  `tar` archive:
```sh
tar -cvf archive.tar file1.txt file2.txt directory1/
```
Combine `file1.txt`, `file2.txt` and `directory1/` into a single archive named `archive.tar`.

2. Extract an archive:
```sh
tar -xvf archive.rar
```
3. List contents of an archive:
```sh
tar -tvf archive.tar
```
Displays the contents of the archive without extracting.

## Intermediate `tar` Usage

### Compression
1. Create a `gzip`-compressed archive:
```sh
tar -czvf archive.tar.gz dirName/
```
2. Create a `bzip2` compressed archive:
```sh
tar -cjvf archive.tar.bz2 dirName/
```
### Extracting With Compression
1. Extract a `gzip`-compressed archive:
```sh
tar -xzvf archive.tar.gz
```
2. Extract a `bzip2`-compressed archive:
```sh
tar -xjvf archive.tar.bz2
```
3. Extract to a specific directory:
```sh
tar -xvf archive.tar /home/iamyaash/extractLocation/
```
4. **Exclude** files when archiving:
```sh
tar -cvf archive.tar dirName/ --exclude="*log"
```
Excludes only `.log` files when archiving.
5. Extract a single file:
```sh
tar -xvf archive.tar /archiveDir/file.txt
```
>  If you want to extract only `wordpress/xmlrpc.php` from `archive.tar`, you would run the above command. This command will extract only that file, not the entire archive in the current directory.
6. Extract a single file to a specific directory using the `-C` option:
```sh
tar -xf archive.tar -C /target/directory path/to/file
```
7. Extract files matching a pattern:
```sh
tar -xvf archive.tar --wildcards "*.php"
```
## Advanced `tar`  Usage
### Append or Update Files In An Archive
1. Append a file:
```sh
tar -rvf archive.tar newFile.txt
```
2. Update only newer files:
```sh
tar -uvf archive.tar updatedFile.txt
```
### Delete Files From An Archive
```sh
tat --delete -f archive.tar unwantedFile.txt
```
### Check Archive Size
```sh
tar -czf - dirName/ | wc -c
```
> Outputs the size in Bytes.
### Verify Archive Integrity
```sh
tar -tvg archive.tar
```
> It **lists the contents** and checks for errors during listing.
### Compare Archive With File System
```sh
tar -df archive.tar dirName/
```
> Shows differences between the archive and current files.
### `xz` Compression:
```sh
tar -cJvf archive.tar dirName/
```
### Split Large Archives
While `tar` itself doesn't split files, you can combine it with `split` command:
```sh
tar -cvf - dirName/ | split -b 100M -archive_part_
```
> splits the archive into **`100MB` parts**.

> _This is really a useful method of using archives, when you archive a single sometimes it get's way over the size limit to copy to another machine. If a single file exceeds the certain size limit, the operating system won't let you make the copy/move operation. It happens in Windows as far as I know. I have once tried to copy a games which is archived into a single file, when attempted to make copy operation, the Windows shows a dialog box stating that this file exceed the size limit and the operation can't be made._


| Task                  | Command Example                                |
|-----------------------|------------------------------------------------|
| Create archive        | `tar -cvf archive.tar dir1/`                   |
| Create gzip archive   | `tar -czvf archive.tar.gz dir1/`               |
| Create bzip2 archive  | `tar -cjvf archive.tar.bz2 dir1/`              |
| Extract archive       | `tar -xvf archive.tar`                         |
| Extract gzip archive  | `tar -xzvf archive.tar.gz`                     |
| Extract bzip2 archive | `tar -xjvf archive.tar.bz2`                    |
| List archive contents | `tar -tvf archive.tar`                         |
| Exclude files         | `tar -cvf archive.tar dir1/ --exclude='*.log'` |
| Append files          | `tar -rvf archive.tar file.txt`                |
| Delete from archive   | `tar --delete -f archive.tar file.txt`         |
| Extract to directory  | `tar -xvf archive.tar -C /target/dir/`         |
