local o = vim.o
local wo = vim.wo
local bo = vim.bo

o.tabstop=4
o.softtabstop=4
o.shiftwidth=4
o.cmdheight=1
o.laststatus=1
-- o.undodir='~/.nvim/undodir'

vim.cmd([[
set smarttab
set expandtab
set autoindent
set exrc
set guicursor=
set hidden
set ignorecase
set incsearch
set number
set nu
set nohlsearch
set noerrorbells
set nowrap
set noswapfile
set nobackup
set relativenumber
set scrolloff=8
set signcolumn=yes
set smartcase
set undofile
set nobackup
set hidden
set termguicolors
colorscheme melange
]])
