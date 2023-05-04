#!/bin/bash

username=""
password=""
tag=""
version="latest"

while [ "$#" -gt 0 ]; do
    case $1 in
        --username) username=$2; shift ;;
        --password) password=$2; shift ;;
        --tag) tag=$2; shift ;;
        --version) version=$2; shift ;;
    esac
    shift
done

print_usage() {
    cat << EOF
Build a docker development image.
bash ./build.sh --username <xxx> --password <xxx> --tag <xxx>
Example: bash ./build.sh --username dev --password dev --tag dev-img

    --username  The username used in built docker image.
    --password  Similar as above.
    --tag       Docker image tag, e.g., dev:god.
    --version   Ubuntu version tag, see https://hub.docker.com/_/ubuntu.
EOF
}

[ "$username" = "" ] && echo "Must provide a username!" && print_usage && exit 1
[ "$password" = "" ] && echo "Must provide a password!" && print_usage && exit 1
[ "$tag" = "" ] && echo "Must provide a tag!" && print_usage && exit 1

set -o xtrace

cat Dockerfile \
    | sed s/username=/username=$username/g \
    | sed s/password=/password=$password/g \
    | sed s/ubuntu:/ubuntu:$version/g \
    | docker build -t $tag . -f -
