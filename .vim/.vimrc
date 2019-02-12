" Basic settings:
filetype plugin on

set nocompatible
set encoding=utf-8
set number relativenumber
set linebreak
set showmatch
set visualbell
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set cindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set ruler
set undolevels=1000
set backspace=indent,eol,start
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Theme settings
syntax on
set t_Co=256
colorscheme distinguished

" Shortcutting split navigation:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

