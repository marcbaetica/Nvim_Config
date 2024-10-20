local header_basic = {
    type = "text",
    val = {
        [[                                  __]],
        [[     ___     ___    ___   __  __ /\_\    ___ ___]],
        [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
        [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
        [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    },
    opts = {
        position = "center",
        hl = "Type",
        -- wrap = "overflow";
    },
}



require('alpha').setup({
    layout = {
        { type = "padding", val = 2 },
        header_custom,                      -- TODO: Dfault to basic if not found.
        --{ type = "padding", val = 2 },
        --section_mru,
        --{ type = "padding", val = 2 },
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