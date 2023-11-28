function SetTabWidth(width)
    vim.opt.tabstop = width
    vim.opt.softtabstop = width
    vim.opt.shiftwidth = width
    print("Switching tab width to " .. width .. "...")
end

function ToggleExpandTab()
    if (vim.opt.expandtab:get()) then
        vim.opt.expandtab = false
        print("Switching to tabs...")
    else
        vim.opt.expandtab = true
        print("Switching to spaces...")
    end
end

function P(v)
    print(vim.inspect(v))
    return v
end

vim.keymap.set('n', '<leader>et', '<cmd>lua ToggleExpandTab()<CR>')
vim.keymap.set('n', '<leader>tw4', '<cmd>lua SetTabWidth(4)<CR>')
vim.keymap.set('n', '<leader>tw2', '<cmd>lua SetTabWidth(2)<CR>')
