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
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-rooter'
" Code enhancements
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Speed enhancem
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
" Language specific
"" Go
Plug 'tweekmonster/gofmt.vim'
"" Rust
Plug 'rust-lang/rust.vim'
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
set listchars=tab:>-
set list
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

" set font
set guifont=Hack:h11

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

" go files seting
autocmd BufRead,BufNewFile *.go setlocal ts=4 sw=4 sts=4

" Theme settings (must be done before)
syntax on
if has('termguicolors')
  set termguicolors
endif

colorscheme onedark

""""""""""""""""""""""""""""" PLUGIN CONFIG """"""""""""""""""""""""""""""
" COC
let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ 'coc-cssmodules',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-emoji',
      \ 'coc-xml',
      \ 'coc-yaml',
      \ 'coc-json',
      \ 'coc-vimlsp',
      \ 'coc-python',
      \ 'coc-clangd',
      \ 'coc-go',
      \ 'coc-rls',
      \ 'coc-markdownlint'
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
" trigger completion.
inoremap <silent><expr> <c-p> coc#refresh()
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

" Rooter
let g:rooter_patterns = ['.git', 'Makefile', '*.sln', 'package.json']
let g:rooter_change_directory_for_non_project_files = 'current'

" Git gutter
let g:gitgutter_map_keys = 0

" Completion
set completeopt=noselect,menuone,noinsert

" NerdTree
" Close vim when nerd tree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"""""""""""""""""""""""""""" KEYBINDINGS"""""""""""""""""""""""""""""

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

" Resizing
nnoremap <silent> L :exe "vertical resize +5"<CR>
nnoremap <silent> H :exe "vertical resize -5"<CR>
nnoremap <silent> J :exe "resize +5"<CR>
nnoremap <silent> K :exe "resize -5"<CR>

" Fugitive
nmap <leader>ga :Git add
nmap <leader>gaa :Git add .<CR>
nmap <leader>gpl :Git pull<CR>
nmap <leader>gps :Git push<CR>
nmap <leader>gs :Git status<CR>
nmap <leader>gc :Git commit<CR>

" COC
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> gh :call <SID>show_documentation()<CR>

" FZF and Rg
map <leader>f :GFiles<CR>
map <leader>F :Rg<CR>

" vimrc
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>

" Delete without putting it in clipboard
vnoremap <silent> <leader>d "_d

" Delete hidden buffers
nnoremap <F5> :DeleteHiddenBuffers<CR>

" NerdTree
map <silent> <leader>o :NERDTreeToggle<CR>

" Execute bulid file
nnoremap <leader>b :! ./build<CR>
