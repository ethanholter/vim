#! /usr/bin/env bash
set -euo pipefail

if [ -f "${HOME}/.vimrc" ]; then
    rm -i "${HOME}/.vimrc" 
fi

if [ ! -d "${HOME}/.config/vim" ]; then
    git clone https://github.com/ethanholter/vim "${HOME}/.config/vim"
else
    (cd ${HOME}/.config/vim && git pull)
fi

if [ ! -f "${HOME}/.vimrc" ]; then
    ln -s "${HOME}/.config/vim/.vimrc" "${HOME}/.vimrc"
fi

echo "success"

