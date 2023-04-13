#!/bin/bash

#  _________      _    __  __ 
# |__  /  _ \    / \  |  \/  |
#   / /| |_) |  / _ \ | |\/| |
#  / /_|  _ <  / ___ \| |  | |
# /____|_| \_\/_/   \_\_|  |_|
#
# by Stephan Raabe (2023)                            
# -----------------------------------------------------
# ZRAM Install Script
# yay must be installed
# -----------------------------------------------------
# NAME: ZRAM Installation
# DESC: Installation script for zram.
# WARNING: Run this script at your own risk.

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
read -p "Do you want to start now?" c

# -----------------------------------------------------
# Install zram
# -----------------------------------------------------
yay --noconfirm -S zram-generator

# -----------------------------------------------------
# Open zram-generator.conf
# -----------------------------------------------------
if [ -f "/etc/systemd/zram-generator2.conf" ]; then
	read -p "zram-generator.conf already exists. Do you want to open?" c
	sudo vim /etc/systemd/zram-generator.conf
else
	read -p "Do you want to generate the zram-generator.conf? " c
	sudo touch /etc/systemd/zram-generator.conf
	sudo bash -c 'echo "[zram0]" >> /etc/systemd/zram-generator.conf'
	sudo bash -c 'echo "zram-size = ram / 2" >> /etc/systemd/zram-generator.conf'
fi

# -----------------------------------------------------
# Restart services
# -----------------------------------------------------
read -p "Start systemctl services now? " c
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

echo "DONE! Reboot now and check with free -h the ZRAM installation."
