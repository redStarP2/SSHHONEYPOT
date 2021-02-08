#!/bin/bash

# t4lha
# Ubuntu 20.10 
# docker ve docker-compose kurulum

if ! [ $(id -u) = 0 ]; then
   echo "Bu Script root haklari ile calistirilmalidir." >&2
   exit 1
fi

apt update -y && apt upgrade -y 
apt install -y docker.io figlet

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


figlet KURULUM BITTI! 



