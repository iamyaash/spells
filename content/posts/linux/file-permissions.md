---
date: '2025-06-17T22:07:53+05:30'
draft: false
title: 'Linux: Fundamentals Of File Permissions And Ownership'
summary: "How to manage file permissions and ownership in Linux based operating systems."
tags:
- linux
- permissions
- ownerships
params:
    author: "Yashwanth Rathakrishnan"
    ShowCodeCopyButtons: true
    ShowReadingTime: true
    ShowToc: true
    TocOpen: true
---
# Permission Groups:
1. **Owner** - Permissions for who owns the file/directory.
2. **Group** - Permissions that applies to the group assigned to the file/directory.
3. **Others** - Permissions that all the other users have.

Each permission group gets 3 permission that is _read, write and execute_. To learn how these 3 permissions work, we have to look into an example:
Lets `ls -l` or `ll` (in Fedora based distro) to display the list of current directory.
```sh
iamyaash@fedora:~/iamyaash/spells$ ls -l
total 4
drwxr-xr-x. 1 iamyaash iamyaash  20 Jun 12 20:57 archetypes
drwxr-xr-x. 1 iamyaash iamyaash  28 Jun 12 20:57 content
-rw-r--r--. 1 iamyaash iamyaash 881 Jun 12 20:57 hugo.yaml
drwxr-xr-x. 1 iamyaash iamyaash 178 Jun 12 20:57 public
drwxr-xr-x. 1 iamyaash iamyaash  56 Jun 13 19:28 scripts
drwxr-xr-x. 1 iamyaash iamyaash  16 Jun 12 20:57 themes
```

**Directory**:
```sh
drwxr-xr-x. 1 iamyaash iamyaash  56 Jun 13 19:28 scripts
```

**File**:
```sh
-rw-r--r--. 1 iamyaash iamyaash 881 Jun 12 20:57 hugo.yaml
```

| File Type & Permissions | Number of Hard Links | Owner Name | Group Name | Size (Bytes) | Last Modified Date & Time | Name      |
|------------------------|---------------------|------------|------------|--------------|--------------------------|-----------|
| drwxr-xr-x.            | 1                   | iamyaash   | iamyaash   | 56           | Jun 13 19:28             | scripts   |

---

## Detailed Breakdown

### 1. File Type & Permissions (`drwxr-xr-x.`)

- **d**: **Directory** (type of file)
  - Other possible types:  
    - `-` = Regular file  
    - `l` = Symbolic link  
    - `c` = Character device  
    - `b` = Block device  
- **rwxr-xr-x**: **Permissions** (read, write, execute)
  - **First 3 (rwx)**: Owner (user) permissions  
    - `r` = read  
    - `w` = write  
    - `x` = execute  
  - **Next 3 (r-x)**: Group permissions  
    - `r` = read  
    - `-` = no write  
    - `x` = execute  
  - **Last 3 (r-x)**: Others (everyone else) permissions  
    - `r` = read  
    - `-` = no write  
    - `x` = execute  

### 2. Number of Hard Links (`1`)
- **Count of hard links** pointing to this file/directory.

### 3. Owner Name (`iamyaash`)
- **Username** of the file/directory owner.

### 4. Group Name (`iamyaash`)
- **Group name** that owns the file/directory.

### 5. Size (Bytes) (`56`)
- **Size** of the file/directory in bytes.  
  - (For directories, this is the size of the directory metadata, not contents.)

### 6. Last Modified Date & Time (`Jun 13 19:28`)
- **Date and time** the file/directory was last modified.

### 7. Name (`scripts`)
- **Name** of the file or directory.

---

# How to Change Permissions

## 1. Changing Ownership (both owner & group)
### `chown ownerName fileName`
We can use the command named `chown` to change just the `owner` of the the file/directory.

```sh
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ sudo chown itsyaash hugo.yaml 
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ ll
total 4
drwxr-xr-x. 1 iamyaash iamyaash  20 Jun 12 20:57 archetypes
drwxr-xr-x. 1 iamyaash iamyaash  28 Jun 12 20:57 content
-rw-r--r--. 1 itsyaash iamyaash 881 Jun 12 20:57 hugo.yaml
drwxr-xr-x. 1 iamyaash iamyaash 178 Jun 12 20:57 public
drwxr-xr-x. 1 iamyaash iamyaash  56 Jun 13 19:28 scripts
drwxr-xr-x. 1 iamyaash iamyaash  16 Jun 12 20:57 themes
```
Here the `hugo.yaml` file's owner has been changed from `iamyaash` to `itsyaash`.

### `chown ownerName:groupName fileName`
Changing the `group` name is the same as changing the owner. But, a little different while executing the command.
```sh
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ sudo chown iamyaash:wheel hugo.yaml 
[sudo] password for iamyaash: 
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ ll
total 4
drwxr-xr-x. 1 iamyaash iamyaash  20 Jun 12 20:57 archetypes
drwxr-xr-x. 1 iamyaash iamyaash  28 Jun 12 20:57 content
-rw-r--r--. 1 iamyaash wheel    881 Jun 12 20:57 hugo.yaml
drwxr-xr-x. 1 iamyaash iamyaash 178 Jun 12 20:57 public
drwxr-xr-x. 1 iamyaash iamyaash  56 Jun 13 19:28 scripts
drwxr-xr-x. 1 iamyaash iamyaash  16 Jun 12 20:57 themes
```
Here, the `group` name is changed, while it's possible change both the owner & group at the same time.

**Alternate**:
Use `chgrp` to change the group of the current file/directory:
```sh
sudo chgrp groupName fileName
```
## 2. Change Mode (`chmod`)

### Linux Scoring System
| Permissions         | Score |
| ------------------- | ----: |
| 1. Read(**`r`**)    |  4    |
| 2. Write(**`w`**)   |  2    |
| 3. Execute(**`x`**) | 1     |


### File Permission in Linux Scoring System

| File Permissions  |   First 3   |    Next 3   |   Last 3   |
| ----------------  | ----------: | ----------: | ---------: |
| **`-rw-rw-r--`**  | `-rw-`      | `rw-`       | `r--`      |
|                   | 6(`4w`+`2r`)| 6(`4w`+`2r`)| 4(`4r`)    |

#### Example:
```sh
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ ll
total 1
-rw-r--r--. 1 iamyaash iamyaash 881 Jun 12 20:57 hugo.yaml
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ sudo chmod 755 hugo.yaml 
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ ll
total 1
-rwxr-xr-x. 1 iamyaash iamyaash 881 Jun 12 20:57 hugo.yaml
```
### Common Permissions
1. `644` - File Baseline (default permission given to a file)
2. `755` - Directory Baseline (default permission given to a directory)
3. `400` - Key Pair (locking down a file/dir to only the owner, eg:aws configs)

# List of Commands
```sh
# change owner
sudo chown iamyaash fileName.ext

# change group
sudo chown iamyaash:wheel fileName.ext

# change file permission mode
sudo chmod 644 fileName.ext #file
sudo chmod 755 dirName #directory
sudo chmod 400 fileName #important configs

