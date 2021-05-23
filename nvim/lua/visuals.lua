local cmd = vim.cmd
local o = vim.o

-- Set theme
o.termguicolors = true
o.background = 'dark'
cmd 'silent! colorscheme dracula'

-- Set font
vim.api.nvim_set_option('guifont', 'Hack NF:h12')