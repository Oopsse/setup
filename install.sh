#!/bin/bash

# Installation
# sh -c "$(wget https://raw.githubusercontent.com/Oopsse/setup/main/install.sh -O -)"

export DEBIAN_FRONTEND=noninteractive

KERNEL="linux-image-6.16.3+deb13-amd64"
LUKS="plymouth plymouth-themes"
DM="sddm sddm-theme-breeze"
WM="xinit i3 xsecurelock"
SYSTEM="build-essential linux-headers-$(uname -r) autorandr make gcc file fish tree pasystray arandr krb5-user sudo dunst libnotify-bin iotop usbutils inxi acpi firmware-linux-free lsb-release dbus dbus-x11 systemd-timesyncd"
NETWORK="blueman network-manager-applet"
# ImageViewer BackgroundImage Snapshot Terminal TextEditor Browser VideoViewer PDFViewer
UTILS="keepassxc-full okular qimgv feh flameshot terminator openssh-client neovim git jq curl wget ca-certificates dnsutils resolvconf xclip ncdu x11-utils rofi make htop chromium firefox-esr-l10n-fr vlc python3 python3-pip"
DISK="thunar thunar-volman thunar-archive-plugin thunar-vcs-plugin gvfs-fuse gvfs-backends ntfs-3g exfatprogs exfat-fuse dosfstools partitionmanager gdisk"

## APT
sed -i '/cdrom:/d' /etc/apt/sources.list
echo 'deb http://deb.debian.org/debian/ trixie-backports main non-free-firmware' | tee -a /etc/apt/sources.list
echo 'deb-src http://deb.debian.org/debian/ trixie-backports main non-free-firmware' | tee -a /etc/apt/sources.list
apt update

## Kernel
apt install -y $KERNEL

## Luks
apt install -y $LUKS

## Display Manager
apt install --no-install-recommends -y $DM

## wms & x 
apt install -y $WM

## System
apt install -y $SYSTEM

## Network
apt install -y $NETWORK

## File manager & Disk & File system
apt install -y $DISK

## Utilitaire
apt install -y $UTILS

## Fish
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/4/Debian_13/ /' | tee /etc/apt/sources.list.d/shells:fish:release:4.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:4/Debian_13/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg > /dev/null

## Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

## OnlyOffice
mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
chown root:root /tmp/onlyoffice.gpg
mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg
echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | tee -a /etc/apt/sources.list.d/onlyoffice.list

apt install -y fish docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin onlyoffice-desktopeditors

# Configuration
## LUKS
### Configure /usr/share/plymouth/plymouthd.defaults to tribar and sudo update-initramfs -u
sed -i 's/Theme=.*$/Theme=tribar/' /usr/share/plymouth/plymouthd.defaults
update-initramfs -u
## Grub
sed -i 's/GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=0/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
update-grub
## SDDM
wget "https://images2.alphacoders.com/117/1171867.png" -O /usr/share/wallpapers/Next/contents/images/1.png
sed -i 's/background=.*$/background=\/usr\/share\/wallpapers\/Next\/contents\/images\/1.png/' /usr/share/sddm/themes/breeze/theme.conf
chown root:root "/usr/share/wallpapers/Next/contents/images/1.png"
chmod 644 "/usr/share/wallpapers/Next/contents/images/1.png"

usermod -aG docker e
usermod -aG sudo e

### Xsecurelock
##
