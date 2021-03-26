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
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
" Navigation enhancements
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'scrooloose/nerdtree'
" Code enhancements
Plug 'ludovicchabant/vim-gutentags'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
" Language specific
"" Go
Plug 'tweekmonster/gofmt.vim'
"" Rust
Plug 'rust-lang/rust.vim'
"" Org
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/utl.vim'
call plug#end()

""""""""""""""""""""""""""""""""" LANGUAGE SPECIFIC """"""""""""""""""""""""""

"" TypeScript
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

"" C/C++
autocmd BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.hpp setlocal ts=4 sw=4 sts=4

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
set formatoptions-=cro
set completeopt=noselect,menuone,noinsert

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

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

""""""""""""""""""""""""""""" PLUGIN CONFIG """"""""""""""""""""""""""""""

" CtrlP
let g:ctrlp_map = '<leader>pp'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['node_modules', 'Makefile']
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Guttentags
set tags=./tags
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_project_root = [
  \'.git', 'Makefile' ]
let g:gutentags_ctags_exclude = [
  \'node_modules', '_build', 'build', 'CMakeFiles', '.mypy_cache', 'venv',
  \'*.md', '*.tex', '*.css', '*.html', '*.json', '*.xml', '*.xmls', '*.ui']

" NerdTree
" Close vim when nerd tree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Styling
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Theme
set bg=dark
if !has('gui_running')
  set t_Co=256
endif
colorscheme gruvbox

"""""""""""""""""""""""""""" KEYBINDINGS"""""""""""""""""""""""""""""

" leader set
let mapleader=" "

" Shortcutting split navigation:
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" Vim reload vimrc
nnoremap <leader>vr :source $MYVIMRC<CR>

" Resizing
nnoremap <silent> L :exe "vertical resize +5"<CR>
nnoremap <silent> H :exe "vertical resize -5"<CR>
nnoremap <silent> J :exe "resize +5"<CR>
nnoremap <silent> K :exe "resize -5"<CR>

" Fugitive
nmap <leader>ga :Git add
nmap <leader>gaa :Git add .<CR>
nmap <leader>gpl :Gpull<CR>
nmap <leader>gps :Gpush<CR>
nmap <leader>gs :G<CR>
nmap <leader>gc :Gcommit<CR>

" Delete hidden buffers
nnoremap <F5> :DeleteHiddenBuffers<CR>

" NerdTree
map <silent> <leader>o :NERDTreeToggle<CR>

" Tabs
map tc <Nop>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprev<CR>
nnoremap <leader>tc :tabc<CR>
nnoremap <leader>tt :tabnew<CR>

" Ctags
nnoremap <leader>pt :CtrlPTag<CR>

""""""""""""""""""""""""""""" QUICK ACCESS """""""""""""""""""""""""""""""

" directores
nmap <leader>cdc :cd ~/code<CR>
nmap <leader>cdn :cd D:/databases/notes<CR>

" files
nnoremap <leader>ve :e $MYVIMRC<CR>

