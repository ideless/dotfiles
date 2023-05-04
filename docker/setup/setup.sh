#!/bin/bash

username=""
password=""

while [ "$#" -gt 0 ]; do
    case $1 in
        --username) username=$2; shift ;;
        --password) password=$2; shift ;;
    esac
    shift
done

[ "$username" = "" ] && echo "Provide a username!" && exit 1
[ "$password" = "" ] && echo "Provide a password!" && exit 1

chmod 777 /tmp/* -R

bash -ex apt.sh
bash -ex add_user.sh $username $password
