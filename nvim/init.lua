-- [nvim\lua] folder and extension are implied: config.options instead of lua.config.options.lua
-- config folder under lua so there are no collisions with other lua generated files + helps to struct (diff distros)
-- . is a placeholder for either . or / and is used to denote a folder preceding it
-- These plugins get called and the .setup({}) gets implicitly added.

-- require('..') will look for either the folders separated by '.' and inside the last one the init.lua file.
-- Alternatively, it will look for the file with the same name but with a lua extension.
-- Nvim only looks for lua files to require inside of folders that have a lua as it's top level folder and those folders
-- need to be inside the runtime path.
-- :echo nvim.list_runtime_paths()  -> See all existing runtime paths.

require('config.options')
require('config.lazy')              -- lazy-loading plugins
require('config.autocmds')
require('plugins.visual_layout_plugins')
require('plugins.file_system_plugins')
require('plugins.lsp_config')       -- lsp server setup
require('plugins.autocompletion')   -- nvim-cmp with vsnip
require('config.keymaps')           -- set up shortcuts (at the end for all plugin loading (ex: telescope))


vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.print(string.format('CWD: %s', vim.loop.cwd()))
