function SetColors(color)
    color = color or "catppuccin"
    vim.cmd.colorscheme(color)
end

SetColors()
