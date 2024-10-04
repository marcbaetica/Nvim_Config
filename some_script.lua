local os = require('os')
vim.print('This is a test!')
print('This is a test 2!')

local desired_path = os.getenv('USERPROFILE') .. '\\Desktop\\Python_projects\\Nvim_config'

print(desired_path)

local event_name = 'VimEnter'

vim.api.nvim_create_autocmd(event_name, {pattern={'*'}, callback=print('Works!')})

vim.api.nvim_create_autocmd(event_name, {pattern={'*'}, command='cd ' .. desired_path})



