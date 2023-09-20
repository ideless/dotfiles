#!/bin/bash

# RUN WITH ROOT

set -e -x
export TERM="xterm-256color"

# parse arguments

USERNAME=""
PASSWORD=""

while [ "$#" -gt 0 ]; do
    case $1 in
        --username) USERNAME=$2; shift ;;
        --password) PASSWORD=$2; shift ;;
    esac
    shift
done

[ "$USERNAME" = "" ] && echo "Provide a username!" && exit 1
[ "$PASSWORD" = "" ] && echo "Provide a password!" && exit 1

# use bfsu apt source

source /etc/os-release

if [ $ID != "ubuntu" ]; then
    echo "This script should be run on ubuntu"
    exit 1
fi

mv /etc/apt/sources.list /etc/apt/sources.list.bak

cat <<EOF > /etc/apt/sources.list
deb https://mirrors.bfsu.edu.cn/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse
deb https://mirrors.bfsu.edu.cn/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse
deb https://mirrors.bfsu.edu.cn/ubuntu/ ${UBUNTU_CODENAME}-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse
EOF

# apt update and install essentials

apt update
apt install -y ca-certificates locales sudo
update-ca-certificates

# add user

locale-gen en_US.UTF-8
useradd -s /bin/bash -m -G sudo $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

# install other useful packages

apt install -y curl htop iputils-ping git make tar
