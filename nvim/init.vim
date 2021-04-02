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
Plug 'sheerun/vim-polyglot'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Do :TSInstall all after download
" Navigation enhancements
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Code enhancements
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
" Language specific
"" Go
Plug 'tweekmonster/gofmt.vim'
"" Rust
Plug 'rust-lang/rust.vim'
"" Org
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/utl.vim'
call plug#end()

""""""""""""""""""""""""""""""""" LANGUAGE SPECIFIC """"""""""""""""""""""""""

"" TypeScript
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

"" C/C++
autocmd BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.hpp setlocal ts=4 sw=4 sts=4

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
set listchars=tab:>-
set list
set noerrorbells
set smartcase
set ignorecase
set incsearch
set autoindent
set cindent
set tabstop=2 softtabstop=2
set shiftwidth=2
set smartindent
set smarttab
set noexpandtab
set undolevels=1000
set backspace=indent,eol,start
set updatetime=100
set shortmess+=I
set nobackup
set noundofile
set nowritebackup
set mouse=a
set clipboard^=unnamed,unnamedplus
set undodir=~/.vimundo
set undofile
set formatoptions-=cro
set completeopt=noselect,menuone,noinsert

" Theming
set termguicolors
set guifont="Hack NF":h12

" Remove trailing space on save
autocmd BufWritePre * %s/\s\+$//e

" Save temp files in separate directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Display all matching names when tab completes
set wildmenu
set wildmode=longest,list,full
set nohlsearch

" Spell check on markdown files
autocmd BufRead,BufNewFile *.md setlocal spell

""""""""""""""""""""""""""""" PLUGIN CONFIG """"""""""""""""""""""""""""""

" Completion
set completeopt=noselect,menuone,noinsert
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" LSP
lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.pyls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.gopls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.rust_analyzer.setup{ on_attach=require'completion'.on_attach }

" NvimTree
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_gitignore = 1
let g:nvim_tree_auto_close = 1
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ }
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': ""
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

" Theme
set bg=dark
if !has('gui_running')
  set t_Co=256
endif
colorscheme dracula
let g:airline_theme = 'dracula'

"""""""""""""""""""""""""""" KEYBINDINGS"""""""""""""""""""""""""""""

" leader set
let mapleader=" "

" Shortcutting split navigation:
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" Vim reload vimrc
nnoremap <leader>vr :source $MYVIMRC<CR>

" Resizing
nnoremap <silent> L :exe "vertical resize +5"<CR>
nnoremap <silent> H :exe "vertical resize -5"<CR>
nnoremap <silent> J :exe "resize +5"<CR>
nnoremap <silent> K :exe "resize -5"<CR>

" Fugitive
nmap <leader>ga :Git add
nmap <leader>gaa :Git add .<CR>
nmap <leader>gpl :Gpull<CR>
nmap <leader>gps :Gpush<CR>
nmap <leader>gs :G<CR>
nmap <leader>gc :Gcommit<CR>

" Delete hidden buffers
nnoremap <F5> :DeleteHiddenBuffers<CR>

" NvimTree
map <silent> <leader>o :NvimTreeToggle<CR>

" Tabs
map tc <Nop>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprev<CR>
nnoremap <leader>tc :tabc<CR>
nnoremap <leader>tt :tabnew<CR>

" LSP
nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


""""""""""""""""""""""""""""" QUICK ACCESS """""""""""""""""""""""""""""""

" directores
nmap <leader>cdc :cd ~/code<CR>
nmap <leader>cdn :cd D:/databases/notes<CR>

" files
nnoremap <leader>ve :e $MYVIMRC<CR>

