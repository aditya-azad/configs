-------------------------------------------------------------- custom functions

function SetTabWidth(width)
    vim.opt.tabstop = width
    vim.opt.softtabstop = width
    vim.opt.shiftwidth = width
    print("Switching tab width to " .. width .. "...")
end

function ToggleWordWrap()
    if vim.wo.wrap == false then
        vim.wo.wrap = true
        vim.wo.linebreak = true
        print("Word wrap on...")
    else
        vim.wo.wrap = false
        vim.wo.linebreak = false
        print("Word wrap off...")
    end
end

function P(v)
    print(vim.inspect(v))
    return v
end

---------------------------------------------------------------------- settings

-- general

vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.updatetime = 100
vim.opt.clipboard:append { "unnamed", "unnamedplus" }
vim.g.clipboard = {
    name = "xclip",
    copy = {
        ["+"] = "xclip -selection clipboard -i",
        ["*"] = "xclip -selection clipboard -i"
    },
    paste = {
        ["+"] = "xclip -selection clipboard -o",
        ["*"] = "xclip -selection clipboard -o"
    }
}
vim.opt.backspace:append { "indent", "eol", "start" }
vim.opt.mouse = "a"

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
    tab = "» ",
    space = "·",
    trail = "·",
    extends = ">",
    precedes = "<",
}
vim.opt.fillchars = {
    vert = "┃",
}

-- searching

vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.shortmess = "filnxtToOFc"

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

-- scroll

vim.opt.scrolloff = 8

-- general keymaps

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>z', function()
    local current_win = vim.api.nvim_get_current_win()
    local win_height = vim.api.nvim_win_get_height(current_win)
    local win_width = vim.api.nvim_win_get_width(current_win)
    local total_height = vim.o.lines - vim.o.cmdheight - 1
    local total_width = vim.o.columns
    if win_height > total_height * 0.8 and win_width > total_width * 0.8 then
        vim.cmd('wincmd =')
    else
        vim.cmd('wincmd _')
        vim.cmd('wincmd |')
    end
end, { desc = 'Toggle window maximize' })
vim.keymap.set("n", "<leader>ev", ":e $MYVIMRC<CR>", { desc = "Open vimrc" })
vim.keymap.set("n", "-", ":Oil --float<CR>", { desc = "Open explorer" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Remove new line character from end" })
vim.keymap.set("n", "H", ":help <C-r><C-w><CR>", { desc = "Vim help" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll own" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search" })
vim.keymap.set("x", "<leader>p", "\"_dp", { desc = "Paste without copying selected" })
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = "Search replace word under cursor" })
vim.keymap.set("n", "<leader>tw4", "<cmd>lua SetTabWidth(4)<CR>", { desc = "Set tab width to 4" })
vim.keymap.set("n", "<leader>tw2", "<cmd>lua SetTabWidth(2)<CR>", { desc = "Set tab width to 2" })
vim.keymap.set("n", "<leader>tww", "<cmd>lua ToggleWordWrap()<CR>", { desc = "Toggle word wrapping" })
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

------------------------------------------------------------------------ plugins

-- lazy nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
    "lewis6991/gitsigns.nvim",
    "mbbill/undotree",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "tpope/vim-sleuth",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme'
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        }
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
        dependencies = { "Bilal2453/luvit-meta" }
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
})

-- git signs

require("gitsigns").setup {
    signs                        = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged                 = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn                   = true,
    numhl                        = false,
    linehl                       = false,
    word_diff                    = false,
    watch_gitdir                 = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked          = true,
    current_line_blame           = false,
    current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "    ~ <author>, <author_time:%Y-%m-%d %I:%M%p> - <summary>",
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil,
    max_file_length              = 4000000000,
    preview_config               = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
    },
}

vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = "Toggle git blame" })

-- mason

require("mason").setup()
require("mason-lspconfig").setup({
    automatic_enable = false,
})

-- lsp

vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = true,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true, noremap = true, desc = "" }
        opts.desc = "Go to definition"
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        opts.desc = "Hover"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        opts.desc = "Format file"
        vim.keymap.set("n", "<leader>fs", function() vim.lsp.buf.format({ async = true }) end, opts)
        opts.desc = "List symbols in workspace"
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        opts.desc = "Hover diagnostics"
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        opts.desc = "Code Actions"
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        opts.desc = "Find references"
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        opts.desc = "Rename symbol"
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        opts.desc = "Signature help"
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end,
})

