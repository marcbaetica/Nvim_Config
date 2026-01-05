require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua', 'python', 'vim', 'vimdoc', 'json', 'bash', },
    playground = { enable = false },
    highlight = {
        -- get it only from treesitter while still keeping colors coming in from catppuccin
        enable = true,
        -- use highlighting from only traditional treesitter and catppuccin
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            node_decremental = '<BS>',
        },
    },
    -- rely only on Nvim's built-in indentation (smartindent, cindent)
    indent = { enable = false },
}

