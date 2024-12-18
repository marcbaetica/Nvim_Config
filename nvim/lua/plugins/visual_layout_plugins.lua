-- Catppuccin.

local themes = {'catppuccin', 'catppuccin-latte', 'catppuccin-frappe', 'catppuccin-macchiato', 'catppuccin-mocha'}

require('catppuccin').setup({
    config = function()
        local set_color_command = string.format('colorscheme %s', themes[4])
        vim.print('Using ' .. set_color_command .. '.')
        vim.cmd(set_color_command)
    end,
})


-- Alpha Greet Screen.

local header_basic = {
    type = 'text',
    val = {
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡘⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡿⢡⣿⠛⠉⠛⣿⣿⠿⠻⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⣼⡇⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⠿⢡⡋⠁⠀⠀⠀⢸⣏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⣾⠂⠀⠀⠀⠀⠀⠀⠘⣿⣋⣥⣶⣿⣷⡀⢀⣠⣤⠟⠛⢦⣤⣬⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠐⠋⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⢢⠀⠙⠛⠻⣿⣿⣇⡀⣀⢸⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⢀⡀⣾⢂⡇⢤⡄⠀⠀⠀⠀⠀⠀⠀⠘⠂⣿⣿⡇⠈⠮⢿⡿⣿⣿⣿⠀⠀⠀⠀⠀⠀⡀⠀⠉⠀⠂⠄⢀⠀⠀⠀  ',
        '⠀⡸⢡⡇⣸⡇⢸⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣷⣄⣀⢀⣀⢀⣈⡀⠀⠀⠀⠀⠀⢠⠁⠀⠀⣀⡄⣀⠀⠀⠀⠀  ',
        '⠸⣥⠸⡇⢢⠀⣿⢁⡇⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⡄⠀⠀⡀⠅⣌⠻⠧⠄⠀⠀  ',
        '⠀⠹⣦⠁⠸⠰⢣⡞⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⡓⠒⠲⠶⢶⠉⠛⠋⠁⠀⠀⠀⠀⢠⠁⠀⠀⠁⣀⠉⠋⢖⣰⡆⠀  ',
        '⠀⠀⠨⣅⠐⢂⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣭⣭⣭⣍⣁⠀⠀⠀⠀⠀⠀⠀⠀⡈⠀⠀⠀⢨⣿⡛⠐⢸⣿⣷⠀  ',
        '⠀⠀⢶⣶⠀⣶⡅⠀⠀⠀⠀⠀⠀⠀⡠⠐⠀⢐⡿⠷⠶⠂⣂⠀⠲⠦⣀⠀⠀⠀⠀⢑⠀⠀⠀⠀⠈⠉⢠⣿⣧⠟⠀  ',
        '⠀⠀⣼⡏⣸⡿⠁⠙⢛⣛⣛⠓⠐⠬⠅⠀⣀⣈⣁⣀⣤⡄⢀⣠⣄⢤⣤⠁⠄⢊⣥⡀⣀⡈⠑⠀⠀⠁⠀⢙⠋⠄⣀  ',
        '⠀⢠⣿⣰⣿⢡⣷⡀⣿⡿⠃⠸⣇⠀⠉⠓⠶⠶⠤⠤⠄⠸⣿⣿⣿⡆⠰⠶⠃⠈⠻⠁⣿⣿⣿⣧⠀⠀⠀⢿⣿⣿⣟  ',
        '⠀⢸⣿⣿⡟⣸⣿⠃⣿⠁⣦⠀⠙⢷⣤⣄⣀⡀⠀⠀⠀⢀⣈⢻⣿⠀⡀⠀⠀⣠⠆⢷⡙⢛⣿⣏⠀⠀⠀⠠⡙⣿⡏  ',
        '⠀⢸⣿⣿⡇⣿⡏⣸⡇⠀⠘⢧⣀⠀⠀⠉⠙⠛⠛⠛⠛⠉⢁⡘⣿⣷⠀⡀⠉⠁⠀⣂⢻⡄⠻⣿⣄⠀⠀⠀⣿⡌⠀  ',
        '⠀⠈⢻⣿⡇⠛⠀⠘⠁⢦⡀⠀⠙⠿⣶⣦⣤⣤⣤⣤⡴⠞⠋⠐⢿⣿⣧⠙⠲⠶⡶⠟⢠⠀⠀⠹⣿⣆⠀⠀⡟⠀⠀  ',
        '⠀⠀⠀⠻⠇⠀⠀⠀⠀⡈⠻⣦⣄⠀⠀⠀⠉⠉⠉⠀⠀⠀⢀⣴⢈⣿⣧⠰⣄⡀⠀⠀⢀⡇⠀⠀⠙⢿⣷⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣆⡈⠻⢿⣶⣦⣤⣤⣤⣤⣶⡶⠟⠁⢈⠻⣿⠗⠈⠛⠓⠖⠛⠁⠀⠀⠀⠈⠋⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣦⣄⠈⠉⠉⠉⠉⠉⠁⢀⣠⣶⠟⢸⣿⣆⠓⢤⡀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⠿⣶⣶⣶⣶⠿⠟⠋⠀⠀⠀⠙⠃⠀⠀⠈⠉⠙⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ',


    },
    opts = {
        position = 'center',
        hl = 'Type',
        -- wrap = 'overflow';
    },
}

require('alpha').setup({
    layout = {
        { type = 'padding', val = 2 },
        header_basic,                      -- TODO: Default to basic if not found.
        --{ type = 'padding', val = 2 },
        --section_mru,
        --{ type = 'padding", val = 2 },
        --buttons,
    },
    opts = {
        margin = 5,
        setup = function()
            vim.api.nvim_create_autocmd('DirChanged', {
                pattern = '*',
                group = "alpha_temp",
                callback = function ()
                    require('alpha').redraw()
                    vim.cmd('AlphaRemap')
                end,
            })
        end,
    },
})
