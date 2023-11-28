local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fa', builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', ":Telescope help_tags<CR>", {})
vim.keymap.set('n', '<leader>fp', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
