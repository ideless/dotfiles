#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function info {
    echo "$(tput setaf 2)$1$(tput sgr0)"
}

function warn {
    echo "$(tput setaf 3)$1$(tput sgr0)"
}

function error {
    echo "$(tput setaf 1)$1$(tput sgr0)" >&2
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
    if [ -z $2 ]; then
        read -p "$1: " answer
        echo "$answer"
    else
        read -p "$1 (default: $2): " answer
        if [ -z "$answer" ]; then
            echo "$2"
        else
            echo "$answer"
        fi
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

# Step 1: install prerequisites
prerequisites=(
    "git"
    "curl"
    "make"
    "tar"
)
for cmd in "${prerequisites[@]}"; do
    if installed "$cmd"; then
        info "$cmd: installed"
    else
        error "$cmd: not installed"
        sudo apt install "$cmd" -y
    fi
done

# Step 2: prepare (proxy, global variables, etc.)
should_unset_proxy=false
if confirm "Set proxy"; then
    http_host=$(input "HTTP proxy host" "localhost")
    http_port=$(input "HTTP proxy port" "7890")
    socks_host=$(input "SOCKS proxy host" "localhost")
    socks_port=$(input "SOCKS proxy port" "7891")
    set_proxy "$http_host" "$http_port" "$socks_host" "$socks_port"
    should_unset_proxy=true
fi

should_manually_do=()

# Step 3: jobs
if confirm "Setup tmux"; then
    if ! installed "tmux"; then
        sudo apt install tmux -y
    fi
    create_link "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

if confirm "Setup vim-tiny"; then
    if ! installed "vi"; then
        sudo apt install vim-tiny -y
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
            should_manually_do+=("alias vim=\"$nvim_prefix/nvim.appimage\"")
        else
            echo "You do not seem to have fuse installed, extracting nvim.appimage..."
            ./nvim.appimage --appimage-extract
            should_manually_do+=("add_path \"$nvim_prefix/squashfs-root/usr/bin\"")
        fi
        popd
    fi
    create_link "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
    if ! installed "rg"; then
        sudo apt install ripgrep -y
    fi
    sudo apt install python3-venv -y
    if ! installed "fd"; then
        sudo apt install fd-find -y
        mkdir -p ~/.local/bin
        ln -s $(which fdfind) ~/.local/bin/fd
        should_manually_do+=("add_path \"\$HOME/.local/bin\"")
    fi
fi

if confirm "Setup zathura"; then
    if ! installed "zathura"; then
        sudo apt install zathura -y
    fi
    create_link "$SCRIPT_DIR/zathura" "$HOME/.config/zathura"
fi

if confirm "Setup zsh"; then
    if ! installed "zsh"; then
        sudo apt install zsh -y
    fi
    # set zsh as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        shoumd_manually_do+=("exec zsh -l")
    fi
    # install oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended
        should_manually_do+=("omz plugin enable git ssh-agent")
    fi
    # install zsh-autosuggestions
    zas_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    if [ ! -d "$zas_prefix" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zas_prefix"
        sed -i "s/ZSH_AUTOSUGGEST_STRATEGY=(history)/ZSH_AUTOSUGGEST_STRATEGY=(history completion)/" "$zas_prefix/zsh-autosuggestions.zsh"
        should_manually_do+=("omz plugin enable zsh-autosuggestions")
    fi
    # install powerlevel10k
    pl_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ ! -d "$pl_prefix" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$pl_prefix"
        should_manually_do+=("omz theme set powerlevel10k/powerlevel10k")
    fi
    # install zsh-vi-mode
    zvm_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
    if [ ! -d "$zvm_prefix" ]; then
        git clone https://github.com/jeffreytse/zsh-vi-mode "$zvm_prefix"
        should_manually_do+=("omz plugin enable zsh-vi-mode")
    fi
    # install zsh-z
    zz_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-z"
    if [ ! -d "$zz_prefix" ]; then
        git clone https://github.com/agkozak/zsh-z "$zz_prefix"
        should_manually_do+=("omz plugin enable zsh-z")
    fi
fi


if confirm "Setup nodejs"; then
    if ! installed "node"; then
        n_prefix=$(input "Input n installation path" "$HOME/.local/apps/n")
        curl -L https://git.io/n-install | N_PREFIX="$n_prefix" bash -s -- -y latest
        should_manually_do+=("add_path \"$n_prefix/bin\"")
    fi
    if ! installed "yarn"; then
        should_manually_do+=("corepack enable")
    fi
fi

if confirm "Setup xplr"; then
    if ! installed "xplr"; then
        xplr_prefix=$(input "Input xplr installation path" "$HOME/.local/apps/xplr")
        mkdir -p "$xplr_prefix"
        pushd "$xplr_prefix"
        gzfile="xplr-linux.tar.gz"
        curl -LO https://github.com/sayanarijit/xplr/releases/latest/download/$gzfile
        tar xzvf $gzfile
        rm $gzfile
        popd
        should_manually_do+=("add_path \"$xplr_prefix\"")
    fi
fi

if confirm "Setup gitui"; then
    if ! installed "gitui"; then
        gitui_prefix=$(input "Input gitui installation path" "$HOME/.local/apps/gitui")
        mkdir -p "$gitui_prefix"
        pushd "$gitui_prefix"
        gzfile="gitui-linux-musl.tar.gz"
        curl -LO https://github.com/extrawurst/gitui/releases/latest/download/$gzfile
        tar xzvf $gzfile
        rm $gzfile
        popd
        should_manually_do+=("add_path \"$gitui_prefix\"")
    fi
fi

if confirm "Link bash scripts"; then
    create_link "$SCRIPT_DIR/scripts" "$HOME/scripts"
fi

if confirm "Setup rust"; then
    curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
fi

if confirm "Setup wezterm"; then
    create_link "$SCRIPT_DIR/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
fi

# Step 4: cleanup
if [ "$should_unset_proxy" = true ]; then
    unset_proxy
fi
if [ "${#should_manually_do[@]}" -gt 0 ]; then
    warn "You should manually do the following:"
    cat << EOF

# add to profile
function add_path() {
    if [[ ":\$PATH:" != *":\$1:"* ]]; then
        export PATH="\$1:\$PATH"
    fi
}

EOF
    for cmd in "${should_manually_do[@]}"; do
        echo "$cmd"
    done
fi
