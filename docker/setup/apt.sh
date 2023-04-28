#!/bin/bash

apt update
apt install -y ca-certificates locales sudo
update-ca-certificates
echo \"debconf debconf/frontend select Noninteractive\" | debconf-set-selections
