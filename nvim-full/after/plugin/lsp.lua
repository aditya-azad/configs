local lsp = require('lsp-zero').preset({})
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local lsp_config = require('lspconfig')

vim.diagnostic.config({
    virtual_text = true,
})

-- cmp

local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'buffer', max_item_count = 3 },
        { name = 'luasnip' },
    },
    mapping = {
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-y>'] = nil,
        ['<C-Space>'] = nil,
        ['<S-Tab>'] = nil,
        ['<Enter>'] = nil,
    },
})

-- luasnip

require("luasnip.loaders.from_vscode").lazy_load()

-- lsp

lsp.set_sign_icons({
    error = ' ',
    warn = ' ',
    info = ' ',
    hint = ' ⚑'
})

lsp.on_attach(function(_, bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>fs", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- lsp servers

lsp_config.lua_ls.setup(lsp.nvim_lua_ls())

lsp_config.pylsp.setup{
    root_dir = lsp_config.util.root_pattern('.git'),
    settings = {
        single_file_support = false,
        pylsp = {
            configurationSources = {"flake8"},
            plugins = {
                -- formatter options
                yapf = { enabled = true },
                autopep8 = { enabled = false },
                black = { enabled = false },
                pyls_isort = { enabled = false },
                -- linter options
                flake8 = { enable = true },
                pyflakes = { enabled = true },
                pycodestyle = { enabled = true },
                pylint = { enabled = false, executable = "pylint" },
                mccabe = { enable = false },
                -- static type checker
                pylsp_mypy = { enabled = false },
                -- auto-completion options
                jedi_completion = { fuzzy = false },
            }
        }
    }
}

lsp_config.tsserver.setup{}

lsp_config.gopls.setup{}

lsp.setup()
