#!/bin/bash

username=$1
password=$2
echo "Adding user $username"
locale-gen en_US.UTF-8
useradd -s /bin/bash -m -G sudo $username
echo "$username:$password" | chpasswd
