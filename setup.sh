#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
INSTRUCTIONS_FILE="$(pwd)/instructions.txt"

cat <<EOF >"$INSTRUCTIONS_FILE"
# add to profile
function add_path() {
    if [[ ":\$PATH:" != *":\$1:"* ]]; then
        export PATH="\$1:\$PATH"
    fi
}
EOF

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

# from SO: https://stackoverflow.com/a/54261882/317605 (by https://stackoverflow.com/users/8207842/dols3m)
function multiselect {
    printf "j/k/up/down to navigate; x/space to toggle; enter to submit.\n"

    # little helpers for terminal print control and key input
    ESC=$(printf "\033")
    cursor_blink_on() { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to() { printf "$ESC[$1;${2:-1}H"; }
    print_inactive() { printf "$2   $1 "; }
    print_active() { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row() {
        IFS=';' read -sdR -p $'\E[6n' ROW COL
        echo ${ROW#*[}
    }
    key_input() {
        local key
        IFS= read -rsn1 key 2>/dev/null >&2
        if [[ $key = "j" ]]; then echo down; fi
        if [[ $key = "k" ]]; then echo up; fi
        if [[ $key = $'\x1b' ]]; then
            read -rsn2 key
            if [[ $key = [A ]]; then echo up; fi
            if [[ $key = [B ]]; then echo down; fi
        fi
        if [[ $key = "x" ]]; then echo toggle; fi
        if [[ $key = $'\x20' ]]; then echo toggle; fi
        if [[ $key = "" ]]; then echo submit; fi
    }
    toggle_option() {
        local arr_name=$1
        eval "local arr=(\"\${${arr_name}[@]}\")"
        local option=$2
        if [[ ${arr[option]} == true ]]; then
            arr[option]=false
        else
            arr[option]=true
        fi
        eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options     # string[]
    local defaults    # bool[]
    local selected=() # bool[]

    IFS=';' read -r -a options <<<"$2"

    if [[ -z $3 ]]; then
        defaults=()
    else
        IFS=';' read -r -a defaults <<<"$3"
    fi

    for i in "${!options[@]}"; do
        selected+=("${defaults[i]:-false}")
        printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=$(get_cursor_row)
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        for i in "${!options[@]}"; do
            local prefix="[ ]"
            if [[ ${selected[$i]} == true ]]; then
                prefix="[x]"
            fi

            cursor_to $(($startrow + $i))
            if [ $i -eq $active ]; then
                print_active "${options[$i]}" "$prefix"
            else
                print_inactive "${options[$i]}" "$prefix"
            fi
        done

        # user key control
        case $(key_input) in
        up)
            ((active--)) || true # avoid exiting with error
            if [ $active -lt 0 ]; then
                active=$((${#options[@]} - 1))
            fi
            ;;
        down)
            ((active++)) || true
            if [ $active -ge ${#options[@]} ]; then
                active=0
            fi
            ;;
        toggle) toggle_option selected $active ;;
        submit) break ;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
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

function write_instruction {
    echo "$1" >>"$INSTRUCTIONS_FILE"
}

# jobs

function setup_tmux {
    if ! installed "tmux"; then
        sudo apt install tmux -y
    fi
    create_link "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
}

function setup_vim_tiny {
    if ! installed "vi"; then
        sudo apt install vim-tiny -y
    fi
    create_link "$SCRIPT_DIR/vim/vimrc" "$HOME/.vimrc"
}

function setup_nvim {
    if ! installed "nvim"; then
        nvim_prefix=$(input "Input nvim installation path" "$HOME/.local/apps/nvim")
        mkdir -p "$nvim_prefix"
        pushd "$nvim_prefix"
        curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
        chmod u+x nvim.appimage
        if [ -n "$(dpkg -l | grep libfuse2)" ]; then
            write_instruction "alias nvim=\"$nvim_prefix/nvim.appimage\""
        else
            warn "You do not seem to have fuse installed, extracting nvim.appimage..."
            ./nvim.appimage --appimage-extract
            write_instruction "add_path \"$nvim_prefix/squashfs-root/usr/bin\""
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
        write_instruction "add_path $HOME/.local/bin"
    fi
}

function setup_zathura {
    if ! installed "zathura"; then
        sudo apt install zathura -y
    fi
    create_link "$SCRIPT_DIR/zathura" "$HOME/.config/zathura"
}

function setup_zsh {
    if ! installed "zsh"; then
        sudo apt install zsh -y
    fi
    # set zsh as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        write_instruction "exec zsh -l"
    fi
    # install oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended
        write_instruction "omz plugin enable git ssh-agent"
    fi
    # install zsh-autosuggestions
    zas_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    if [ ! -d "$zas_prefix" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zas_prefix"
        sed -i "s/ZSH_AUTOSUGGEST_STRATEGY=(history)/ZSH_AUTOSUGGEST_STRATEGY=(history completion)/" "$zas_prefix/zsh-autosuggestions.zsh"
        write_instruction "omz plugin enable zsh-autosuggestions"
    fi
    # install powerlevel10k
    pl_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ ! -d "$pl_prefix" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$pl_prefix"
        write_instruction "omz theme set powerlevel10k/powerlevel10k"
    fi
    # install zsh-vi-mode
    zvm_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
    if [ ! -d "$zvm_prefix" ]; then
        git clone https://github.com/jeffreytse/zsh-vi-mode "$zvm_prefix"
        write_instruction "omz plugin enable zsh-vi-mode"
    fi
    # install zsh-z
    zz_prefix="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-z"
    if [ ! -d "$zz_prefix" ]; then
        git clone https://github.com/agkozak/zsh-z "$zz_prefix"
        write_instruction "omz plugin enable zsh-z"
    fi
}

function setup_nodejs {
    if ! installed "node"; then
        n_prefix=$(input "Input n installation path" "$HOME/.local/apps/n")
        curl -L https://git.io/n-install | N_PREFIX="$n_prefix" bash -s -- -y latest
        write_instruction "export N_PREFIX=\"$n_prefix\""
        write_instruction "add_path \"$n_prefix/bin\""
    fi
    if ! installed "yarn"; then
        write_instruction "corepack enable"
    fi
}

function setup_xplr {
    if ! installed "xplr"; then
        xplr_prefix=$(input "Input xplr installation path" "$HOME/.local/apps/xplr")
        mkdir -p "$xplr_prefix"
        pushd "$xplr_prefix"
        gzfile="xplr-linux.tar.gz"
        curl -LO https://github.com/sayanarijit/xplr/releases/latest/download/$gzfile
        tar xzvf $gzfile
        rm $gzfile
        popd
        write_instruction "add_path \"$xplr_prefix\""
    fi
}

function setup_gitui {
    if ! installed "gitui"; then
        gitui_prefix=$(input "Input gitui installation path" "$HOME/.local/apps/gitui")
        mkdir -p "$gitui_prefix"
        pushd "$gitui_prefix"
        gzfile="gitui-linux-musl.tar.gz"
        curl -LO https://github.com/extrawurst/gitui/releases/latest/download/$gzfile
        tar xzvf $gzfile
        rm $gzfile
        popd
        write_instruction "add_path \"$gitui_prefix\""
    fi
    create_link "$SCRIPT_DIR/gitui" "$HOME/.config/gitui"
}

function setup_scripts {
    create_link "$SCRIPT_DIR/scripts" "$HOME/scripts"
}

function setup_rust {
    curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
}

function setup_wezterm {
    if ! installed "wezterm"; then
        # TODO: test this
        if ! installed "cargo"; then
            setup_rust
        fi
        # build from source
        git clone --depth=1 --branch=main --recursive https://github.com/wez/wezterm.git
        pushd wezterm
        git submodule update --init --recursive
        ./get-deps
        cargo build --release
        popd
        # create installation directory
        wezterm_prefix=$(input "Input wezterm installation path" "$HOME/.local/apps/wezterm")
        mkdir -p "$wezterm_prefix"
        # copying binaries
        pushd wezterm/target/release
        cp wezterm wezterm-gui wezterm-mux-server "$wezterm_prefix"
        popd
        write_instruction "add_path \"$wezterm_prefix\""
        # creating .desktop file
        desktop_dir="$HOME/.local/share/applications"
        mkdir -p "$desktop_dir"
        cp wezterm/assets/wezterm.desktop "$desktop_dir"
        desktop_file="$desktop_dir/wezterm.desktop"
        sed -i "s|^TryExec=.*|TryExec=$wezterm_prefix/wezterm|" "$desktop_file"
        sed -i "s|^Exec=.*|Exec=$wezterm_prefix/wezterm start --cwd .|" "$desktop_file"
        # copying icon
        icon_dir="$HOME/.local/share/icons"
        mkdir -p "$icon_dir"
        cp wezterm/assets/icon/wezterm-icon.svg "$icon_dir/org.wezfurlong.wezterm.svg"
        # add context menu item
        sudo apt install -y python3-nautilus
        nautilus_dir="$HOME/.local/share/nautilus-python/extensions"
        cp wezterm/assets/wezterm-nautilus.py "$nautilus_dir"
        sed -i "s|'wezterm'|'$wezterm_prefix/wezterm'|" "$nautilus_dir/wezterm-nautilus.py"
        # clean up
        rm -rf wezterm
    fi
    create_link "$SCRIPT_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
}

function setup_pipenv {
    if ! installed "pipenv"; then
        # sudo apt install -y python3-pip
        # sudo pip install pipenv
        # TODO: test this
        sudo apt install -y pipenv python3-pip
    fi
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

# Step 3: jobs
jobs=(
    "tmux"
    "vim_tiny"
    "nvim"
    "zathura"
    "zsh"
    "nodejs"
    "xplr"
    "gitui"
    "scripts"
    "rust"
    "wezterm"
    "pipenv"
)
for job in "${jobs[@]}"; do
    options_string+="$job;"
done
multiselect checked "$options_string"
for i in "${!jobs[@]}"; do
    if [ "${checked[i]}" = true ]; then
        info "--- Setup ${jobs[$i]} ---"
        write_instruction "# ${jobs[$i]}"
        setup_${jobs[$i]}
    fi
done

# Step 4: cleanup
if [ "$should_unset_proxy" = true ]; then
    unset_proxy
fi
