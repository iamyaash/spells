---
date: '2025-06-29T12:15:36+05:30'
draft: false
title: 'Linux: Creating and Customizing systemd Units'
summary: "Important directives: ExecStart, ExecStop, Restart policies; Dependencies and ordering: Requires, Wants, Before, After; Writing your own service units with examples; Overriding units using drop-in configurations (systemctl edit) "
cover:
    image: posts/linux/systemd/img/systemd-screenshot.png
    alt: systemd-screenshot
tags:
- linux
- systemd
params:
    author: "Yashwanth Rathakrishnan"
    ShowToc: true
    TocOpen: true
    ShowReadingTime: true
    ShowCodeCopyButtons: true
---

# Anatomoy of `systemd` Unit File
A typical `systemd` unit file for a service consists of three main section:
- **[Unit]**: Contains metadata and dependencies.
- **[Service]**: Defines how the service should be managed.
- **[Install]**: Specifies how the unit is enable or installed.

```service
[Unit]
Description=My Example Service
After=network.target

[Service]
ExecStart=/usr/bin/my-service
Restart=always

[Install]
WantedBy=multi-user.target
```

# Important Directives
- **`ExecStart`**: Command to start the service.
- **`ExecStop`**: Command to stop the service.
- **`Restart`**: Policy for restarting the service (`always`, `on-failure`, `on-watchdog`, `on-abort` or `no`).
- **`RestartSec`**: Time to wait before restarting the service. (`RestartSec=5s`)

```service
[Service]
ExecStart=/usr/bin/my-service
ExecStop=/usr/bin/my-service
Restart=on-failure #only restarts when failed
RestartSec=8s #wait until 8 seconds to restart
```

# Defining Dependencies And Order
- **`Requires`**: The unit will not start unless the listed unit is active.
- **`Wants`**: The unit would like the listed unit to be active, but it's not required.
- **`Before`**: The unit should be _started before the listed unit_.
- **`After`**: The unit should be _started after the listed unit_.

```service
[Unit]
Description=My Custom Service
Requires=custom.service
After=custom.service
Before=custom.service
```

# Adding Environment Variables
- **`Environment`**: Set environment variables directly in the unit file.
- **`EnvironmentFile`**: Load environment variables from a file.
## Environment
- This directive allows yout to set environment variables directly in the unit file.
- You can use it multiple times to set several variables.
```sh 
[Service]
Environment="VAR1=value1"
Environment="VAR2=value2"
```
> These variables will be available to the process started by the service.

## EnvironmentFile
- This directive loads environment variables from an external file.
- The file should contain one variable per line, in the format `VAR=value`. 
```sh
[Service]
EnvironmentFile=/etc/myapp/env
```
> This is useful for sensitive data or when you want to keep variables outside the unit file.

## Example
Let's create a simple service that prints the envionment variables.
- Script: `usr/loca/bin/env.sh` in executable permission `chmod +x`
```sh
!#/bin/sh
echo "VAR1 is: ${VAR1:-not set}"
echo "VAR2 is: ${VAR2:-not set}"
```
- Env: `/usr/myapp/env`
```env
VAR1=something1
VAR2=something2
```
- Create Unit File
```sh
[Unit]
Description=Shows environment values

[Service]
ExecStart=/usr/loca/bin/env.sh
#env vars; Environment
Environment="VAR1=something1"
Environment="VAR2=something2"
#env file; EnvironmentFile (use it when handling sensitive data)
EnvironmentFile=/etc/myapp/env
[Install]
WantedBy=multi-user.target
```

# Overriding Existing Services With Drop-In Configuration
You can safely override or extend the configuration of existing services using drop-in files in the `unit.service.d`/ directory.
- Using `systemctl edit`:
```sh
sudo systemctl edit sshd.service
```
This creates `/etc/systemd/system/sshd.service.d/override.conf` where you can _add or override_ directives.

- Manual Method:
```sh
sudo mkdir -p /etc/systemd/system/sshd.service.d
sudo nano /etc/systemd/system/sshd.service.d/custom.conf
```
> As `systemctl edit` creates the `override.conf`, we can manually create `sshd.service.d/` and customize `sshd.service.d/custom.conf`. Based on the service, we want to override

## Example
1.  You want to change the restart policy of the `sshd.service` (the SSH daemon) so that it always restarts if it fails, without editing the original unit file. How do you achieve this using systemd drop-in files?  Additionally, you want to add a custom environment variable (`LOG_LEVEL=DEBUG`) for the service.

- Create drop-in directory and file
```sh
sudo systemctl edit sshd.service
# open your default editor and create a file in 
# /etc/systemd/system/sshd.service.d/override.conf
```
- Add your overrides (In the editor, add)
```sh
Restart=always
Environment="LOG_LEVEL=DEBUG"
```

Alternatively, we can use a manual method to accomplish this without `systemctl edit`
```sh
sudo mkdir -p /etc/systemd/system/sshd.service.d/
sudo nano /etc/systemd/system/sshd.service.d/override.conf
```
```sh
#add this in the editor
Restart=always
Environment="LOG_LEVEL=DEBUG"
````
Finally, `reload` and restart the service
```sh
sudo systemctl daemon-reload
sudo systemctl restart sshd.service
```
Verify using `systemctl cat sshd.service`

---
--- 
# Write Your Own Service Unit Files:
1. How do you create and configure a `systemd` unit file to run this script as a service, ensuring it start after the network is available and restarts automatically if it fails?
- script = `/usr/loca/bin/myscript.sh` (this simply greets when executed!)
- run this as a _system service_, managed by `systemd`

1. Write a service in `/etc/systemd/system/script-start.service`:
```service
[Unit]
Description=Service to start the greet script
After=network.target

[Service]
ExecStart=/usr/local/bin/myscript.sh
Restart=Always

[Install]
WantedBy=multi-user.target
```
**[Unit]**
- `Description=Service to start the greet script`
    - Human readable description
- `After=network.target`
    - Specifies that this service should start only after the `network.target` unit is active, ensuring the network is available before your script runs.

**[Service]**
- `ExecStart=/usr/local/bin/myscript.sh`
    -  The above script will be executed to start the service.
- `Restart=Always`
    - Sets the restart policy so that the _service will always be restarted if it stops for any reason_.

**[Install]**
- `WantedBy=multi-user.target`
    - Specifies that this service should be started when the system reaches the `multi-user.target` state, which is standard state for a multi-user system after reboot.
    - In simple terms, `systemd` creates a symbolic link so your service start at boot when you `systemctl enable script-start.service`.
---

2. How do you set environment variables in the systemd unit file, and what directive should you use?
- Variable required by the script `GREETING="Hello, systemd!"`.
```sh
!#/bin/sh
echo "$GREETING"
```
> Make sure to give `execute` permission to this script.
```service
[Unit]
Description=Add env variable to service

[Service]
Environment="GREENTING=Hello, World!"
ExecStart=/usr/local/bin/greet.sh
[Install]
WantedBy=multi-user.target
```
---
- `sudo systemctl daemon-reload` reload the services for the new service to take effect.
- `sudo systemctl enable greet.service` to start the service at boot.
- `sudo systemctl start greet.service` to start for the current boot only.

