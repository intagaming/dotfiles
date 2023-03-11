# .dotfiles

## Installation

1. Install `git`
2. Copy and paste these into the terminal:

```sh
cd ~
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/intagaming/.dotfiles.git $HOME/.cfg
config checkout
config submodule init
config submodule update

```

3. Here's some packages to install: `fish starship neovim ripgrep`
