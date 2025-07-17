---
date: '2025-07-18T00:00:52+05:30'
draft: false
title: 'Linux Messaging Basics: mail, wall & write'
summary: "Use mail to send or receive stored messages & system notificaitons, wall to broadcast announcements to all users and use write for quick direct messages to another user."
tags:
- communication
- messages
params:
    author: "Yashwanth Rathakrishnan" 
    ShowCodeCopyButtons: true
    ShowReadingTime: true
    ShowToc: true
    TocOpen: true
---

# `mail`
Local notifications via mail spool (_typically for system messages or scripts_). It provides simple email interface for users on the same system.

**Check Mail**
```sh
mail
```
It lists the mail by reading your spool file in `/var/mail/<username>`.

**Useful `mail` commands at the `&` promt**
- `8` - Read a specific message number; `1-n`.
- `d` - Delete the current message | current read message
- `q` - Quit and save your read mail; _moves read messages out of your inbox_
- `n` - Reads the next message
- `p` - Print the current message; *re-read the mail*
- `h` - Show the message headers list.

**Send Mail to Another User**
```sh
echo "This is body when using this command" | mail -s "Subject" iamyaash
echo "Backup completed successfully." | mail -s "Backup Status" adminuser
```
```sh
df -h | mail -s "Disk Usage Report:" iamyaash
```
> You can also use just `mail username`, then type a subject and body, finishing it with `CTRL+D`.

# `wall`
Display a message to all the currently logged in users. It's mostly used for quick system-wide announcements and only `root` or users with elevated privileges can broadcast.

**Broadcast a message**

Single line message:
```sh
wall "This system will reboot in 8 minutes."
```
Multi-line message:
```sh
wall
<type your message>
(Press CTRL+D to send & exit)
```

# `write`
It sends real-time messages to another user who is currently logged-in on the same system. Both uses must be logged in, since it's a real-time messaging tool it won't store the message for reading it later. In simple terms, it's not persistent like `mail`.

Can estalish communication only when the two users are online at the same time.

**Find who is logged in**
```sh
who # to see who is currently logged-in
w # see wee what they are doing
```

**Send a message**
```sh
write iamyaash
```

Throw an error, when the user who is sending the message don't have elevated privileges:
```sh
iamyaash@pi5:~ $ write hugo-pages pts/1 
write: effective gid does not match group of /dev/pts/0
```
Make sure to use `sudo`, when lacking privileges:
```sh
# sender
iamyaash@pi5:~ $ sudo write hugo-pages pts/1 
this is testing!
```
```sh
# receiver
hugo-pages@pi5:~ $ 
Message from iamyaash@pi5 (as root) on pts/2 at 00:22 ...
this is testing!
EOF
```