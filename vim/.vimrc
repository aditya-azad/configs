filetype plugin on

" =========================PLUGINS=============================
" =============================================================

" Vim Plug
call plug#begin('~/.vim/autoload')
Plug 'valloric/youcompleteme'
Plug 'kien/ctrlp.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'chun-yang/auto-pairs'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'
Plug 'rust-lang-nursery/rustfmt'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
call plug#end()

" Plugin settings
set laststatus=2

" NerdTree
let NERDTreeMinimalUI=1

" YCM
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_max_diagnostics_to_display=0
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_warning_symbol = '.'
let g:ycm_error_symbol = '..'
let g:ycm_server_use_vim_stdout = 1

" =======================KEY MAPPINGS==========================
" =============================================================

" Leader set
let mapleader=" "

" Sizing windows
map - <C-w>-
map = <C-w>+

" Shortcutting split navigation:
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" Switching buffers
map <C-Tab> :b#<CR>

" Copying
vmap <leader>y "+y

" NerdTree
nnoremap <leader>o :NERDTreeToggle<CR>
nnoremap <silent> <Leader>pv :NERDTreeFind<CR>

" YCM
nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR>


" ========================BASIC SETTINGS=======================
" =============================================================

" Enable copy pase in neovim
if has('win32')
    so $VIMRUNTIME/mswin.vim
endif

" Set the fonts when gVim is running
if has("gui_running")
    set gfn=mononoki_NF:h11
endif
    
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set hidden
set nocompatible
set encoding=UTF-8
set number relativenumber
set linebreak
set showmatch
set novisualbell
set noerrorbells
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set cindent
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set expandtab
set colorcolumn=80
set undolevels=1000
set backspace=indent,eol,start
set updatetime=100

" Save temp files in separate directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Display all matching names when tab completes
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Theme settings
syntax on
set t_Co=256
colorscheme gruvbox
set background=dark

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

