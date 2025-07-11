---
title: 'Linux: User & Group Management'
summary: "How to manage users & groups on Linux based operating systems, with exercise based explanations!"
date: 2025-06-15T14:51:16+05:30
draft: false
tags:
- linux
- user-group
params:
    author: "Yashwanth Rathakrishnan"
    ShowCodeCopyButtons: true
    ShowReadingTime: true
    ShowToc: true
    TocOpen: true
---

# What is a `user` & `group` in Linux?
In Linux, the terms `user` & `group` refer to system identities and how access is managed. A `user` represents an individual identity, while a `group` defines a collection of users who share the same access rights. Ultimately, access control in Linux revolves around these two concepts, who is accessing (`user`) and what permissions they have through the group that they are associated with (`group`).

A Linux system without proper user and group management would be insecure, allowing anyone to access any data they want.

### User
A `user` is an individual account on the system. Each user has:
- A **username**
- A **password**
- Their own **home directory** (`/home/<username>`)
- Their own set of **permissions**

Every time someone logs into the system, they do so as a "user".

### Group
A group is a collection of users. Instead of assigning permission to each other individually, Linux allows permissions to be assigned to a group. All users in a group inherit the group's permissions.

# How Permissions Work?

Every file and directory in Linux has **three types of access control**:
1. Owner (`user`)
2. Group (`group`)
3. Others

Each of these can be given different permission levels:
1. Read(`r`) - View the Contents
2. Write (`w`) - Modify the Contens
3. Execute (`x`) - Run/Execute the File (script/program)

Let take a look at a good example of how it's going to look like on a file:
```sh
total 4
drwxr-xr-x. 1 iamyaash iamyaash  20 Jun 12 23:09 archetypes
-rw-r--r--. 1 iamyaash iamyaash 596 Jun 15 14:40 config.yaml
drwxr-xr-x. 1 iamyaash iamyaash  28 Jun 12 23:09 content
drwxr-xr-x. 1 iamyaash iamyaash 180 Jun 12 23:09 public
drwxr-xr-x. 1 iamyaash iamyaash  56 Jun 13 19:28 scripts
drwxr-xr-x. 1 iamyaash iamyaash  16 Jun 12 23:09 themes
```
1. `drwxr-xr-x`  - Means the 
- **owner has full access (`iamyaash`)**
- **group has execute & read access**
- **others have execute access**.
2. `rw-r-r` - Means the 
- **owner has read & write access**
- **group and others only have read access**
3. `iamyaash` is the owner.
4. `iamyaash` is the group (_same name as the user, nvm :P_)

# How to Manage `user` & `group`?

Let's learn how to manage both `user` & `group` using hands-on excercize to help understand and practice how users and groups work in Linux.

### 1. View Current User Information
```sh
whoami
id
grep <username> /etc/passwd #used to verify whether the user is created
groups #display groups associated with the current user
groups <username> #display groups associated with the specified username
id -Gn #same as the above
id -g -n  #this shows only your primary (current) group name.
```
- `whoami` displays the current username
- `id` display the group IDs which the current user is part of.

### 2. Create a New User
```sh
sudo useradd newUser
sudo passwd newUser
```
- `useradd` create a user named "`newUser`"
- `passwd` to set password for the user "`newUser`"

### 3. Create a New Group
```sh
sudo groupadd devGroup
```
- create a group named `devGroup`

### 4. Add a User to a Group
```sh
sudo usermod -aG devGroup newUser
```
- Add `newUser` (**`user`**) to `devGroup` (**`group`**)
- `a` "a" stands of append used with `G`, it ensures the user is added to the specified group(s) without being removed from the existing groups.
- `G` specifies the supplementary group(s) which the user should be added. (you can user multiple group separated by commas)

### 5. Delete a User
```sh
sudo userdel -r newUser
```
- Executing the command with just `userdel` will only delete the `user` but not their home directory.
- Executing the command with `userdel -r` flag will both the `user` and their home directory.

### 6. Delete a Group
```sh
sudo groupdel devGroup
```
> **Note:** You cannot delete a group if it’s the primary group of an existing user. You must either delete the user first or change their group.

### 7. Create a File and Set Group Ownership
```sh
sudo su - newUser
cd -
touch demo.txt
ls -l demo.txt
```
In the above commands, we're switching to `newUser` and creating a file with it. Listing it will show the file's owner is `newUser`.
```sh
# Output from my device
iamyaash@fedora:~$ ll
total 0
-rw-r--r--. 1 iamyaash iamyaash   0 Jun 15 16:07  demo.txt
```

Let's switch to `root` user and change the group permissions,
```sh
sudo chgrp dev /home/newUser/demo.txt
ls -l /home/newUser/demo.txt
```

```sh
# Output from my device
iamyaash@fedora:~$ sudo chgrp wheel demo.txt 
[sudo] password for iamyaash: 
iamyaash@fedora:~$ ll
total 0
-rw-r--r--. 1 iamyaash wheel      0 Jun 15 16:07  demo.txt
```
### 8. Set Group Permissions on a File
```sh
chmod 640 /home/newUser/demo.txt
```
Let's understand the numeric permissions notations:
1. `4` - r: Read
2. `2` - w: Write
3. `1` - x: Execute

This is the permission of the current file:
1. `6` - user: read/write (4+2)
2. `4` - group: read (4)
3. `0` - others: no permission (0)

### 9. Test Access as Another Group Member
1. Add yourself into `customGroup` (create a group for this to experiment)
```sh
sudo usermod -aG customGroup newUser
```
2. Update your `group` access or log out and log back in.
```
newgrp customGroup
```
3. Try accessing the `/home/newUser/demo.txt`
```sh
cat /home/newUser/demo.txt
```

# Summary
To sum it up, `user` is an individual identity in Linux with its own _username_ & _password_ and set of permissions. A `group` is a collection of multiple users that allows shared access to files or resources based on group permissions. They both form the Foundation of Linux's access control system.
