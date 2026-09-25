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

-- mdmath.nvim build hook: run `npm install` in its mdmath-js/ on install/update
-- (vim.pack doesn't run build steps; lazy.nvim did this via `build`).
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'mdmath.nvim' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then vim.cmd.packadd('mdmath.nvim') end
            require('mdmath').build()
        end
    end,
})

vim.pack.add({
    -- dependencies (load before their dependents)
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/sindrets/diffview.nvim',
    'https://github.com/Bilal2453/luvit-meta',
    'https://github.com/tpope/vim-dadbod',
    'https://github.com/kristijanhusak/vim-dadbod-completion',

    'https://github.com/aditya-azad/obelisk',
    'https://github.com/aditya-azad/neoflash',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/mbbill/undotree',
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/williamboman/mason-lspconfig.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    'https://github.com/tpope/vim-sleuth',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/hrsh7th/cmp-nvim-lua',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-buffer',
    'https://github.com/hrsh7th/cmp-path',
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/saadparwaiz1/cmp_luasnip',
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    'https://github.com/Thiago4532/mdmath.nvim',
    'https://github.com/kristijanhusak/vim-dadbod-ui',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/folke/todo-comments.nvim',
    'https://github.com/projekt0n/github-nvim-theme',
    'https://github.com/3rd/image.nvim',
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '0.1.8' },
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/NeogitOrg/neogit',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/rcarriga/nvim-notify',
    'https://github.com/folke/which-key.nvim',
}, { load = true, confirm = false })

-- notify (route messages through nvim-notify)

local notify = require("notify")
notify.setup({
    render = "compact",
    stages = "fade_in_slide_out",
    timeout = 3000,
    max_width = 50,
    top_down = false,
})
vim.notify = notify

-- notes

require("obelisk").setup({ notes_dir = "~/database/workspace/notes" })
require("neoflash").setup({ notes_dir = "~/database/workspace/notes" })

-- db ui (vim-dadbod-ui reads these globals when its commands run)

vim.g.db_ui_use_nerd_fonts = 1

-- lazydev (lua lsp annotations; must be set up before lsp.enable)

require("lazydev").setup({
    library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
})

-- which-key

require("which-key").setup()
vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- mdmath / image (markdown rendering)

require("mdmath").setup({ dynamic = true, dynamic_scale = 0.75 })
require("image").setup({ processor = "magick_cli" })

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

-- zig
lsp.config('zls', {
    cmd = { "zls" },
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

-- python (pip install ruff pyrefly)

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
})

vim.lsp.config('pyrefly', {})

-- php

lsp.config('intelephense', {
    capabilities = capabilities,
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

-- latex
lsp.config("texlab", {
    capabilities = capabilities,
    settings = {
        texlab = {
            build = {
                executable = "latexmk",
                args = {
                    "-pdf",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "%f",
                },
                onSave = true,
                forwardSearchAfter = true,
            },
            forwardSearch = {
                executable = "evince-synctex",
                args = {
                    "-f",
                    "%l",
                    "%p",
                    "nvim --server $NVIM --remote-send '<Cmd>call cursor(%l, 1)<CR>'",
                },
            },
            chktex = {
                onOpenAndSave = true,
            },
        },
    },
})

-- finally enable all configured servers
for _, name in ipairs({
    "clangd",
    "rust_analyzer",
    "gopls",
    "zls",
    "ruff",
    "ts_ls",
    "tailwindcss",
    "pyrefly",
    "intelephense",
    "lua_ls",
    "texlab"
}) do
    lsp.enable(name)
end

-- latex

local function latex_pdf_path(tex_file)
    local stem = tex_file:gsub("%.tex$", "")

    local candidates = {
        stem .. ".pdf",
        vim.fn.fnamemodify(tex_file, ":h") .. "/build/" .. vim.fn.fnamemodify(stem, ":t") .. ".pdf",
        vim.fn.fnamemodify(tex_file, ":h") .. "/_build/" .. vim.fn.fnamemodify(stem, ":t") .. ".pdf",
        vim.fn.fnamemodify(tex_file, ":h") .. "/out/" .. vim.fn.fnamemodify(stem, ":t") .. ".pdf",
    }

    for _, file in ipairs(candidates) do
        if vim.fn.filereadable(file) == 1 then
            return file
        end
    end

    return candidates[1]
end

vim.keymap.set("n", "<leader>lb", function()
    vim.cmd.write()

    local tex_file = vim.fn.expand("%:p")
    local tex_dir = vim.fn.fnamemodify(tex_file, ":h")
    local tex_name = vim.fn.fnamemodify(tex_file, ":t")

    vim.notify("Building " .. tex_name .. "…")

    vim.fn.jobstart({
        "latexmk",
        "-pdf",
        "-interaction=nonstopmode",
        "-synctex=1",
        tex_name,
    }, {
        cwd = tex_dir,
        stdout_buffered = true,
        stderr_buffered = true,
        on_exit = function(_, exit_code)
            vim.schedule(function()
                if exit_code == 0 then
                    vim.notify("LaTeX build succeeded")
                else
                    vim.notify(
                        "LaTeX build failed — run :!latexmk -pdf "
                            .. vim.fn.shellescape(tex_name)
                            .. " to inspect the error.",
                        vim.log.levels.ERROR
                    )
                end
            end)
        end,
    })
end, { desc = "LaTeX build with latexmk" })

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

require("todo-comments").setup()
vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Search over todo comments" })

-- theme

require('theme')

-- neogit

local neogit = require("neogit")

neogit.setup {
    disable_context_highlighting = true,
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
    vim.cmd(":Neogit kind=floating cwd=%:p:h")
end, {})

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

-- render markdown

require("render-markdown").setup({
  latex = { enabled = false },
})
