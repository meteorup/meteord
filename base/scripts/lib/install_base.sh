#!/bin/bash
set -e
cat << EOF >/etc/apt/sources.list 
deb http://mirrors.163.com/debian/ wheezy main non-free contrib
deb http://mirrors.163.com/debian/ wheezy-updates main non-free contrib
deb http://mirrors.163.com/debian/ wheezy-backports main non-free contrib
deb-src http://mirrors.163.com/debian/ wheezy main non-free contrib
deb-src http://mirrors.163.com/debian/ wheezy-updates main non-free contrib
deb-src http://mirrors.163.com/debian/ wheezy-backports main non-free contrib
deb http://mirrors.163.com/debian-security/ wheezy/updates main non-free contrib
deb-src http://mirrors.163.com/debian-security/ wheezy/updates main non-free contrib 
deb http://mirrors.aliyuncs.com/debian/ wheezy main non-free contrib
deb http://mirrors.aliyuncs.com/debian/ wheezy-proposed-updates main non-free contrib
deb-src http://mirrors.aliyuncs.com/debian/ wheezy main non-free contrib
deb-src http://mirrors.aliyuncs.com/debian/ wheezy-proposed-updates main non-free contrib
EOF
apt-get update -y
apt-get install -y libfreetype6 libfreetype6-dev fontconfig curl bzip2 build-essential python git libssl-dev imagemagick graphicsmagick

