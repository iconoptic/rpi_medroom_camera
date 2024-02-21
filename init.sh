#!/bin/bash

if [[ $UID -ne 0 ]]; then
	echo "Please run this script as root."
	exit 1
fi

# Find SD card
sd_path="$(fdisk -l | grep -B1 'SD' | grep -o '/dev/[^:]*')"
if [[ $(echo "$sd_path" | wc -l) -ne 1 ]]; then
	echo "Please insert SD card to begin."
	exit 10
fi
# Unmount
fdisk -l $sd_path | grep -o "$sd_path[0-9]" | while read line; do
	umount "$line"
done

disk_img="$(ls | grep img$)"
echo "Writing $disk_img to $sd_path..."
dd if=$disk_img of=$sd_path bs=4M conv=fsync status=progress

read -p "Please remove and reinsert SD card, then press a key to continue."

mkdir /mnt/boot
mkdir /mnt/rootfs

mount /dev/sda1 /mnt/boot
mount /dev/sda2 /mnt/rootfs

pushd /mnt/boot #"$(lsblk $sd_path | grep boot | sed 's/^.* \//\//g')"
touch ssh
echo 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
    ssid="MSU-Nursing"
    psk="Nurs!ngS1m"
    key_mgmt=WPA-PSK
}
' > wpa_supplicant.conf
vim wpa_supplicant.conf

echo -n "Enter new username: "
read user_name
echo -n "Enter new password: "
read passw

echo "$user_name:$(echo $passw | openssl passwd -6 -stdin)" > userconf

popd

#move config/setup files
cp payload/* /mnt/rootfs/root/

umount /dev/sda1
umount /dev/sda2

rmdir /mnt/boot
rmdir /mnt/rootfs

echo "Please insert SD card into Raspberry Pi."
