#!/bin/bash

if [ -n "$(grep -i WSL2 /proc/version)" ]; then
    # is WSL 2
    HTTP_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
    HTTP_PORT="7890"
    HTTP_PROXY_URL="http://$HTTP_IP:$HTTP_PORT"

    SOCKS_IP="$HTTP_IP"
    SOCKS_PORT="$HTTP_PORT"
    SOCKS_PROXY_URL="socks5://$SOCKS_IP:$SOCKS_PORT"
else
    HTTP_IP="localhost"
    HTTP_PORT="7890"
    HTTP_PROXY_URL="http://$HTTP_IP:$HTTP_PORT"

    SOCKS_IP="localhost"
    SOCKS_PORT="7891"
    SOCKS_PROXY_URL="socks5://$SOCKS_IP:$SOCKS_PORT"
fi

PH="# PROXY"
 
set_proxy() {
    export http_proxy="$HTTP_PROXY_URL"
    export HTTP_PROXY="$HTTP_PROXY_URL"
 
    export https_proxy="$HTTP_PROXY_URL"
    export HTTPS_proxy="$HTTP_PROXY_URL"
 
    export ALL_PROXY="$SOCKS_PROXY_URL"
    export all_proxy="$SOCKS_PROXY_URL"
 
    git config --global http.proxy $HTTP_PROXY_URL
    git config --global https.proxy $HTTP_PROXY_URL
 
    # git ssh proxy
    sed -i "/^\s*$PH\s*$/s/$PH/ProxyCommand nc -x $SOCKS_IP:$SOCKS_PORT %h %p $PH/" ~/.ssh/config
}
 
unset_proxy() {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset ALL_PROXY
    unset all_proxy
 
    git config --global --unset http.proxy
    git config --global --unset https.proxy
 
    sed -i "/$PH/s/ProxyCommand .* $PH/$PH/" ~/.ssh/config
}

 
test_proxy() {
    echo "HTTP proxy:" $https_proxy
    echo "All proxy:" $all_proxy
    echo "Git HTTP proxy:" $(git config --global --get https.proxy)
    echo "Git SOCKS proxy:" $(sed -n "s/^\s*ProxyCommand\s*//p" ~/.ssh/config)
}
