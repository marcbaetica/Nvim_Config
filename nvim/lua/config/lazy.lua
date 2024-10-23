-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
    vim.fn.getchar()
    os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
        { 'goolord/alpha-nvim' },

        -- FS
        --{ "nvim-tree/nvim-tree.lua", version = "*", lazy = false, },
        { "nvim-tree/nvim-tree.lua", version = "*", lazy = false, dependencies = { "nvim-tree/nvim-web-devicons" }, },
        { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } }, -- tag = '0.1.8',

        -- LSP install and config
        { 'williamboman/mason.nvim', build = ':MasonUpdate' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'neovim/nvim-lspconfig' },

        -- Autocomplete stuff:
        { 'hrsh7th/nvim-cmp',
          lazy = false,
          priority = 100,
          dependencies = {
              { 'hrsh7th/cmp-buffer' },
              { 'hrsh7th/cmp-path' },
              { 'hrsh7th/cmp-nvim-lsp' }, -- Engine that provides lsp snippets to nvim-cmp.
          }
        },
        { 'hrsh7th/cmp-cmdline' },

        -- vsnip for code completion.
        { 'hrsh7th/cmp-vsnip' },
    },
    -- checker will only notify in the output buffer. :Lazy + <S-u> is still needed.
    checker = {
        enabled = true,
        notify = true,
    },
})
