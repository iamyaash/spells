---
date: '2025-01-27T20:32:26+05:30'
draft: false
title: 'Switch to NVIDIA GPU on Fedora Linux'
tags:
  - docs
  - script
  - GPU
cover:
  image: posts/nvidia/nvidia-linux.png
  alt: NVIDIA-linux
---

> `Note`: Make sure to **Disable Secure Boot**, else whatever you do it won't work :)
# Install & Switch 

**1. Install the required dependencies**

```sh
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda
```

**2\. Edit the environment configuration file for your shell**

```sh
sudo nano /etc/environment
```

**3\. Add the following lines to enable the GPU**
```sh
__GLX_VENDOR_LIBRARY_NAME=nvidia
__NV_PRIME_RENDER_OFFLOAD=1
__VK_LAYER_NV_optimus=NVIDIA_only
```

**4\. Restart the system**

```sh
sudo reboot
```

[Download](https://github.com/iamyaash/spells/blob/main/content/posts/nvidia/install_nvidia.sh) and execute this script to automate the above process!

**5\. Check the status of the currently selected GPU**

```sh
glxinfo | grep "OpenGL renderer"
```

```sh
thisisyaash@yaashs-fedora:~$ glxinfo | grep "OpenGL renderer"
OpenGL renderer string: NVIDIA GeForce RTX 3050 Laptop GPU/PCIe/SSE2
```

> It will show the result something like this with the respective gpu information

---

# If the above steps didn't worked, then follow the below steps :)

**1. Veriify the NVIDIA Kernel Module:**
```sh
lsmod | grep nvidia
```
> If no output then it's not loaded, else **Good**!

**2. Reinstall the NVIDIA drivers**
- **check whether the NVIDIA driver is connected**
```sh
/sbin/lspci | grep -e VGA
```
- **remove existing drivers**
```bash
sudo dnf remove *nvidia*
```
- **reinstall the NVIDIA driver**
```bash
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda
```
- **rebuild the kernel**
```bash
sudo akmods --force
```
- **ensure the NVIDIA modules are loaded**
```sh
sudo modprobe nvidia
lsmod | grep nvidia
```
- **reboot**
```sh
sudo reboot
```
---
