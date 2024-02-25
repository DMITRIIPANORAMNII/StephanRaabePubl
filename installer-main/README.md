# Installer for ML4W dotfiles

This script will install the latest version of my dotfiles.

Download the script into your home directory.

<a href="https://gitlab.com/stephan-raabe/installer/-/raw/main/installer.sh">Download the script</a> (Right click + Save link as...)

```
# Change to the location and make the script executable
chmod +x installer.sh

# Start the script
./installer.sh
```

After confirming the start, the script will install the following required packages if not available on your system:
wget, unzip, gum, rsync

## How it works

The script will download the latest release from https://gitlab.com/stephan-raabe/dotfiles, unzip the file into the ~/Downloads folder and will start the installation script ./install.sh

## My dotfiles for Hyprland and Qtile

You can find my dotfiles on Gitlab here: https://gitlab.com/stephan-raabe/dotfiles
