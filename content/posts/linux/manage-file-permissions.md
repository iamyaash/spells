---
date: '2025-06-27T20:16:49+05:30'
draft: false
title: 'Linux: Manage File Permissions'
summary: "This guide explains how to use Linux commands to manage file permissions, ownership and special permissions. Commands: chmod, chown, and chgrp."
tags:
- linux
- permissions
- ownerships
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowToc: true
    OpenToc: true
    ShowCodeCopyButtons: true
---

# Permissions and Ownership:
- Control who can `read`, `write` or `execute` files and directories.
- Manage `user` and `group` ownership to restric or grant access to resources.
- More importantly, secure sensitive data and maintain system integrity.

## Change Mode (`chmod`)
`chmod` is used to modify the `read`, `write` and `execute` permissions of files and directories for the _owner, group and others_.

```sh
chmod [options] [mode] [file/directory]
```
There are two modes to pass the permissions:
- **Numeric**: `chmod 755 file`
- **Symbolic**: `chmod u+x file`

> **Note**: read=4, write=2, & execute=1; We can enter numbers in octal format for changing permissions.

## Change Owner (`chown`)
`chown` is used to change the `owner` and/or `group` of a file or directory.
```sh
chown [options] [owner][:group] [file/directory]
```
> **Note**: We can change the group and owner by using `chmod ownerName:groupName` and can change just the group by using `chmod :groupName`.

## Change Group (`chgrp`)
`chgrp` is used to change the group ownership of a file or directory.
```sh
sudo chgrp [options] [group] [file/directory]
```
_We don't actually need this command in most cases, we easily do the same thing by using `chown`._

### Subcommands/Flags For chmod, chown & chgrp
- `-R`: Recursively change permissions for directories and their contents.
- `-v`: Verbose output.
- `-c`: Like verbose, but only shows files that were changes.
- `-f`: Suppress most error messages.
- `--reference=RFILE`: Set permissions to match those of a reference file.

## Access Control List
An **Access Control List (ACL)** is a list of permissions or rules that specify which user or systems are granted or denied access to a particular object or system resource, such as _files, directories, or network traffic_.

ACLs are fundamental for security and access management in operating systems, allowing administrators to control who can read, write and execute or delete resources.

### Essential Command
For **filesystems**, the command to view or 
```sh
getfacl
```
To set ACL is:
```sh
setfacl
```

### Subcommand (Options/Flags)
- **getfacl**
    - `-a` or `--access`: Display the file access control list.
    - `-d` or `--default`: Diplay the default ACL for directories
    - `-R` or `--recursive`: Apply recursively to all files and directories.
- **setfacl**
    - `-m` or `--modify`: Modify an existing ACL.
    - `-x` or `--remove`: Remove an ACL entry.
    - `-b` or `--remove-all`: Remove all extended ACL entries.
    - `-k` or `--remove-default`: Remove the default ACL.
    - `-R` or `--recursive`: Apply recursively.

### Example
1. Viewing ACLs on a File
```sh
getfacl file.ext
```
2. Setting an ACL on File
```sh
setfacl -m u:<username>:rwx file.ext #-m modify
```
3. Setting a default ACL on a Directory
```sh
setfacl -d -m u:<username>:rwx file.ext
```
4. Removing an ACL Entry
```sh
setfacl -x u:username /path/to/file
```
---

## Special Permission (Must Know!!)
Each permission is assigned a numberical value; `read(4)`, `write(2)`, `execute(1)`. So, when you enter the command `ls -l` and see the output beside the files/directories. 

You will see something like this value, `drwxrw-r--`. This means, `761` in octal. `d` means directory. If it's a file, it shows `-` hyphen instead.

1. **Sticky Bit**:

When set on a directory, only the owner of a file (or `root`) can delete or rename files within that directory, even if others have `write` permission.

2. **Set Group ID (`setgid`)**:

For directories, _files/directories_ created within the directory will inherit the `group` ownership of the parent directory. For executable files, they run with the `group` permissions of the file's group.

3. **Set User ID (`setuid`)**:

For executable files, they run with the permissions of the file's owner(often `root`).

### Symbolic Notation of Special Permissions
**Sticky Bit**:
```sh
chmod +t directory
```

**Set Group ID (`setgid`)**:
```sh
chmod g+s dir/file
```

**Set User ID (`setuid`)**:
```sh
chmod u+s dir/file
```

### Octal Notation of Special Permissions
- **Sticky Bit**: **`1`** (`chmod 1777 directory`)
- **setgid**: **`2`** (`chmod 2777 directory`)
- **setuid**: **`4`** (`chmod 4777 directory`)

# Summary Table
| Permission | Symbolic Notation | Octal Notation |
|------------|-------------------|----------------|
| Sticky Bit | `chmod +t`        | `chmod 1777`   |
| setgid     | `chmod g+s`       | `chmod 2777`   |
| setuid     | `chmod u+s`       | `chmod 4777`   |
