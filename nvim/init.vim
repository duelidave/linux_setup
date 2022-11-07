" Python3 config
le g:python3_host_prog = '~/.pyenv/shims/python'

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
    Plug 'gennaro-tedesco/nvim-peekup'
    Plug 'tpope/vim-sensible'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'gruvbox-community/gruvbox'
	Plug 'itchyny/lightline.vim'        " Statuszeile mit mehr Informationen
call plug#end()

" Automatisch fehlende Plugins installieren
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

let mapleader = " "
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'

syntax on
set tabstop=4 
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent

"set colorcolumn=80
set cmdheight=2
set exrc
set guicursor=
set hidden
set ignorecase
set incsearch
set laststatus=2    " Statuszeile immer anzeigen
set number
set nu
"set nohlsearch
set noerrorbells
set nowrap
set noswapfile
set nobackup
set relativenumber
set scrolloff=8
set signcolumn=yes
set smartcase
set termguicolors
set undodir=~/.nvim/undodir
set undofile

colorscheme gruvbox

" ### Verhalten für Backup, Swap und co.
if !isdirectory($HOME."/.local/share/nvim/undodir")
    call mkdir($HOME."/.local/share/nvim/undodir", "p", 0700)
endif
set undodir=~/.local/share/nvim/undodir     " Alle Veränderungen werden hier aufgezeichnet
set undofile		                            " Alle Änderungen werden endlos in oberen undodir protokolliert
if !isdirectory($HOME."/.local/share/nvim/swap")
    call mkdir($HOME."/.local/share/nvim/swap", "p", 0700)
endif
set directory=~/.local/share/nvim/swap      " Zentrale Ablage der Swap-Files
"set noswapfile     " Falls kein Swap-Files erstellen werden soll
set nobackup        " Backfile wird sofort wirder gelöscht, da Restores über Undofiles möglich
set hidden          " Wechsel von Buffern auch, wenn File nicht gespeichert

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