-- cmp

local cmp = require("cmp")
local luasnip = require("luasnip")

local cmp_select = { behavior = cmp.SelectBehavior.Select }

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
        { name = "buffer",  max_item_count = 3 },
        { name = "luasnip" },
    },
    mapping = {
        ["<C-f>"] = function(fallback)
            if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ["<C-b>"] = function(fallback)
            if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = nil,
        ["<Tab>"] = nil,
        ["<S-Tab>"] = nil,
        ["<Enter>"] = nil,
    },
})

cmp.setup.filetype({ "sql" }, {
    sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" }
    }
})

-- luasnip

require("luasnip.loaders.from_vscode").lazy_load()

-- lsp servers

local lsp = vim.lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- clangd
lsp.config('clangd', {
    cmd = { "clangd" },
    capabilities = capabilities,
})

-- rust
lsp.config('rust_analyzer', {
    capabilities = capabilities,
})

-- go
lsp.config('gopls', {
    capabilities = capabilities,
    filetypes = { "go", },
})

-- typescript/javascript (ts_ls)
lsp.config('ts_ls', {
    capabilities = capabilities,
})

-- tailwindcss
lsp.config('tailwindcss', {
    capabilities = capabilities,
})

-- python (pylsp)
lsp.config('pylsp', {
    capabilities = capabilities,
    settings = {
        single_file_support = false,
        pylsp = {
            configurationSources = { "flake8" },
            plugins = {
                yapf = { enabled = false },
                autopep8 = { enabled = false },
                black = { enabled = true },
                pyls_isort = { enabled = true },
                flake8 = { enabled = true, ignore = { 'E501' } },
                pyflakes = { enabled = true },
                pycodestyle = { enabled = false },
                pylint = { enabled = false, executable = "pylint" },
                mccabe = { enabled = false },
                pylsp_mypy = { enabled = true },
                jedi_completion = { fuzzy = false },
            }
        }
    }
})

-- lua
lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        }
    }
})

-- finally enable all configured servers
for _, name in ipairs({
    "clangd",
    "rust_analyzer",
    "gopls",
    "ts_ls",
    "tailwindcss",
    "pylsp",
    "lua_ls",
}) do
    lsp.enable(name)
end


-- telescope

local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fa", telescope_builtin.find_files, { desc = "Search all files" })
vim.keymap.set("n", "<leader>ff", telescope_builtin.git_files, { desc = "Search git files" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Search buffers" })
vim.keymap.set("n", "<leader>fq", telescope_builtin.diagnostics, { desc = "Open diagnostics" })
vim.keymap.set("n", "<leader>fp", telescope_builtin.live_grep, { desc = "Live grep files" })
vim.keymap.set("n", "<leader>fr", telescope_builtin.resume, { desc = "Show last picker results" })
vim.keymap.set("n", "<leader>fc", telescope_builtin.grep_string, { desc = "Find string under cursor" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Search help tags" })

-- ui select

require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    }
}
require("telescope").load_extension("ui-select")

-- todo comments

vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Search over todo comments" })

-- neogit

local neogit = require("neogit")

neogit.setup {
    kind = "floating",
    commit_editor = {
        kind = "floating",
        show_staged_diff = true,
    },
    commit_select_view = {
        kind = "floating",
    },
    integrations = {
        telescope = true,
    },
    mappings = {
        finder = {
            ["<Esc><Esc>"] = "Close",
        },
        status = {
            ["<Esc><Esc>"] = "Close",
        },
    }
}


vim.api.nvim_create_user_command('G', function()
    vim.cmd(":Neogit kind=floating")
end, {})

-- treesitter

require("nvim-treesitter.configs").setup {
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = { enable = true, },
}

-- undotree

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo Tree" })

-- oil

require("oil").setup({
    columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
    },
    keymaps = {
        ["<Esc><Esc>"] = "actions.close",
    },
    delete_to_trash = true,
    constrain_cursor = "name",
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
            return (name == "..")
        end,
    },
})

-- theme

require('theme')

-- lualine

require("lualine").setup({
    options = {
        disabled_filetypes = {
            statusline = { "NvimTree" },
            winbar = {}
        },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 3
            }
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    }
})
