"Basic settings:
filetype plugin on

" Vim Plug
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'morhetz/gruvbox'
call plug#end()

" Enable copy pase in neovim
if has('win32')
    so $VIMRUNTIME/mswin.vim
endif
    
" Plugin settings
set laststatus=2

" Plugin remaps
map <C-o> :NERDTreeToggle<CR>
map; :FZF <CR>

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
set tabstop=4
set smartindent
set expandtab
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
colorscheme gruvbox
set background=dark

" Shortcutting split navigation:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Visual mode shortcuts
vmap <Tab> >
vmap <S-Tab> <

" Other keymappings
inoremap <S-Tab> <C-d>

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell


