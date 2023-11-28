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
    tab = '→ ',
    space = '.',
    extends = '~',
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

-- scroll

vim.opt.scrolloff = 8

-- netrw

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
