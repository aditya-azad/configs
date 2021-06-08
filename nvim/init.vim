""""""""""""""""""""""""""""""" VIMPLUG SETUP """""""""""""""""""""""""""""""

" Install Vim Plug (nvim for windows)
if has("win32")
  if empty(glob('$LOCALAPPDATA\nvim\autoload\plug.vim'))
    silent ! powershell -Command "
          \   New-Item -Path ~\AppData\Local\nvim -Name autoload -Type Directory -Force;
          \   Invoke-WebRequest
          \   -Uri 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
          \   -OutFile ~\AppData\Local\nvim\autoload\plug.vim
          \ "
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
else
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

" Vim Plug
call plug#begin('~/.vim/autoload')
" Visual enhancements
Plug 'itchyny/lightline.vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
" Navigation enhancements
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-rooter'
call plug#end()

"""""""""""""""""""""""""""""""""""""" GENERAL """"""""""""""""""""""""""""""""

filetype plugin on
set t_Co=256
set noshowmode
set relativenumber
set number
set hidden
set nocompatible
set encoding=UTF-8
set linebreak
set showmatch
set novisualbell
set listchars=tab:>-
set list
set noerrorbells
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set cindent
set tabstop=2 softtabstop=2
set shiftwidth=2
set smartindent
set smarttab
set noexpandtab
set undolevels=1000
set backspace=indent,eol,start
set updatetime=100
set shortmess+=I
set nobackup
set noundofile
set nowritebackup
set mouse=a
set clipboard^=unnamed,unnamedplus
set undodir=~/.vimundo
set undofile

" set font
set guifont=Hack:h11

" Remove trailing space on save
autocmd BufWritePre * %s/\s\+$//e

" Save temp files in separate directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Display all matching names when tab completes
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Statusline
set laststatus=2
let g:lightline = {}
let g:lightline.colorscheme = 'onedark'

" Theme settings (must be done before)
syntax on
if has('termguicolors')
  set termguicolors
endif

colorscheme onedark

""""""""""""""""""""""""""""" PLUGIN CONFIG """"""""""""""""""""""""""""""
" NerdTree
" Close vim when nerd tree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"""""""""""""""""""""""""""" KEYBINDINGS"""""""""""""""""""""""""""""

" leader set
let mapleader=" "

" Shortcut to cd into home directory (useful for windows)
nmap <leader>cdh :cd ~/<CR>

" Shortcutting split navigation:
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" Resizing
nnoremap <silent> L :exe "vertical resize +5"<CR>
nnoremap <silent> H :exe "vertical resize -5"<CR>
nnoremap <silent> J :exe "resize +5"<CR>
nnoremap <silent> K :exe "resize -5"<CR>

" vimrc
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>

" Delete without putting it in clipboard
vnoremap <silent> <leader>d "_d

" Delete hidden buffers
nnoremap <F5> :DeleteHiddenBuffers<CR>

" NerdTree
map <silent> <leader>o :NERDTreeToggle<CR>
map <silent> <leader>O :NERDTree<CR>

" Tabs
map tc <Nop>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprev<CR>
nnoremap <leader>tc :tabc<CR>
nnoremap <leader>tt :tabnew<CR>
