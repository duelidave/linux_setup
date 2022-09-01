" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "autocmd VimEnter * PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"call plug#begin('~/.config/nvim/autoload/plugged')
call plug#begin('~/.local/share/nvim/site/autoload/plug.vim')  
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'gruvbox-community/gruvbox'
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
