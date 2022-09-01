" Python3 config
let g:python3_host_prog = '/home/muellerda/.pyenv/shims/python3'

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "autocmd VimEnter * PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'gruvbox-community/gruvbox'
	Plug 'itchyny/lightline.vim'        " Statuszeile mit mehr Informationen
    Plug 'ycm-core/YouCompleteMe'
    Plug 'frazrepo/vim-rainbow'
    Plug 'yegappan/mru'                 " Most Recently Used über :MRU 
    Plug 'justinmk/vim-sneak'           " Sehr schnelles springen im Code
    Plug 'preservim/nerdtree'           " Erweiterter Filebrowser
    Plug 'Xuyuanp/nerdtree-git-plugin'  " Erweiterung für Git
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
set nohlsearch
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

" ### Interner Filemanager (Explore, VExplore, SExplore) optimieren
let g:netrw_banner = 0        " Banner abschalten
let g:netrw_browse_split = 4  " im gleichen Fenster öffnen
let g:netrw_altv = 1          " Split rechts öffnen
let g:netrw_liststyle = 3     " Tree View
let g:netrw_winsize = 25      " Fenster schmälter machen
let g:netrw_list_hide = netrw_gitignore#Hide()    " Gits ausblenden	
let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S\+'     " Dotfiles ausblenden

" ### NERDTree 
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0

function NERDTreeToggle()   " Toggle-Funktion
    if g:nerdtree_open == 1
        let g:nerdtree_open = 0
        NERDTreeClose
    else
        let g:nerdtree_open = 1
        NERDTree
    endif
endfunction

function! StartUp() 
    if 0 == argc()
        NERDTree
        let g:nerdtree_open = 1
    end
endfunction
autocmd VimEnter * call StartUp()    " Nerdtree anzeigen beim Start, wenn man keine Datei öffnet

" ### Sessions
" Automatisch letzte Session speichern
function! MakeSession()
  let b:sessiondir = $HOME . "/.config/nvim/sessions"
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/autosession.vim'
  exe "mksession! " . b:filename
endfunction
au VimLeave * :call MakeSession()

" Command LoadLastSession ladet die letzte gespeicherte Session
function! LoadSession()
  let b:sessiondir = $HOME . "/.config/nvim/sessions"
  let b:sessionfile = b:sessiondir . "/autosession.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction
command! LoadLastSession call LoadSession()

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

map <Leader>F :Files!<Enter>

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
