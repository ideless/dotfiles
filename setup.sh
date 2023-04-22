#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

if confirm "Link tmux config"; then
    create_link "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

if confirm "Link vim config"; then
    create_link "$SCRIPT_DIR/vim/.vimrc" "$HOME/.vimrc"
fi

if confirm "Link nvim config"; then
    create_link "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
fi

if confirm "Link zathura config"; then
    create_link "$SCRIPT_DIR/zathura" "$HOME/.config/zathura"
fi

if confirm "Link bash scripts"; then
    create_link "$SCRIPT_DIR/scripts" "$HOME/scripts"
    echo "You should manually add scripts to your .bashrc file"
fi
