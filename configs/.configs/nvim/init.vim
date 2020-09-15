filetype plugin on

source ./plugins.vim
source ./keybindings.vim

set t_Co=256
set noshowmode
set relativenumber
set guifont=Hack:h11
set hidden
set formatoptions-=cro
set nocompatible
set encoding=UTF-8
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
set tabstop=2 softtabstop=2
set shiftwidth=2
set smartindent
set smarttab
set expandtab
set undolevels=1000
set background=dark
set backspace=indent,eol,start
set updatetime=100
set shortmess+=I
set nobackup
set noundofile
set nowritebackup
set mouse=a
set clipboard^=unnamed,unnamedplus

" Remove trailing space on save
autocmd BufWritePre * %s/\s\+$//e

" Save temp files in separate directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Display all matching names when tab completes
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Theme settings
syntax on
if has('termguicolors')
  set termguicolors
endif
colorscheme sonokai

" Statusline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
