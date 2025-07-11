---
date: '2025-06-25T11:27:37+05:30'
draft: false
title: "Linux: Assigning Permissions and Group Ownership Automatically For Newly Created Files & Directories (umask & chgrp)"
summary: "To ensure that new files created in a shared directory are automatically assigned to the directory’s group rather than the group of the user who created them."
tags:
- linux
- permissions
- ownerships
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
---

# What is `umask`?
The `umask` command sets the default permissions for newly created files and directories. 

It acts as a "mask" that subtracts specified permissions from the maximum permissions, ensuring new files and directories are created with secure defaults.
It's also a process-based tool, which sets the default permission as long as it's running in the background.

## Essential Commands
| Commands                 | Description                                                   |
|--------------------------|---------------------------------------------------------------|
| `umask`                  | Check the current `umask` value                               |
| `umask 022`              | Set the new umask value                                       |
| `umask u=rwx, g=rx, o=r` | Sets permission using symbolic notation (equivalent to `022`) |

## Subcommands
| Commands   | Description                     |
|------------|---------------------------------|
| `umask -S` | Print mask in symbolic form     |
| `umask -p` | Print mask as command for reuse |
|            |                                 |

## Example
1. Change `umask` to `027` and create a new file:
```sh
iamyaash@pi5:~/umask $ umask
0022
iamyaash@pi5:~/umask $ touch testFile.txt
iamyaash@pi5:~/umask $ ll
total 0
-rw-r--r-- 1 iamyaash iamyaash 0 Jun 25 11:43 testFile.txt
iamyaash@pi5:~/umask $ umask 027 && umask
0027
iamyaash@pi5:~/umask $ touch testFile_027.txt
iamyaash@pi5:~/umask $ ll
total 0
-rw-r----- 1 iamyaash iamyaash 0 Jun 25 11:43 testFile_027.txt
-rw-r--r-- 1 iamyaash iamyaash 0 Jun 25 11:43 testFile.txt
```

2. Change `umask` to `077` and create a directory:
```sh
iamyaash@pi5:~/umask $ ll
total 0
iamyaash@pi5:~/umask $ umask
0022
iamyaash@pi5:~/umask $ mkdir testDir022 && ll
total 4.0K
drwxr-xr-x 2 iamyaash iamyaash 4.0K Jun 25 11:48 testDir022
iamyaash@pi5:~/umask $ umask 077 && umask && mkdir testDir077 && ll
0077
total 8.0K
drwxr-xr-x 2 iamyaash iamyaash 4.0K Jun 25 11:48 testDir022
drwx------ 2 iamyaash iamyaash 4.0K Jun 25 11:48 testDir077
```

# What is `chgrp`?
The `chgrp` is a Linux command that changes the group ownership of the files and directories.

## Essential Commands
| Commands                           | Description                                                                 |
|------------------------------------|-----------------------------------------------------------------------------|
| `chgrp groupName directoryName`    | Change the group ownership of a file                                        |
| `chgrp -R groupName directoryName` | Change the group ownership of both the directory and the contents inside it |

## Subcommands
| Commands                                         | Description                                                      |
|--------------------------------------------------|------------------------------------------------------------------|
| `chgrp -R`                                       | Recursive Operations                                             |
| `chgrp -v`                                       | Verbose output details                                           |
| `chgrp --reference=referenceFile/Dir targetFile` | To change the group ownership like the referenced file/directory |

## Example
1. List your groups
```sh
groups
```

2. Change the group of a file/directory
```sh
chgrp groupName fileName.txt #file
chgrp groupName dirName/ #directory only, not the contents inside it
chgrp groupName -R dirName/ #directory and it's content
```
