filetype plugin on

" =========================PLUGINS=============================
" =============================================================
" Vim Plug
call plug#begin('~/.vim/autoload')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'jceb/vim-orgmode'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'neoclide/coc.nvim', { 'branch': 'release'}
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'chun-yang/auto-pairs'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-surround'
Plug 'rust-lang-nursery/rustfmt'
Plug 'ryanoasis/vim-devicons'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

call plug#end()

    
" Plugin settings
set laststatus=2

" Plugin remaps
map <C-o> :NERDTreeToggle<CR>
map; :FZF <CR>

" Syntastic settings
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

" Coc settings
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

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
set path+=**
set hidden
set nocompatible
set encoding=UTF-8
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

" Save temp files (swp files) in separate directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Theme settings
syntax on
set t_Co=256
colorscheme gruvbox
set background=dark

" Switching buffers
map <C-Tab> :b#<CR>

" Shortcutting split navigation:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell


