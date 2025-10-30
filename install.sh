#!/bin/bash

# Installation
# sh -c "$(wget https://raw.githubusercontent.com/Oopsse/setup/main/install.sh -O -)"

export DEBIAN_FRONTEND=noninteractive

KERNEL="linux-image-6.16.3+deb13-amd64 linux-headers-6.16.3+deb13-amd64"
LUKS="plymouth plymouth-themes"
DM="sddm qml-module-qtquick-layouts qml-module-qtgraphicaleffects qml-module-qtquick-controls2 libqt5svg5"
WM="xinit xinput xorg xorg-dev xbacklight i3 xsecurelock libnotify-bin libnotify-dev picom"
SYSTEM="pkexec fwupd lxpolkit build-essential linux-headers-$(uname -r) autorandr make gcc file zsh tree pasystray arandr krb5-user sudo dunst libnotify-bin iotop usbutils inxi acpi acpitool firmware-linux-free lsb-release dbus dbus-x11 systemd-timesyncd brightnessctl"
NETWORK="blueman network-manager-applet"
# ImageViewer BackgroundImage Snapshot Terminal TextEditor Browser VideoViewer PDFViewer
SOUND="firmware-cirrus firmware-intel-sound alsa-utils pipewire-pulse pavucontrol"
UTILS="asciinema solaar fonts-recommended fonts-font-awesome fonts-terminus keepassxc-full okular qimgv feh flameshot terminator openssh-client neovim git jq curl wget ca-certificates dnsutils xclip ncdu x11-utils rofi make htop chromium firefox-esr-l10n-fr vlc python3 python3-pip pipx mpv"
DISK="thunar thunar-volman thunar-archive-plugin thunar-vcs-plugin gvfs-fuse gvfs-backends ntfs-3g exfatprogs exfat-fuse dosfstools partitionmanager gdisk unzip smbclient cifs-utils nfs-common"

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

## Sound
apt install -y $SOUND

## Network
apt install -y $NETWORK

## File manager & Disk & File system
apt install -y $DISK

## Utilitaire
apt install -y $UTILS

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

apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin onlyoffice-desktopeditors

## Oh-My-Zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

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
wget "https://gitlab.com/Matt.Jolly/sddm-eucalyptus-drop/-/archive/master/sddm-eucalyptus-drop-master.zip?ref_type=heads" -O /dev/shm/sddm-eucalyptus-drop-master.zip
unzip /dev/shm/sddm-eucalyptus-drop-master.zip  -d /usr/share/sddm/themes
ln -sv /usr/share/sddm/themes/sddm-eucalyptus-drop-master /etc/alternatives/sddm-debian-theme
wget "https://unsplash.com/photos/M6XC789HLe8/download?ixid=M3wxMjA3fDB8MXxjb2xsZWN0aW9ufDF8MjUxNzE4MzN8fHx8fDJ8fDE3NjE4MTQyMTB8&force=true&w=2400" -O /home/e/Images/1.jpg
cp /home/e/Images/1.jpg /usr/share/sddm/themes/sddm-eucalyptus-drop-master/Backgrounds
sed -i 's/ForceHideCompletePassword="false"/ForceHideCompletePassword="true"/g' /usr/share/sddm/themes/sddm-eucalyptus-drop-master/theme.conf
sed -i 's/david-clode-seM6i8gJ7d0-unsplash.jpg/1.jpg/g' /usr/share/sddm/themes/sddm-eucalyptus-drop-master/theme.conf

usermod -aG docker e
usermod -aG sudo e
usermod -s $(which zsh) e

## Configuration file
mkdir -p /home/e/.config/terminator/
mkdir -p /home/e/.config/i3/
mkdir -p /home/e/.config/i3status/
mkdir -p /home/e/.config/picom/

