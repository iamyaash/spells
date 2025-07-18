---
date: '2025-07-18T23:36:37+05:30'
draft: false
title: 'Linux Environment Variables'
tags:
- environment
- linux
params:
    author: "Yashwanth Rathakrishnan"
    ShowCodeCopyButtons: true
    ShowReadingTime: true
    ShowToc: true
    TocOpen: true
---
# Environment Variables

In Linux, **Environment variables are named key-value pairs** that store information about your operating environment and configuration. They are crucial because they let the operating system, applications, and scripts know about elements such as :
- Where programs are location; _via _`PATH`.
- Your user/currently logged-in directory; `HOME`.
- Language or locale settings.
- System-wide or app-specific configurations.


_In simple terms, **environment variables** are a foundational way that Linux customizes, configues, and manages the actions of programs and users through simple "key=value" pairs._

## 1. Structure
Each environment variable has a name (usually all-uppercase by convention, like `PATH`, `HOME`, `EDITOR`) and a value (a string or set of strings).

Syntax:
```sh
NAME=value
```
Example:
```sh
PATH=/usr/local/bin:/usr/bin:/bin
HOME=/home/iamyaash
```
> You can see that we are separating directory location using _`:` colon_.

## 2. Purpose
- **Customization**: Set your preferred editor, default shell, time zone, etc.
- **Application Configuration**: Programs often check environment variables for things like database passwords or settings.
- **System Management**: Admins set global variables to manage environment settings for all users.
- **Dynamic Context**: Environments variables adapt applications to different users, folders or hardware settings. _Eg: Try running this command `echo $HOME` with different users, and you will see different output each time._

## 3. Types
- **System Environment Variables**: Affect **all users and entire system**. Set in files like `/etc/environment` or `/etc/profile`.
- **User Environment Variables**: Affect **only user session**. Typically set in `~/.bashrc`, `~/.profile`, etc.
- **Session Variables**: Exist only for the **life of current terminal/session**.
- **Persistent Variables**: **Remain across reboots/sessions** because they are defined in configuration files.
- **Read-Only Variables**: **Cannot be changed** after being set in a session.

## 4. Usage
Programs and the shell read these variables to determine settings like which directories to search for command (`$PATH`), where your home folder is (`HOME`), or what language to use (`LANG`).

> **Note**: You can see your environment variables with commands like `printenv`, `env`, or `set`.

## 5. Features
- Values are **case-sensitive** and, by convention, variable names are **ALL CAPS**.
- Some variables, like `PATH`, use colons (`:`) to separate multiple values.
- Environment variables are inherited by child processes, making them essential for scripts and subprocesses.

# Common Environment Variables
| Variable | Value                           | Usage                                         |
|----------|---------------------------------|-----------------------------------------------|
| PATH     | `/usr/local/bin:/usr/bin/:/bin` | List of directories to search for executables |
| HOME     | `/home/iamyaash`                | Current user's home directory                 |
| SHELL    | `/bin/bash`                     | User's preferred shell                        |
| USER     | `iamyaash`                      | Current username                              |
| LANG     | `en_US.UTF-8`                   | Language/locale settings                      |
| EDITOR   | `vim`                           | Default text editor                           |

