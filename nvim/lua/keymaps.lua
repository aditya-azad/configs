local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

-- Window navigation
map('n', '<leader>h', [[:wincmd h<CR>]], opt)
map('n', '<leader>j', [[:wincmd j<CR>]], opt)
map('n', '<leader>k', [[:wincmd k<CR>]], opt)
map('n', '<leader>l', [[:wincmd l<CR>]], opt)

-- Window resize
map('n', 'L', [[:vertical resize +5<CR>]], opt)
map('n', 'H', [[:vertical resize -5<CR>]], opt)
map('n', 'J', [[:resize +5<CR>]], opt)
map('n', 'K', [[:resize -5<CR>]], opt)

-- Tabs
map('n', '<leader>tn', [[:tabnext<CR>]], opt)
map('n', '<leader>tp', [[:tabprev<CR>]], opt)
map('n', '<leader>tc', [[:tabc<CR>]], opt)
map('n', '<leader>tt', [[:tabnew<CR>]], opt)

-- File access
map('n', '<leader>cdc', [[:cd ~/code<CR>]], opt)
map('n', '<leader>cdn', [[:cd D:/databases/notes<CR>]], opt)