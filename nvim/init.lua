-- lua folder and extension are implied: config.options instead of lua.config.options.lua
-- config folder under lua so there are no collisions with other lua generated files + helps to struct (diff distros)
-- . is a placeholder for either . or / and is used to denote a folder preeceding it


require('config.options')
require('config.lazy')
require('plugins.fs_config')
require('config.keymaps')
require('plugins.alpha_greet_screen')

require('plugins.catppuccin')
require('plugins.autocompletion')   -- nvim-cmp with vsnip.
require('plugins.lsp_config')       -- lsp server setup.


vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0


--[[
-- Making auto commands:
local os = require('os')

local desired_path = os.getenv('USERPROFILE') .. '\\Desktop\\Python_projects\\Nvim_config'
print(desired_path)

local event_name = 'VimEnter'

local path_to_desktop = os.getenv("USERPROFILE") .. "\\Desktop"
local vim_enter_group = vim.api.nvim_create_augroup("vim_enter_group", { clear = true })
vim.api.nvim_create_autocmd(
    {"VimEnter"},
    { pattern = "*", command = "cd " .. path_to_desktop, group = vim_enter_group }
)
vim.api.nvim_create_autocmd(event_name, {pattern={'*'}, callback=print('Works!')})
vim.api.nvim_create_autocmd(event_name, {pattern={'*'}, command='cd ' .. desired_path})
]]
