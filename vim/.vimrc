let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader = " "
map <C-f> <Esc><Esc>:Files!<CR>
inoremap <C-f> <Esc><Esc>:BLines!<CR>
map <C-g> <Esc><Esc>:BCommits<CR>

syntax on
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set clipboard=unnamedplus
set exrc
set guicursor=
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir/
set undofile
set incsearch
set scrolloff=8

call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

colorscheme gruvbox

