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
Plug 'itchyny/lightline.vim'
Plug 'sainnhe/sonokai'
Plug 'mhinz/vim-startify'
Plug 'arithran/vim-delete-hidden-buffers'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'lilydjwg/colorizer'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
call plug#end()

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
