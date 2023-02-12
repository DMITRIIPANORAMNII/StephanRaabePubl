#!/bin/bash

# ------------------------------------------------------
# Install Script for Libvirt
# IMPORTANT: chmod +x libvirt.sh
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START LIBVIRT INSTALLATION..."

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
echo "-> Install packages"
sudo pacman -S virt-manager qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf
echo "Packages installed..."

echo "Manual Steps required:"
echo "Open sudo vim /etc/libvirt/libvirtd.conf:"
echo 'Remove # at the following lines: unix_sock_group = "libvirt" and unix_sock_rw_perms = "0770"'
echo "Add the following two lines at the end of the file to enable logging:"
echo 'log_filters="3:qemu 1:libvirt"'
echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"'
read -p "Press any key to confirm: " c

# ------------------------------------------------------
# Add user to the group
# ------------------------------------------------------
echo "-> Add user to groups"
sudo usermod -a -G kvm,libvirt $(whoami)
echo "User added to the groups..."

# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
echo "-> Enable services"
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
echo "Services enabled..."

echo "Manual steps required:"
echo "Open sudo vim /etc/libvirt/qemu.conf"
echo "Uncomment and add your user name to user and group."
echo 'user = "your username"'
echo 'group = "your username"'
read -p "Press any key to confirm: " c
# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
echo "-> Restart services"
sudo systemctl restart libvirtd
echo "Services restarted..."

# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
echo "-> Set network to autostart"
sudo virsh net-autostart default
echo "Network set to autostart..."

echo "DONE! Restart recommended."
