#!/bin/bash

# Installation
# sh -c "$(wget https://raw.githubusercontent.com/Oopsse/setup/main/install.sh -O -)"

export DEBIAN_FRONTEND=noninteractive

KERNEL="linux-image-6.16.3+deb13-amd64"
LUKS="plymouth plymouth-themes"
DM="sddm sddm-theme-breeze"
WM="xinit xorg xorg-dev xbacklight i3 xsecurelock libnotify-bin libnotify-dev picom"
SYSTEM="lxpolkit build-essential linux-headers-$(uname -r) autorandr make gcc file zsh tree pasystray arandr krb5-user sudo dunst libnotify-bin iotop usbutils inxi acpi firmware-linux-free lsb-release dbus dbus-x11 systemd-timesyncd brightnessctl pipewire-pulse"
NETWORK="blueman network-manager-applet"
# ImageViewer BackgroundImage Snapshot Terminal TextEditor Browser VideoViewer PDFViewer
UTILS="fonts-recommended fonts-font-awesome fonts-terminus keepassxc-full okular qimgv feh flameshot terminator openssh-client neovim git jq curl wget ca-certificates dnsutils xclip ncdu x11-utils rofi make htop chromium firefox-esr-l10n-fr vlc python3 python3-pip pipx mpv"
DISK="thunar thunar-volman thunar-archive-plugin thunar-vcs-plugin gvfs-fuse gvfs-backends ntfs-3g exfatprogs exfat-fuse dosfstools partitionmanager gdisk unzip smbclient cifs-utils"

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
wget "https://images2.alphacoders.com/117/1171867.png" -O /usr/share/wallpapers/Next/contents/images/1.png
sed -i 's/background=.*$/background=\/usr\/share\/wallpapers\/Next\/contents\/images\/1.png/' /usr/share/sddm/themes/breeze/theme.conf
chown root:root "/usr/share/wallpapers/Next/contents/images/1.png"
chmod 644 "/usr/share/wallpapers/Next/contents/images/1.png"

usermod -aG docker e
usermod -aG sudo e

## Zsh
chsh -s $(which zsh) e

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

#quality="4K-HDR"
quality="4K-SDR"
#quality="1080-SDR"
#quality="1080-HDR"

for v in $(cat "$entries_db" | jq -r ".assets[] | .\"url-$quality\"" | shuf); do
  download "$v" "$quality"
done

chown -R e:e /home/e/Vidéos/apple-aerial

cat << EOF > /etc/environment
XSECURELOCK_SAVER=saver_mpv
XSECURELOCK_DISCARD_FIRST_KEYPRESS=0
XSECURELOCK_LIST_VIDEOS_COMMAND="find /home/e/Vidéos/apple-aerial/ -type f"
XSECURELOCK_PASSWORD_PROMPT=kaomoji
XSECURELOCK_SHOW_DATETIME=1
EOF

## Exegol
su - e
pipx ensurepath && exec $SHELL
pipx install exegol
exegol install

## Obsidian
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.9.14/obsidian_1.9.14_amd64.deb -O /home/e/Téléchargements/obsidian_1.9.14_amd64.deb

## VMware
#git clone https://github.com/Technogeezer50/vmware-host-modules.git
#cd vmware-host-modules
# Check out the latest commit to the workstation-17.6.4 branch
#git checkout workstation-17.6.4
# Now you can go ahead and make the modules
make
# If module compilation is successful, install the new modules
#sudo make install


echo "Done!"
exit 0
