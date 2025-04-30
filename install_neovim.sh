#!/usr/bin/env bash

echo install npm and nodejs
echo
sudo apt install -y npm nodejs

echo
echo npm
npm -v
echo node
node -v
echo

pip install debugpy

cd ~/Downloads

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
