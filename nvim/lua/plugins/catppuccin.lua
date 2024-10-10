-- plugins/catppuccin.lua:
local themes = {'catppuccin', 'catppuccin-latte', 'catppuccin-frappe', 'catppuccin-macchiato', 'catppuccin-mocha'}
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        local set_color_command = string.format('colorscheme %s', themes[4])
        vim.print('Using ' .. set_color_command .. '.')
        vim.cmd(set_color_command)
        -- vim.cmd([[colorscheme catppuccin-latte]])
    end,
}
