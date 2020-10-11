""""""""""""""""""""""""""""""" VIMPLUG SETUP """""""""""""""""""""""""""""""

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
" Visual enhancements
Plug 'itchyny/lightline.vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'lilydjwg/colorizer'
" Navigation enhancements
Plug 'preservim/nerdtree'
Plug 'arithran/vim-delete-hidden-buffers'
" Code enhancements
Plug 'nvim-lua/completion-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'townk/vim-autoclose'
" Speed enhancem
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
" Language specific
"" Go
Plug 'tweekmonster/gofmt.vim'
call plug#end()

"""""""""""""""""""""""""""""""""""""" GENERAL """"""""""""""""""""""""""""""""

filetype plugin on
set t_Co=256
set noshowmode
set relativenumber
set number
set hidden
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
set backspace=indent,eol,start
set updatetime=100
set shortmess+=I
set nobackup
set noundofile
set nowritebackup
set mouse=a
set clipboard^=unnamed,unnamedplus

" set font
let os=substitute(system('uname'), '\n', '', '')
if has("win32")
  set guifont=Hack:h11
endif

" Remove trailing space on save
autocmd BufWritePre * %s/\s\+$//e

" Save temp files in separate directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Display all matching names when tab completes
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Statusline
set laststatus=2
let g:lightline = {}
let g:lightline.colorscheme = 'onedark'

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" C/C++ flie specific settings
autocmd BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.hpp setlocal ts=4 sw=4 sts=4

" Theme settings (must be done before)
syntax on
if has('termguicolors')
  set termguicolors
endif
" enable transparency in terminals
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END
endif
colorscheme onedark

""""""""""""""""""""""""""""" PLUGIN CONFIG """"""""""""""""""""""""""""""

" Git gutter
let g:gitgutter_map_keys = 0

" Nerdtree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Completion
set completeopt=noselect,menuone

" LSP
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
lua require'nvim_lsp'.tsserver.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.clangd.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.gopls.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.rust_analyzer.setup{ on_attach=require'completion'.on_attach }


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

" Fugitive
nmap <leader>ga :Git add
nmap <leader>gaa :Git add .<CR>
nmap <leader>gpl :Git pull<CR>
nmap <leader>gps :Git push<CR>
nmap <leader>gs :Git status<CR>
nmap <leader>gc :Git commit<CR>

" LSP
nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>

" Prettier
map <silent> <leader>p :Prettier<CR>


" FZF
map <C-f> :GFiles<CR>

" vimrc
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>

" Delete hidden buffers
nnoremap <leader>db :DeleteHiddenBuffers<CR>

" Nerdtree
map <silent> <leader>o :NERDTreeToggle<CR>

" Run the highlighted line in bash and return the result here
noremap Q !!sh<CR>
