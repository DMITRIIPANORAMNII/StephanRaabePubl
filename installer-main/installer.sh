#!/bin/bash
clear

# Check if package is installed
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Install required packages
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

# Required packages for the installer
packages=(
    "wget"
    "unzip"
    "gum"
    "rsync"
)

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 _           _        _ _           
(_)_ __  ___| |_ __ _| | | ___ _ __ 
| | '_ \/ __| __/ _` | | |/ _ \ '__|
| | | | \__ \ || (_| | | |  __/ |   
|_|_| |_|___/\__\__,_|_|_|\___|_|   

EOF
echo "for ML4W dotfiles"
echo ""
echo -e "${NONE}"
echo "This script will support you to download the latest version of the ML4W dotfiles".
echo ""
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
            echo ""
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Synchronizing package databases
sudo pacman -Sy
echo ""

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${packages[@]}";
echo ""

# Double check rsync
if ! command -v rsync &> /dev/null; then
    echo ":: Force rsync installation"
    sudo pacman -S rsync --noconfirm
else
    echo ":: rsync double checked"
fi
echo ""

# Select the dotfiles version
echo "Please select the version to download (main = Rolling Release): "
version=$(gum choose "main" "2.8" "CANCEL")
if [ -z $version ] || [ "$version" == "CANCEL" ] ;then
    echo "Download canceled."
    exit
fi
download_path="https://gitlab.com/stephan-raabe/dotfiles/-/archive/$version/dotfiles-$version.zip"
echo "Downloading from $download_path"
echo ""

# Download dotfiles zip into ~/Downloads
wget -P ~/Downloads/ https://gitlab.com/stephan-raabe/dotfiles/-/archive/$version/dotfiles-$version.zip
echo "Download complete."
echo ""

# Unzip
unzip -o ~/Downloads/dotfiles-$version.zip -d ~/Downloads/
echo "Unzip complete."
cd ~/Downloads/dotfiles-$version/

# Start the installatiom
if gum confirm "DO YOU WANT TO START THE INSTALLATION NOW?" ;then
    echo "Starting the installation now..."
    sleep 2
    ~/Downloads/dotfiles-$version/install.sh
elif [ $? -eq 130 ]; then
        exit 130
else
    echo "Installation canceled."
    echo "You can start the installation manually with ~/Downloads/dotfiles-$version/install.sh"
    exit;
fi

