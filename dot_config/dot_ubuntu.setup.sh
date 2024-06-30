#!/bin/bash

cd ~/
mkdir -p ~/Documents/repo

# install chezmoi
GITHUB_USERNAME="$1"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git

# add local gitconfig
echo "[user]
	name = 
	email = 
	username = $GITHUB_USERNAME
" >~/.gitconfig.local

# install rustup
# prompt Y/n for installation
if [ -z "$1" ]; then
	read -p "Do you want to install rustup? (Y/n) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	fi
fi

# install tailscale
# prompt Y/n for installation
if [ -z "$1" ]; then
	read -p "Do you want to install tailscale? (Y/n) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		curl -fsSL https://tailscale.com/install.sh | sh
	fi
fi

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# install vscode
curl -Lo Downloads/vscode.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
sudo apt install .Downloads/vscode.deb

# install dependencies from file
sudo apt install -y $(cat .ubuntu.apt.txt)

sudo apt update && sudo apt upgrade -y
