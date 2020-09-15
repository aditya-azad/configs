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

" Delete hidden buffers
nnoremap <F5> :DeleteHiddenBuffers<CR>

