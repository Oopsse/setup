#!/bin/bash

# Installation

KERNEL="linux-image-6.16.3+deb13-amd64"    
LUKS="plymouth plymouth-themes"    
DM="sddm sddm-theme-breeze"    
WM="xinit i3 xsecurelock"    
SYSTEM="make file fish tree pasystray arandr krb5-user sudo dunst libnotify-bin iotop usbutils inxi acpi firmware-linux-free lsb-release dbus dbus-x11 systemd-timesyncd"    
NETWORK="blueman network-manager-applet"    
UTILS="feh flameshot terminator openssh-client neovim git curl wget ca-certificates dnsutils resolvconf xclip ncdu x11-utils rofi make htop chromium firefox-esr-l10n-fr"    
DISK="dolphin gvfs-fuse gvfs-backends ntfs-3g exfatprogs exfat-fuse dosfstools partitionmanager gdisk"    
    
## APT    
echo 'deb http://deb.debian.org/debian/ trixie-backports main non-free-firmware' | tee /etc/apt/sources.list    
echo 'deb-src http://deb.debian.org/debian/ trixie-backports main non-free-firmware' | tee /etc/apt/sources.list    
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/4/Debian_13/ /' | tee /etc/apt/sources.list.d/shells:fish:release:4.list         
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:4/Debian_13/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg > /dev/null         
sudo apt update    

## Kernel
apt install -y $KERNEL

## Luks
apt install -y $LUKS

## Display Manager
apt install --no-install-recommends $DM

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
wget "https://images2.alphacoders.com/117/1171867.png" -o "/usr/share/wallpapers/Next/contents/images/1.png"
chown root:root "/usr/share/wallpapers/Next/contents/images/1.png"
chmod 644 "/usr/share/wallpapers/Next/contents/images/1.png"

### Xsecurelock
##
