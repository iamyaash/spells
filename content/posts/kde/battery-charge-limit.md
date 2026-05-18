---
date: '2026-05-18T12:24:56+05:30'
draft: false
title: 'KDE: Limiting Battery Charging Level'
summary: "Quick guide on how to limit battery charge level in KDE using systemd service."
tags:
- KDE
- battery
author: "Yashwanth Rathakrishnan"
ShowToc: true
TocOpen: true 
ShowReadingTime: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
---

# Overview
On many laptop's KDE's charge-limit slider is only a frontend, and the settings are reset after reboot. Because, the firmware/kernel does not persist it reliably. The usual fix is to apply the limit at boot with a persistent rule or service, instead of relying on KDE Plasma alone.

## Good Approach
Writing a systemd service is a standard and reasonable workaround when the KDE setting does not survice the reboot on your hardware.
It's not the most elegant solution, but it gets the job done and it's a common Linux way to reapply a battery threshold at boot.

---

# Solution
Create a system service file named `battery-charge-limit.service` in `/etc/systemd/system`. That is the normal location for custom systemd unit files, while the vendor provided units usually live under `/usr/lib/systemd/system` or something similar.

## Verify Battery Location and Threshold
Check your actual battery path first, because some laptops use a different battery name or different thresholds.
```sh
find /sys/class/power_supply/BAT1 -type f | grep -E "charge_control_(start|end)_threshold"
```
> Note: `BAT1` maybe be different in your machine

1. Head inside `/etc/systemd/system`
```sh
cd /etc/systemd/system
```

2. Create a file named `battery-charge-limit.service`
```sh
sudo touch battery-charge-limit.service
```
3. Open the `.service` with choice of your editor:
```sh
$EDITOR battery-charge-limit.service
```
4. Add these lines
```service
[Unit]
Description=Set battery charge limit to 80%
ConditionPathExists=/sys/class/power_supply/BAT1/charge_control_end_threshold

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
```
> This example assumes your battery is `BAT1` and the threshold file is `charge_control_end_threshold`, which is common but not universal.
## Apply the Changes
After saving the file, reload systemd so it notices the new unit, then enable it so it runs automatically at boot:
```sh
#reloads the units to detect new file
sudo systemctl daemon-reload
```
```sh
#always starts at boot
sudo systemctl enable --now battery-charge-limit.service
```
