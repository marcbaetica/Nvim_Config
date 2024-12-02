-- [nvim\lua] folder and extension are implied: config.options instead of lua.config.options.lua
-- config folder under lua so there are no collisions with other lua generated files + helps to struct (diff distros)
-- . is a placeholder for either . or / and is used to denote a folder preceding it
-- These plugins get called and the .setup({}) gets implicitly added.


require('config.options')
require('config.lazy')
require('plugins.visual_layout_plugins')
require('plugins.file_system_plugins')
require('plugins.lsp_config')       -- lsp server setup.
require('plugins.autocompletion')   -- nvim-cmp with vsnip.
require('config.keymaps')           -- At the end for all plugin shortcuts (ex: telescope).


vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.print(string.format('CWD: %s', vim.loop.cwd()))
