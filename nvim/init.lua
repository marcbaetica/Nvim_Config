-- lua makes parenthesis optional... for require?
-- config folder under lua so there are no colisions with other lua generated files, and also helps to structure (diff distros)?
-- . is a placeholder for either . or / and is used to denote a folder preeceding it 
-- config.options is implied instead of lua.config.options.lua


require "config.options"

require("config.lazy")

vim.keymap.set('n', '<Leader>', '\\')
vim.keymap.set('n', 'e1', function() print('Example 1.') end)
vim.keymap.set('n', '<Leader>1', function() print('Pressed Leader 1.') end)
vim.keymap.set('n', 'ex', ":w <bar> exec '!python3 '.shellscape('%')<CR>")
vim.keymap.set('n', '<Leader>1', '<bar>python --version<CR>')

-- local os = require('os')
-- vim.print('This is a test!')
-- print('This is a test 2!')

-- local desired_path = os.getenv('USERPROFILE') .. '\\Desktop\\Python_projects\\Nvim_config'

-- print(desired_path)

-- local event_name = 'VimEnter'local os = require("os")

local path_to_desktop = os.getenv("USERPROFILE") .. "\\Desktop"

local vim_enter_group = vim.api.nvim_create_augroup("vim_enter_group", { clear = true })

vim.api.nvim_create_autocmd(
    {"VimEnter"},
    { pattern = "*", command = "cd " .. path_to_desktop, group = vim_enter_group }
)

-- vim.api.nvim_create_autocmd(event_name, {pattern={'*'}, callback=print('Works!')})

-- vim.api.nvim_create_autocmd(event_name, {pattern={'*'}, command='cd ' .. desired_path})



