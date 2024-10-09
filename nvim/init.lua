-- lua folder and extension are implied: config.options instead of lua.config.options.lua
-- config folder under lua so there are no collisions with other lua generated files + helps to struct (diff distros)
-- . is a placeholder for either . or / and is used to denote a folder preeceding it


require('config.options')
require('config.lazy')
require('config.keymaps')


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
