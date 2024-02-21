#!/bin/bash


curl https://www.linux-projects.org/listing/uv4l_repo/lpkey.asc | sudo tee /etc/apt/trusted.gpg.d/uv4l.asc
sudo bash -c 'echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/stretch stretch main" >> /etc/apt/sources.list'
sudo apt-get update
sudo apt-get install -f
sudo apt-get dist-upgrade -y
sudo apt-get install -y build-essential git wget vim uv4l uv4l-server uv4l-webrtc uv4l-uvc pulseaudio avahi-daemon
sudo systemctl enable avahi-daemon
sudo cp /usr/share/doc/avahi-daemon/examples/ssh.service /etc/avahi/services
sudo openssl genrsa -out /etc/ssl/private/selfsign.key 2048 &&  sudo openssl req -new -x509 -key /etc/ssl/private/selfsign.key -out /etc/ssl/certs/selfsign.crt -sha256
sudo reboot


