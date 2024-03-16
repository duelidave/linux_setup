===
# USAGE

## nvim
```
ln -s $(pwd)/nvim/ ~/.config/nvim

comment:
require('mymason')
require('core/maps')
colorscheme melange

git config --global core.editor "vim"
```

## tmux
```
ln -s ~/dev/linux_setup/tmux/.tmux.conf .tmux.conf
```

## zsh
```
ln -s ~/dev/linux_setup/zsh/.zshrc .zshrc
```

## snap
```
sudo snap set system refresh.retain=2
```
===
