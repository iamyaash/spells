---
date: '2025-05-07T17:43:17+05:30'
draft: true
title: 'Git Setup Script'
tags: 
- git
- script
- automate
summary : A script that we can execute once and it will set things up for us. Best suited when you have fresh installation of operating system."
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
---


# Git Setup Script For A Fresh System

```sh
#! /bin/bash

# enter global git identity
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"

echo "Do you want to enable commit.gpgSign ? [y/N]" enable_gpg

if [[ "$enable_gpg" == "y" || "$enable_gpg" == "Y" ]]; then
    git config --global commit.gpgSign true
    echo "GPG commit signing enabled."
else 
    git config --global commit.gpgSign false
    echo "GPG commit signing skipped."
fi
```


