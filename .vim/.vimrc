" Basic settings:
filetype plugin on

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
set nocompatible
set encoding=utf-8
set number relativenumber
set linebreak
set showmatch
set novisualbell
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set cindent
set shiftwidth=4
set softtabstop=4
set smartindent
set smarttab
set ruler
set undolevels=1000
set backspace=indent,eol,start
" Display all matching names when tab completes
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Theme settings
syntax on
set t_Co=256
" colorscheme distinguished

" Shortcutting split navigation:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
