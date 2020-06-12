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
Plug 'airblade/vim-rooter'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'chun-yang/auto-pairs'
Plug 'lilydjwg/colorizer'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-surround'
Plug 'rust-lang-nursery/rustfmt'
call plug#end()

" Plugin settings
set laststatus=2

" COC
let g:coc_global_extensions = [
      \ 'coc-floaterm',
      \ 'coc-emoji',
      \ 'coc-cssmodules',
      \ 'coc-explorer',
      \ 'coc-svg',
      \ 'coc-prettier',
      \ 'coc-yaml',
      \ 'coc-python',
      \ 'coc-tsserver',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-vimlsp',
      \ 'coc-xml',
      \ 'coc-json',
      \ ]
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
" provider config
let g:loaded_python_provider=0 " python 2 support disabled
let g:loaded_ruby_provider=0
" explorer
let g:coc_explorer_global_presets = {
      \   'floating': {
      \      'position': 'floating',
      \   },
      \   'floatingLeftside': {
      \      'position': 'floating',
      \      'floating-position': 'left-center',
      \      'floating-width': 30,
      \   },
      \   'floatingRightside': {
      \      'position': 'floating',
      \      'floating-position': 'right-center',
      \      'floating-width': 30,
      \   },
      \   'simplify': {
      \     'file.child.template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
      \   }
      \ }

" airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_theme='onedark'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'
let g:airline_section_a = airline#section#create(['mode'])

" Rooter
let g:rooter_change_directory_for_non_project_files = 'home'

" =======================KEY MAPPINGS==========================
" =============================================================

" Leader set
let mapleader=" "

" Fix indentation in file
nmap <leader>ff gg=G<C-o><C-o>

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

" COC
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> gh :call <SID>show_documentation()<CR>
nnoremap <leader>o :CocCommand explorer --toggle --sources=buffer+,file+<CR>

" FZF
map <C-f> :Files<CR>

" vimrc
nnoremap <Leader>ve :e $MYVIMRC<CR>
nnoremap <Leader>vr :source $MYVIMRC<CR>

" ========================BASIC SETTINGS=======================
" =============================================================

set guifont=Hack:h11
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
set tabstop=2 softtabstop=2
set shiftwidth=2
set smartindent
set smarttab
set expandtab
set undolevels=1000
set background=dark
set backspace=indent,eol,start
set updatetime=100
set shortmess+=c
set clipboard^=unnamed,unnamedplus
set t_Co=256
set nobackup
set nowritebackup
set mouse=a

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
colorscheme onedark
let g:onedark_termcolors=256

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell
