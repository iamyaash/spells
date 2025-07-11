---
date: '2025-06-20T22:35:06+05:30'
draft: false
title: 'Emacs: Daemon & Client Automation'
summary: "Running an Emacs daemon server in the background and using emacsclient instead of a standalone application helps make opening, closing, and other operations faster."
tags:
- emacs
- automation
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---

# Let's Make Emacs Faster!

### 1. Find The `systemd` Service File For `emacs`
```sh
sudo find / -iname emacs.service
```
```sh
#output
iamyaash@fedora:~/Projects/gh/iamyaash/spells$ sudo find / -iname emacs.service
[sudo] password for iamyaash: 
/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/app.slice/emacs.service
/usr/lib/systemd/user/emacs.service
```
```sh
cd /usr/lib/systemd/user
```

### 2. Verify `emacs.service`, Whether It's Set To Run `emacs --daemon`
```sh
iamyaash@fedora:~ $ cat /usr/lib/systemd/user/emacs.service
[Unit]
Description=Emacs text editor
Documentation=info:emacs man:emacs(1) https://gnu.org/software/emacs/

[Service]
Type=notify
ExecStart=/usr/bin/emacs --fg-daemon

# Emacs will exit with status 15 after having received SIGTERM, which
# is the default "KillSignal" value systemd uses to stop services.
SuccessExitStatus=15

# The location of the SSH auth socket varies by distribution, and some
# set it from PAM, so don't override by default.
# Environment=SSH_AUTH_SOCK=%t/keyring/ssh
Restart=on-failure

[Install]
WantedBy=default.target
```
This service run the `emacs` and as long as it runs the `daemon` it's fine!

### 3. Let's `enable` & `start` This Service
```sh
systemctl --user enable emacs.service
systemctl --user start emacs.service
```
The service file is under the `/systemd/user` directory, we must have to use the `--user` flag while executing the command.
> **Note**: Make sure to **kill any `emacs` processes in the background** or else it won't run!
```sh
ps aux | grep emacs ## or ps -ef | grep emacs
killall emacs
kill <pid>
```

### 4. Set Alias for `emacsclient` For Terminal Execution
```sh
nvim ~/.bashrc
```

```sh
alias emacscl="emacsclient -c -a 'emacs'"
```

```sh
source ~/.bashrc
```

### 5. Create a Desktop Icon for GUI Execution
```sh
sudo find / -iname emacs.desktop
```

Duplicate the existing desktop file:
```sh
sudo cp /usr/share/applications/emacs.desktop /usr/share/applications/emacsclient.desktop
```

Modify configurations inside the `emacsclient.desktop`: 
```sh
#replace Name & Exec only
Name=Emacsclient
Exec=emacsclient -c -a 'emacs' %F
```

# Alternate

If you do not want the daemon to run automatically when the device boots, but instead want to start it manually whenever needed, you can simply use scripts to handle this.

### `emacs server` (daemon)
> **Note**: Make sure to store the scripts safe and secure!
```sh
touch emacs-server.sh
nvim emacs-server.sh
```
Paste this into `emacs server.sh`:
```sh
#!/bin/bash
echo "Initializing \`emacs --daemon\` server"
/usr/bin/emacs --daemon
```

### `emacs client` (client)
```sh
touch emacs-client.sh
nvim emacs-client.sh
```
Paste this into `emacs-client.sh`:
```sh
#!/bin/bash
echo "Opening emacs client \`emasclient -c -a 'emacs'\`"
emacsclient -c -a 'emacs'
```
#### Change Permissions for Execution
```sh
chmod 755 emacs-server.sh emacs-client.sh
```

## Summary

With this setup, the `emacs --daemon` runs in the background and can execute tasks instantly when using `emacsclient`. Suitable for people who use `emacs` as a daily driver and in need of speeding things up!
