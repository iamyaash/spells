---
date: '2025-09-06T18:28:17+05:30'
draft: false
title: 'KDE: Reset Audio Configurations'
summary: "Quick guide on how to reset audio configurations in KDE."
tags:
- KDE
- pipewire
author: "Yashwanth Rathakrishnan"
ShowReadingTime: true
ShowCodeCopyButtons: true
---

# Overview
I keep seeing this error on Fedora KDE Plasma. I doubt that it's actually an error from KDE Plasma itself, and I don't think Fedora is responsible either.

Whenever I try to use external headphones or any audio device, the GUI menu does not list them separately as distinct audio devices. Instead, I have to make it work by routing the audio through the internal speaker’s virtual device name, rather than showing the device separately. Weirdly, some applications send audio to the internal speakers while other audio plays through the headphones simultaneously, which is inconsistent and difficult to troubleshoot.

No matter what I try, it always results in errors. I believe the best way to fix this issue is to reset the audio configuration entirely instead of troubleshooting individual settings manually.

## Reinstall Tools
I installed the `pipewire` tools instead of `pipewire-pulseaudio`, which changed some configurations and caused audio device errors.

1. Install the `pipewire-pulseaudio` package first:
```sh
sudo dnf install pipewire-pulseaudio --allowerasing
```
> This will remove the conflicting package package and install thee `pipewire-pulseaudio` instead.

2. Add the user to the group for appropriate permissions:
```sh
sudo usermod -aG audio $USER
```

3. Try reinstalling or updating pipewire and related packages again to check if we have the same error:\
```sh
sudo dnf reinstall pipewire pipewire-alsa wireplumber
```

4. Verify that `pipewire`, `pipewire-pulseaudio`, `pulseaudio-alsa` and `wireplumber` are installed correctly:
```sh
sudo dnf list installed pipewire\*
```

5. Restart the `pipewire` and related services for the current user and reboot system as well:
```sh
systemctl --user restart pipewire pipewire-pulse wireplumber  
```
```sh
sudo reboot
```