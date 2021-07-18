source $HOME/.config/nvim/vim-plug/plugins.vim

let mapleader = " "
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

syntax on
set tabstop=4 
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent

set hidden
set paste
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
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=80
set cmdheight=2
set termguicolors

colorscheme gruvbox

map <Leader>F :Files!<Enter>
