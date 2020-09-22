""""""""""""""""""""""""""""""""" PLUGINS """""""""""""""""""""""""""""""""

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
" Editor enhancements
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'KeitaNakamura/neodark.vim'
Plug 'mhinz/vim-startify'
" Common utils
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'lilydjwg/colorizer'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale'
" Language specific
"" JS/TS
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
"" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"" C/C++
Plug 'jackguo380/vim-lsp-cxx-highlight'
call plug#end()

" Git gutter
let g:gitgutter_map_keys = 0

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=[fnamemodify($MYVIMRC, ':p:h')."/snips"]

" ALE
let g:ale_hover_cursor = 1
let g:ale_completion_enabled = 1
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\}

let g:ale_linters = {
\   'go': ['gometalinter', 'gofmt'],
\}


"""""""""""""""""""""""""""""""""""""" GENERAL """"""""""""""""""""""""""""""""

filetype plugin on
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
let g:neodark#use_256color = 0
let g:neodark#background = '#202020'
colorscheme neodark

" Statusline
set laststatus=2
let g:lightline = {}
let g:lightline.colorscheme = 'neodark'

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" C/C++ flie specific settings
autocmd BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.hpp setlocal ts=4 sw=4 sts=4

"""""""""""""""""""""""""""" KEYBINDINGS"""""""""""""""""""""""""""""""

" leader set
let mapleader=" "

" Shortcut to cd into home directory (useful for windows)
nmap <leader>cdh :cd ~/<CR>

" Fix indentation in file
nmap <leader>ff gg=G<C-o><C-o>

" Copy the contents of file
nmap YY :%y+<CR>

" Shortcutting split navigation:
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" ALE
nmap <silent> <leader>gd :ALEGoToDefinition<CR>
nmap <silent> <leader>gf :ALEFindReferences<CR>

" Fugitive
nmap <leader>ga :Git add
nmap <leader>gaa :Git add .<CR>
nmap <leader>gpl :Git pull<CR>
nmap <leader>gps :Git push<CR>
nmap <leader>gs :Git status<CR>
nmap <leader>gc :Git commit<CR>

" FZF
map <C-f> :Files<CR>

" vimrc
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>

" Delete hidden buffers
nnoremap <leader>db :DeleteHiddenBuffers<CR>

" Nerdtree
map <silent> <leader>o :NERDTreeToggle<CR>

" UlitSnips
nmap <leader>es :UltiSnipsEdit<CR>
