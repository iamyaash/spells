---
date: '2025-08-27T15:48:48+05:30'
draft: false
title: 'SSH: Agent'
summary: "SSH agent is a background program that manages and storess SSH private keys for secure authentication, letting users connect to remote servers via SSH without repeatedly entering passphrase or password."
tags:
- ssh
- 101
params:
    author: "Yashwanth Rathakrishnan"
    ShowToc: true
    TocOpen: true
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---
# What is SSH Agent?
- **SSH agent** is a daemon for SSH that keeps track of identity keys and their passphrases in memory (_not on disk_). Which improves security and convenience.
- When an SSH key with a passphrase is used, the **agent prompts for the passphrase only once per login session**, and then handles authentication for future connections automatically.
- The agent only allows the stored keys to sign authentication messages, never allowing the private key material to be extracted.

## Main Uses
- **Single Sign-On** (SSO): Enter the password once per login session, then use SSH seamlessly across multiple terminals and program without needing to authenticate.
- **Agent Forwarding**: Allows remote SSH sessions to use your local agent, making it possible to authenticate to further  hosts without needing to copying the private keys around.
- **Key Management**: Easily add, remove, and list keys managed by the agent, improving operational security and ease of use. Example: `ssh-add`

# Usage
To use `ssh-agent` in Linux, start the agent, add your private key, and optionally configure it for automatic use and forwarding.

1. Start `ssh-agent`:
	```sh
	eval "$(ssh-add -s)"
	```
2. Add SSH key to agent:
	```sh
	ssh-add ~/.ssh/id_rsa
	```
	```sh
	#example output from my device
	Enter passphrase for <sensitive-info>.ssh/id_rsa: 
	Identity added: <sensitive-info>.ssh/id_rsa (email@email.com)
	```
3. Verify added keys:
	```sh
	ssh-add -l
	```
	```sh
	#example output from my device
	4096 SHA256:<asdasdasdasdasdasdasdasdasdasdasdasdasdasdas> email@email.com (RSA)
	```