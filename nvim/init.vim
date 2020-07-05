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
Plug 'mhinz/vim-startify'
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'voldikss/vim-floaterm'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'lilydjwg/colorizer'
call plug#end()

" COC
let g:coc_global_extensions = [
\ 'coc-tsserver',
\ 'coc-prettier',
\ 'coc-eslint',
\
\ 'coc-cssmodules',
\ 'coc-css',
\ 'coc-html',
\
\ 'coc-emoji',
\ 'coc-xml',
\ 'coc-python',
\ 'coc-clangd',
\ 'coc-vimlsp',
\ 'coc-yaml',
\ 'coc-json',
\
\ 'coc-explorer'
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

" Rooter
let g:rooter_change_directory_for_non_project_files = 'home'

" =======================KEY MAPPINGS==========================
" =============================================================

" Leader set
let mapleader=" "

" Shortcut to cd into home directory (useful for windows)
nmap <leader>cdh :cd ~/<CR>

" Fix indentation in file
nmap <leader>ff gg=G<C-o><C-o>

" Switch to previous buffer
nmap <C-TAB> :b#<CR>

" Copy the contents of file
nmap YY :%y+<CR>

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
nnoremap <silent> <leader>o :CocCommand explorer --toggle --sources=buffer+,file+<CR>

" Fugitive
nmap <Leader>ga :Git add
nmap <Leader>gaa :Git add .<CR>
nmap <Leader>gpl :Git pull<CR>
nmap <Leader>gps :Git push<CR>
nmap <Leader>gs :Git status<CR>
nmap <Leader>gc :Git commit<CR>

" FZF
map <C-f> :Files<CR>

" Prettier
nmap <silent> <Leader>pf :CocCommand prettier.formatFile<CR>

" vimrc
nnoremap <Leader>ve :e $MYVIMRC<CR>
nnoremap <Leader>vr :source $MYVIMRC<CR>

" Terminal
nnoremap <silent> <C-`> :FloatermToggle<CR>
tnoremap <silent> <C-`> <C-\><C-n>:FloatermToggle<CR>
tnoremap <silent> <C-TAB> <C-\><C-n>:FloatermNext<CR>
tnoremap <silent> <C-n> <C-\><C-n>:FloatermNew<CR>
tnoremap <silent> <C-q> <C-\><C-n>:FloatermKill<CR>:FloatermToggle<CR>
tnoremap <silent> <C-l> cls<CR>
tnoremap <silent> <C-S-TAB> <C-\><C-n>:FloatermPrev<CR>
tnoremap <Esc> <C-\><C-n>

" Delete hidden buffers
nnoremap <F5> :DeleteHiddenBuffers<CR>

" ========================BASIC SETTINGS=======================
" =============================================================

set t_Co=256
set guifont=Hack:h11
set hidden
set foldcolumn=1
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
colorscheme gruvbox

" Statusline
set showmode
set noshowcmd
set laststatus=2

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

" Set appropriate tab length for files
autocmd BufRead,BufNewFile *.c, *.h, *.cpp, *.py set shiftwidth=4
autocmd BufRead,BufNewFile *.c, *.h, *.cpp, *.py set tabstop=4
