-- NVIM config

-- general

vim.opt.encoding = 'utf-8'
vim.opt.hidden = true
vim.opt.updatetime = 100
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
vim.opt.backspace:append { 'indent', 'eol', 'start' }

-- spacing

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.expandtab = true

-- formatting

vim.opt.wrap = false
vim.opt.formatoptions = 'qln'
vim.opt.list = true
vim.opt.listchars = {
    trail = '.',
    tab = '>-',
    space = ' '
}
vim.opt.fillchars = {
    vert = '│',
}

-- searching

vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.shortmess = 'filnxtToOFc'

-- mouse

vim.opt.mouse = 'a'

-- font

vim.opt.guifont = 'Hack:h10'

-- numbers and side column

vim.opt.signcolumn = 'number'
vim.opt.number = true
vim.opt.relativenumber = true

-- display all matching names when tab completes

vim.opt.wildmenu = true
vim.opt.wildmode = 'full'
vim.opt.hlsearch = false
vim.opt.laststatus = 2

-- bells

vim.opt.visualbell = false
vim.opt.errorbells = false

-- status line

vim.opt.showmode = false

-- temp files

vim.opt.backup = true
vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.writebackup = true
vim.opt.undolevels = 1000
vim.opt.undodir = os.getenv('HOME') .. '/.vim-tmp/undo'
vim.opt.backupdir = os.getenv('HOME') .. '/.vim-tmp/backup'
vim.opt.directory = os.getenv('HOME') .. '/.vim-tmp/swap'

-- colors

vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

-- scroll

vim.opt.scrolloff = 8

-- functions

function SetTabWidth(width)
    vim.opt.tabstop = width
    vim.opt.softtabstop = width
    vim.opt.shiftwidth = width
    print("Switching tab width to " .. width .. "...")
end

-- keymaps

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>ev', ':e $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>o', ':Ex<CR>')
vim.keymap.set('n', '<leader>tw4', '<cmd>lua SetTabWidth(4)<CR>')
vim.keymap.set('n', '<leader>tw2', '<cmd>lua SetTabWidth(2)<CR>')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('x', '<leader>p', '\"_dp')
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<leader>rh', ':vertical resize -5<CR>')
vim.keymap.set('n', '<leader>rk', ':horizontal resize -5<CR>')
vim.keymap.set('n', '<leader>rl', ':vertical resize +5<CR>')
vim.keymap.set('n', '<leader>rj', ':horizontal resize +5<CR>')

