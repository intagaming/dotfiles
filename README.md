# dotfiles
my dotfiles on arch

To restore:

```shell
git clone --bare https://github.com/intagaming/dotfiles.git $HOME/.cfg

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

config checkout

config config --local status.showUntrackedFiles no
```




