#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function info {
    echo "$(tput setaf 2)$1$(tput sgr0)"
}

function warn {
    echo "$(tput setaf 3)$1$(tput sgr0)"
}

function error {
    echo "$(tput setaf 1)$1$(tput sgr0)"
}

function create_link {
    mkdir -p "$(dirname "$2")"
    if [ ! -e "$2" ]; then
        ln -s "$1" "$2"
        echo "Created link $2 -> $1"
    else
        if [ ! -L "$2" ] || [ "$(readlink "$2")" != "$1" ]; then
            read -p "$2 exists and is not a link to $1. Do you want to override it? [y/n] " answer
            if [ "$answer" == "y" ]; then
                rm -rf "$2"
                ln -s "$1" "$2"
                echo "Created link $2 -> $1"
            else
                echo "Skipping $2"
            fi
        else
            echo "Link $2 -> $1 exists"
        fi
    fi
}

function confirm {
    echo "--- $1 ---"
    read -p "Do you want to continue? [y/n] " answer
    if [ "$answer" == "y" ]; then
        return 0
    else
        return 1
    fi
}

function input {
    read -p "$1 (default: $2):" answer
    if [ -z "$answer" ]; then
        return "$2"
    else
        return "$answer"
    fi
}

function set_proxy {
    export http_proxy="http://$1:$2"
    export https_proxy="$http_proxy"
    export all_proxy="socks5://$3:$4"

    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$https_proxy"
    export ALL_PROXY="$all_proxy"

    git config --global http.proxy "$http_proxy"
    git config --global https.proxy "$https_proxy"
}

function unset_proxy {
    unset http_proxy
    unset https_proxy
    unset all_proxy

    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset ALL_PROXY

    git config --global --unset http.proxy
    git config --global --unset https.proxy
}

function installed {
    [ -x "$(command -v $1)" ]
}

# Step 1: check prerequisites
prerequisites=(
    "git"
    "curl"
)
all_installed=true
for cmd in "${prerequisites[@]}"; do
    if installed "$cmd"; then
        info "$cmd: installed"
    else
        error "$cmd: not installed"
        all_installed=false
    fi
done
if [ "$all_installed" = false ]; then
    echo "Please install missing packages"
    exit 1
fi

# Step 2: set proxy
should_unset_proxy=false
if confirm "Set proxy"; then
    read -p "HTTP proxy host: " http_host
    read -p "HTTP proxy port: " http_port
    read -p "SOCKS proxy host: " socks_host
    read -p "SOCKS proxy port: " socks_port
    set_proxy "$http_host" "$http_port" "$socks_host" "$socks_port"
    should_unset_proxy=true
fi

# Step 3: jobs
should_add_env=()

if confirm "Setup tmux"; then
    if ! installed "tmux"; then
        sudo apt install tmux -y || exit 1
    fi
    create_link "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

if confirm "Setup vim"; then
    if ! installed "vim"; then
        sudo apt install vim -y || exit 1
    fi
    create_link "$SCRIPT_DIR/vim/.vimrc" "$HOME/.vimrc"
fi

if confirm "Setup nvim"; then
    if ! installed "nvim"; then
        nvim_prefix=$(input "Input nvim installation path" "$HOME/.local/apps/nvim")
        mkdir -p "$nvim_prefix"
        pushd "$nvim_prefix"
        curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
        chmod u+x nvim.appimage
        if [ -d "/dev/fuse" ]; then
            should_add_env+=("alias vim=\"$nvim_prefix/nvim.appimage\"")
        else
            ./nvim.appimage --appimage-extract
            should_add_env+=("add_path $nvim_prefix/squashfs-root/usr/bin")
        fi
        popd
    fi
    create_link "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
fi

if confirm "Link zathura config"; then
    if ! installed "zathura"; then
        sudo apt install zathura -y || exit 1
    fi
    create_link "$SCRIPT_DIR/zathura" "$HOME/.config/zathura"
fi

if confirm "Link bash scripts"; then
    create_link "$SCRIPT_DIR/scripts" "$HOME/scripts"
    echo "You should manually add scripts to your .bashrc file"
fi

# Step 4: cleanup
if [ "$should_unset_proxy" = true ]; then
    unset_proxy
fi
if [ "${#should_add_env[@]}" -gt 0 ]; then
    warn "You should manually add the following to profile:"
    cat << EOF

function add_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

EOF
    for env in "${should_add_env[@]}"; do
        echo "$env"
    done
fi
