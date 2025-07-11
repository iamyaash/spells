#!/usr/bin/env sh

# NVIDIA GPU setup script for Fedora Linux only
# make sure to run this with sudo previleges

# checking whether it's executed with sudo/root
if [[ $EUID -ne 0 ]]; then
	echo "Please run the script with sudo or as root."
	exit 1
fi

echo "Step 1: Installing NVIDIA drivers and dependencies"
dnf install -y akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda

echo "Step 2: Adding NVIDIA variables to /etc/environment"
# check if /etc/environment already exists
if [ -f "/etc/environment" ]; then
    echo "/etc/environment already exists. Backing up /etc/environment to /etc/environment.bak"
    cp /etc/environment /etc/environment.bak
else
    echo "/etc/environment.bak already exists."
fi

# adding or updating variables

grep -q "__GLX_VENDOR_LIBRARY_NAME=nvidia" /etc/environment || echo "__GLX_VENDOR_LIBRARY_NAME=nvidia" >> /etc/environment
grep -q "__NV_PRIME_RENDER_OFFLOAD=1" /etc/environment || echo "__NV_PRIME_RENDER_OFFLOAD=1" >> /etc/environment
grep -q "__VK_LAYER_NV_optimus=NVIDIA_only" /etc/environment || echo "__VK_LAYER_NV_optimus=NVIDIA_only" >> /etc/environment

echo "Step 3: Rebooting system to apply changes..."
read -p "Do you want to restart now to apply the changes [y/N]: " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
	echo "Rebooting now..."
	sleep 4
	reboot
else 
	echo "Not rebooting, please make sure to reboot later to apply the changes."
fi
