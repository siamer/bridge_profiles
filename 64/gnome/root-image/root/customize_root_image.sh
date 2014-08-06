#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/58-lcdfilter.conf

usermod -s /bin/bash root
cp -aT /etc/skel/ /root/

# set root password 
echo "root:root" | chpasswd

useradd -m -k /etc/skel -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash live

chmod 440 /etc/sudoers

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

systemctl enable multi-user.target pacman-init.service NetworkManager.service choose-mirror.service
