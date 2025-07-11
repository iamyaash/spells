---
date: '2025-06-29T20:02:46+05:30'
draft: false
title: 'Linux: Service Management with systemd'
tags:
- linux
- systemd
- services
cover:
    image: posts/linux/systemd/img/systemd-screenshot.png
    alt: systemd-screenshot
params:
    author: "Yashwanth Rathakrishnan"
    ShowReadingTime: true
    ShowCodeCopyButtons: true
    ShowToc: true
    TocOpen: true
---


# Checking Service Status In Detail
The `systemctl status` command provides detailed information about a service, including it's current state (_active, inactive, failed_), recent log entries, and reasons for failure if the service is not running.

**Example Command**:
```sh
sudo systemctl status apache2
#or httpd service
sudo systemctl status httpd
```
**Output**:
```sh
iamyaash@pi5:~ $ sudo systemctl status firewalld.service 
● firewalld.service - firewalld - dynamic firewall daemon
     Loaded: loaded (/lib/systemd/system/firewalld.service; enabled; preset: enabled)
     Active: active (running) since Sun 2025-06-29 20:30:48 IST; 1s ago
       Docs: man:firewalld(1)
   Main PID: 7956 (firewalld)
      Tasks: 2 (limit: 9585)
        CPU: 279ms
     CGroup: /system.slice/firewalld.service
             └─7956 /usr/bin/python3 /usr/sbin/firewalld --nofork --nopid

Jun 29 20:30:48 pi5 systemd[1]: Starting firewalld.service - firewalld - dynamic firewall daemon...
Jun 29 20:30:48 pi5 systemd[1]: Started firewalld.service - firewalld - dynamic firewall daemon.
```

The output includes:
- **Loaded**: Whether the service is loaded and `enabled/disabled`.
- **Active**: Current status(_active, inactive, failed_).
- **Main PID**: The main process ID.
- **Tasks, Memory, CPU**: Resource usage (if available).
- **Logs**: Recent log entries for troubleshooting.

# Starting, Stopping, Restarting, And Reloading Services
This is relatively simple, and it's the bare minimum requirement to use `systemctl` to manage `systemd daemon`.

We can control the operation of a service using `start`, `stop`, `restart`, and `reload`.
```sh
sudo systemctl start firewalld    # start the service
sudo systemctl stop firewalld     # stop the service
sudo systemctl restart firewalld  # stop and start the service
sudo systemctl reload firewalld   # reload configuration without stopping
```
> _Use `reload` for configuration changes that do not require a full restart_.

# Enabling And Disabling Services At Boot
The term `enable` and `disable` in systemd services indicates, that a service can start automatically at boot(`enable`), or to prevent automatic startup(`disable`).
```sh
sudo systemctl enable firewalld   # get started at boot
sudo systemctl disable firewalld  # won't start at boot
```

# Masking And Unmasking Services

Masking a service prevents it from being start, even manually. Unmasking removes this restriction.

```sh
sudo systemctl mask firewalld       # prevent all starts
sudo systemctl unmask firewalld     # allow starts again
```

> _Masking creates a symbolic link in `/etc/systemd/system` that overrides the service file_.

# Understanding And Working With `systemd` Targets

`systemd` uses _"targets"_ to group services and define the system state (eg: _multi-user, graphical, rescue_).

**Purpose**:They act as synchronization points during boot, shutdown, and state changes, allowing `systemd` to manage dependencies and ensure services start in the correct order.

**File Format**: Target units ends with `.target` and are defined in `/usr/lib/systemd/system` or `/etc/systemd/system`.

You can switch between targets using `systemctl isolate`.

## **Common targets**:
- **`multi-user.target`**: Text-based multi-user mode.
- **`graphical.target`**: Graphical user interface mode.
- **`rescue.target`**: Single-user rescue mode.
- **`poweroff.target`**: For shutting down or rebooting the system.

> For compatibility, `systemd` provides `runlevel*.target` units that map to _traditional SysV runlevels_.

## Advanced Usage and Features
- **Creating Custom Targets**: You can define your own target files to group custom services or define new system states.
- **Dependencies**: Targets can depend on other targets or units using `Wants=`, `Requires=`, `Before=`, and `After=` directives in unit files.
- **Multiple Active Targets**: Unlike traditional runlevels, multiple targets can be active at the same time.
- **Viewing Active Targets**: Use `systemctl list-units --type=target` to see all active and loaded targets.
- **Changing the Default Target**: Use `systemctl set-default <target>` to change the default boot target.
- **Isolating a Target**: Use `systemctl isolate <target>` to switch to a different target at runtime (eg: _from graphical to rescue mode_)
- **Nested Targets**: Some targets inherit all services from another target and add more (eg:`graphical.target` includes all from `multi-user.target` plus a display manager).


## Essential Commands
- List all targets: 
```sh
systemctl list-unit --type=target
```
- Get current default target
```sh
systemctl get-default
```
- Set default target
```sh
sudo systemctl set-default multi-user.target
```
- Isolate a target (_switch state_)
```sh
sudo systemctl isolate rescue.target
```
- View dependencies of a target
```sh
systemctl show -p Wants --value multi-user.target
systemctl show -p Requires --value multi-user.target
```
> You can easily create a custom target file by duplicating the existing target and edit dependencies as needed.