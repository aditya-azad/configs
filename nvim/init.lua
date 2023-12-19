-------------------------------------------------------------- custom functions

function SetTabWidth(width)
    vim.opt.tabstop = width
    vim.opt.softtabstop = width
    vim.opt.shiftwidth = width
    print("Switching tab width to " .. width .. "...")
end

---------------------------------------------------------------------- settings

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

vim.opt.showmode = true

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
vim.o.background = "dark"

-- scroll

vim.opt.scrolloff = 8

-- general keymaps

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>ev', ':e $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>o', ':NvimTreeToggle<CR>')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', 'H', ':help <C-r><C-w><CR>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('x', '<leader>p', '\"_dp')
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
vim.keymap.set('n', '<leader>tw4', '<cmd>lua SetTabWidth(4)<CR>')
vim.keymap.set('n', '<leader>tw2', '<cmd>lua SetTabWidth(2)<CR>')

------------------------------------------------------------------------ plugins

-- packer

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use('wbthomason/packer.nvim')
    use('lewis6991/gitsigns.nvim')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('nvim-tree/nvim-tree.lua')
    use('hrsh7th/cmp-nvim-lua')
    use('nvim-tree/nvim-web-devicons')
    use({
        'catppuccin/nvim',
        as = 'catppuccin'
    })
    use('nvim-lualine/lualine.nvim')
    use({
        'nvim-telescope/telescope.nvim',
        tag='0.1.2',
        requires = {
            {'nvim-lua/plenary.nvim'}
        }
    })
    use({
        'nvim-treesitter/nvim-treesitter',
        {run = ':TSUpdate'}
    })
    use({
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'L3MON4D3/LuaSnip'},
            {'saadparwaiz1/cmp_luasnip'},
            {'rafamadriz/friendly-snippets'}
        }
    })
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- git signs

require('gitsigns').setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '-' },
        topdelete    = { text = '-' },
        changedelete = { text = '~' },
        untracked    = { text = '|' },
    },
    signcolumn = true,
    numhl      = false,
    linehl     = false,
    word_diff  = false,
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '    ~ <author>, <author_time:%Y-%m-%d %I:%M%p> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 4000000000,
    preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    },
}

-- lsp

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
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = nil,
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

lsp_config.clangd.setup{}

lsp_config.rust_analyzer.setup{}

lsp_config.tailwindcss.setup{}

lsp.setup()

-- telescope

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fa', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', ":Telescope help_tags<CR>", {})
vim.keymap.set('n', '<leader>fp', function()
    telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- treesitter

require'nvim-treesitter.configs'.setup {
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            scope_incremental = "<C-Space>",
            node_decremental = "<C-Backspace>",
        },
    },
}

-- undotree

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- nvim tree

require'nvim-tree'.setup()

-- lualine

require('lualine').setup {
    extensions = { 'nvim-tree', 'fugitive' }
}
