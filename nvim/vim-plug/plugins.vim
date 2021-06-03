" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "autocmd VimEnter * PlugInstall
    "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    Plug 'gruvbox-community/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'tpope/vim-surround'
    Plug 'scrooloose/nerdtree'
    Plug 'ycm-core/YouCompleteMe'
    Plug 'frazrepo/vim-rainbow'
    Plug 'jiangmiao/auto-pairs'
call plug#end()
