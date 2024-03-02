-------------------------------------------------------------- custom functions

function SetTabWidth(width)
    vim.opt.tabstop = width
    vim.opt.softtabstop = width
    vim.opt.shiftwidth = width
    print("Switching tab width to " .. width .. "...")
end

---------------------------------------------------------------------- settings

-- general

vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.updatetime = 100
vim.opt.clipboard:append { "unnamed", "unnamedplus" }
vim.opt.backspace:append { "indent", "eol", "start" }

-- spacing

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.expandtab = true

-- formatting

vim.opt.wrap = false
vim.opt.formatoptions = "qln"
vim.opt.list = true
vim.opt.listchars = {
    tab = "→ ",
    space = ".",
    extends = "~",
}
vim.opt.fillchars = {
    vert = "│",
}

-- searching

vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.shortmess = "filnxtToOFc"

-- mouse

vim.opt.mouse = "a"

-- numbers and side column

vim.opt.signcolumn = "number"
vim.opt.number = true
vim.opt.relativenumber = true

-- display all matching names when tab completes

vim.opt.wildmenu = true
vim.opt.wildmode = "full"
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
vim.opt.undodir = os.getenv("HOME") .. "/.vim-tmp/undo"
vim.opt.backupdir = os.getenv("HOME") .. "/.vim-tmp/backup"
vim.opt.directory = os.getenv("HOME") .. "/.vim-tmp/swap"

-- colors

vim.opt.termguicolors = true
vim.o.background = "dark"
vim.opt.colorcolumn = "80"

-- scroll

vim.opt.scrolloff = 8

-- general keymaps

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ev", ":e $MYVIMRC<CR>")
vim.keymap.set("n", "<leader>o", ":NvimTreeToggle<CR>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "H", ":help <C-r><C-w><CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", "\"_dp")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>tw4", "<cmd>lua SetTabWidth(4)<CR>")
vim.keymap.set("n", "<leader>tw2", "<cmd>lua SetTabWidth(2)<CR>")

------------------------------------------------------------------------ plugins

-- lazy nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "wbthomason/packer.nvim",
    "lewis6991/gitsigns.nvim",
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "hrsh7th/cmp-nvim-lua",
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { 
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets"
        }
    },
})

-- git signs

require("gitsigns").setup {
    signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "-" },
        topdelete    = { text = "-" },
        changedelete = { text = "~" },
        untracked    = { text = "|" },
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
        virt_text_pos = "eol",
        delay = 1,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "    ~ <author>, <author_time:%Y-%m-%d %I:%M%p> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 4000000000,
    preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    },
}

-- lsp

local lsp = require("lsp-zero").preset({})
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local lsp_config = require("lspconfig")

vim.diagnostic.config({
    virtual_text = true,
})

-- cmp

local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "buffer", max_item_count = 3 },
        { name = "luasnip" },
    },
    mapping = {
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = nil,
        ["<C-Space>"] = nil,
        ["<S-Tab>"] = nil,
        ["<Enter>"] = nil,
    },
})

-- luasnip

require("luasnip.loaders.from_vscode").lazy_load()

-- lsp

lsp.set_sign_icons({
    error = " ",
    warn = " ",
    info = " ",
    hint = " ⚑"
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

--- low level

lsp_config.clangd.setup{}

lsp_config.zls.setup{}

lsp_config.rust_analyzer.setup{}

--- mid level

lsp_config.gopls.setup{}

--- scripting

lsp_config.pylsp.setup{
    root_dir = lsp_config.util.root_pattern(".git"),
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

--- libs

lsp_config.tailwindcss.setup{}

lsp.setup()

-- telescope

local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fa", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>ff", telescope_builtin.git_files, {})
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", {})
vim.keymap.set("n", "<leader>fp", function()
    telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- treesitter

require"nvim-treesitter.configs".setup {
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

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- nvim tree

require"nvim-tree".setup()

-- lualine

require("lualine").setup {
    extensions = { "nvim-tree", "fugitive" }
}
