#!/bin/bash

username=$1
password=$2
echo "Adding user $username"
locale-gen en_US.UTF-8
adduser --quiet --disabled-password --shell /bin/bash --home /home/$username --gecos \"User\" $username
echo "$username:$password" | chpasswd
usermod -aG sudo $username