wget https://raw.githubusercontent.com/Oopsse/setup/refs/heads/main/.config/terminator/config -O /home/e/.config/terminator/config
wget https://raw.githubusercontent.com/Oopsse/setup/refs/heads/main/.config/i3/config -O /home/e/.config/i3/config
wget https://raw.githubusercontent.com/Oopsse/setup/refs/heads/main/.config/i3/tray -O /home/e/.config/i3/tray
wget https://raw.githubusercontent.com/Oopsse/setup/refs/heads/main/.config/i3/i3-battery-popup -O /home/e/.config/i3/i3-battery-popup
wget https://raw.githubusercontent.com/Oopsse/setup/refs/heads/main/.config/i3/launcher.rasi -O /home/e/.config/i3/launcher.rasi

chmod u+x /home/e/.config/i3/tray
chmod u+x /home/e/.config/i3/i3-battery-popup

wget https://raw.githubusercontent.com/Oopsse/setup/refs/heads/main/.config/i3status/config -O /home/e/.config/i3status/config

wget https://raw.githubusercontent.com/Oopsse/setup/refs/heads/main/.config/picom/config -O /home/e/.config/picom/config

chown -R e:e /home/e/Images/
chown -R e:e /home/e/.config/

## Font

wget https://github.com/adi1090x/polybar-themes/raw/refs/heads/master/fonts/iosevka_nerd_font.ttf -O /usr/local/share/fonts/iosevka_nerd_font.ttf
wget https://github.com/adi1090x/polybar-themes/raw/refs/heads/master/fonts/feather.ttf -O /usr/local/share/fonts/feather.ttf
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DejaVuSansMono.zip -O /dev/shm/DejaVuSansMono.zip
unzip /dev/shm/DejaVuSansMono.zip -d /usr/local/share/fonts/DejaVuSansMono-font
rm -rf /dev/shm/DejaVuSansMono.zip

### Xsecurelock
entries_db="/dev/shm/entries.json"
output_dir="/home/e/Vidéos/apple-aerial"

mkdir -p $output_dir
wget --no-check-certificate "https://sylvan.apple.com/Aerials/resources.tar" -O "/dev/shm/resources.tar"
tar -xf /dev/shm/resources.tar -C /dev/shm
rm /dev/shm/resources.tar
rm -rf /dev/shm/TVIdleScreenStrings.bundle

download() {
  url="$1"
  quality="$2"
  name=$(basename "$url")
  mkdir -p "$output_dir"
  output_file="$output_dir/$name"

  if [ ! -f "$output_file" ]; then
    echo "Downloading video in quality $quality from $url"
    wget --no-check-certificate "$url" -O "$output_file"
  fi
}

quality="4K-HDR"
#quality="4K-SDR"
#quality="1080-SDR"
#quality="1080-HDR"

for v in $(cat "$entries_db" | jq -r ".assets[] | .\"url-$quality\"" | shuf); do
  download "$v" "$quality"
done

chown -R e:e /home/e/Vidéos/

cat << EOF > /etc/environment
XSECURELOCK_SAVER=saver_mpv
XSECURELOCK_DISCARD_FIRST_KEYPRESS=0
XSECURELOCK_LIST_VIDEOS_COMMAND="find /home/e/Vidéos/apple-aerial/ -type f"
XSECURELOCK_PASSWORD_PROMPT=kaomoji
XSECURELOCK_SHOW_DATETIME=1
XSECURELOCK_COMPOSITE_OBSCURER=0
EOF

## Zsh pluggin
git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/e/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/e/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

## Obsidian
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.9.14/obsidian_1.9.14_amd64.deb -O /home/e/Téléchargements/obsidian_1.9.14_amd64.deb
dpkg -i /home/e/Téléchargements/obsidian_1.9.14_amd64.deb

## Exegol
su - e
pipx ensurepath && exec $SHELL
pipx install exegol
exegol install

## Set default program
xdg-settings set default-web-browser firefox-esr.desktop

## VMware
# Download VMware Workstation Pro for Linux 25H2
# Create an account and download https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro
# sudo ./VMware-Workstation-Full-17.5.2-23775571.x86_64.bundle

echo "Done!"
exit 0
