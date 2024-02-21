#!/bin/bash

cd ~
git clone https://github.com/lwfinger/rtl8188eu.git

cd rtl8188eu
coreNum="$(cat /proc/cpuinfo | grep processor | wc -l)"
make -j$coreNum
sudo make install
sudo vim /etc/wpa_supplicant/wpa_supplicant.conf
sudo bash -c 'echo "auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
	address 10.5.5.124/24
	gateway 10.5.5.1
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
" >> /etc/network/interfaces'
sudo reboot
