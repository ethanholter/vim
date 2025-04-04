#! /usr/bin/env bash
set -euo pipefail

if [ -f "${HOME}/.vimrc" ]; then
    echo "vimrc already exists. Please delete it and try again."
    exit -1
fi

if [ ! -f "${HOME}/.config/vim" ]; then
    git clone https://github.com/ethanholter/vim "${HOME}/.config/vim"
fi

ln -s "${HOME}/.config/vim/.vimrc" "${HOME}/.vimrc"

echo "success"
