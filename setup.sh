#!/bin/bash

sudo apt install zsh
chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


sudo apt-get install fonts-powerline
sed 's/robbyrussell/agnoster/g' ~/.zshrc

