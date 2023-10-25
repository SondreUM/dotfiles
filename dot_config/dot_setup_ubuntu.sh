#!/bin/bash

cd ~/

# install chezmoi
GITHUB_USERNAME="$1"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git

# add local gitconfig
echo "[user]
	name = 
	email = 
	username = $GITHUB_USERNAME
" > ~/.gitconfig.local


# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# install vscode
curl -Lo Downloads/vscode.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
sudo apt install .Downloads/vscode.deb

# install dependencies from file
sudo apt install -y $(cat .dep_ubuntu.txt)

