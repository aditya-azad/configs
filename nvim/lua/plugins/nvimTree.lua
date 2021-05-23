local g = vim.g

g.nvim_tree_ignore = {'.git', 'node_modules', '.cache'}
g.nvim_tree_gitignore = 1
g.nvim_tree_auto_close = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_add_trailing = 1
g.nvim_tree_disable_window_picker = 0

g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1
}

vim.api.nvim_set_keymap('', '<leader>o', [[:NvimTreeToggle<CR>]], {})