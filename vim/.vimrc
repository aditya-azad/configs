"Basic settings:
filetype plugin on

" Vim Plug
call plug#begin()
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

" Enable copy pase in neovim
if has('win32')
    so $VIMRUNTIME/mswin.vim
endif
    
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

" Markdown settings
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1

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
" vmap <Tab> >
" vmap <S-Tab> <

" Other keymappings
" inoremap <S-Tab> <C-d>

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell


