filetype plugin on

" =========================PLUGINS=============================
" =============================================================

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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-fugitive'
Plug 'chun-yang/auto-pairs'
Plug 'lilydjwg/colorizer'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'
Plug 'rust-lang-nursery/rustfmt'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
call plug#end()

" Plugin settings
set laststatus=2

" NerdTree
let NERDTreeMinimalUI=1

" COC
" Use tab for trigger completion with characters ahead and navigate.
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
" Install extentions
let g:coc_global_extentions="coc-tsserver coc-eslint coc-json coc-css coc-html"
" Shows documentation
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_theme='gruvbox'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_section_a = airline#section#create(['mode'])
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#buffers_label = ''
let airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'


" =======================KEY MAPPINGS==========================
" =============================================================

" Leader set
let mapleader=" "

" Sizing windows
nmap <leader>J 5<C-w>+
nmap <leader>K 5<C-w>-
nmap <leader>L 5<C-w>>
nmap <leader>H 5<C-w><
nmap <leader>= <C-w>=

" Shortcutting split navigation:
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" Close current buffer
 map <Leader>dt :bd<CR>

" NerdTree
nnoremap <leader>o :NERDTreeToggle<CR>
nnoremap <silent> <Leader>pv :NERDTreeFind<CR>

" COC
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> gh :call <SID>show_documentation()<CR>

" FZF
map <C-f> :Files<CR>
map <leader>b :Buffers<CR>

" vimrc
nnoremap <Leader>ve :e $MYVIMRC<CR>
nnoremap <Leader>vr :source $MYVIMRC<CR>

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
set paste
set shortmess+=c
set clipboard^=unnamed,unnamedplus

" Save temp files in separate directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Display all matching names when tab completes
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Theme settings
syntax on
colorscheme gruvbox

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell
