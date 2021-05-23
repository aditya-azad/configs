local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then
        scopes['o'][key] = value
    end
end

opt('o', 'hidden', true)

opt('w', 'number', true)
opt('w', 'relativenumber', true)

opt('o', 'mouse', 'a')

opt('o', 'errorbells', false)
opt('o', 'visualbell', false)

opt('o', 'showmode', false)
opt('o', 'showmatch', true)
opt('o', 'undolevels', 1000)
opt('o', 'updatetime', 100)
opt('o', 'incsearch', true)
opt('o', 'linebreak', true)
opt('o', 'ignorecase', true)
opt('o', 'hlsearch', false)

opt('b', 'expandtab', false)

opt('o', 'smartcase', true)
opt('o', 'smarttab', true)
opt('o', 'smartindent', true)
opt('o', 'autoindent', true)

opt('o', 'shiftwidth', 2)
opt('o', 'tabstop', 2)
opt('o', 'softtabstop', 2)

opt('o', 'listchars', 'tab:» ,extends:›,precedes:‹,nbsp:·,trail:·')
opt('w', 'list', true)


opt('o', 'swapfile', true)
opt('o', 'backup', true)
opt('o', 'undofile', true)
opt('o', 'backupdir', 'C:/Users/azada/AppData/Local/nvim/.tmp/backup//')
opt('o', 'directory', 'C:/Users/azada/AppData/Local/nvim/.tmp/swap//')
opt('o', 'undodir', 'C:/Users/azada/AppData/Local/nvim/.tmp/undo//')

opt('o', 'clipboard', 'unnamedplus')

opt('o', 'backspace', 'indent,eol,start')

opt('o', 'completeopt', 'menuone,noselect')

opt('o', 'shortmess', 'cI')
