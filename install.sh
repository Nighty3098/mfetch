#!/bin/bash

install_packages() {
    local package_manager=$1
    shift
    local packages="$@"

    case $package_manager in
        apt)
            sudo apt-get update
            sudo apt-get install -y $packages
            ;;
        dnf)
            sudo dnf install -y $packages
            ;;
        pacman)
            sudo pacman -S --noconfirm $packages
            ;;
        *)
            echo "Unknown package manager: $package_manager. Installation failed."
            exit 1
            ;;
    esac
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
else
    echo "Unable to determine the operating system."
    exit 1
fi

case $OS_ID in
    kali | debian | ubuntu)
        install_packages apt "curl bash pciutils procps "
        ;;
    fedora | redhat | centos)
        install_packages dnf "curl bash pciutils procps "
        ;;
    arch | manjaro | endeavouros)
        install_packages pacman "curl bash pciutils procps "
        ;;
    *)
        echo "Unknown system: $OS_ID. Installation failed."
        exit 1
        ;;
esac

chmod +x mfetch.sh
sudo cp mfetch.sh /bin/
sudo mv /bin/mfetch.sh /bin/mfetch

echo "Installation complete."
