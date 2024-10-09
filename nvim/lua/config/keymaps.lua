-- KEY MAPS
local path_to_project = os.getenv("USERPROFILE") .. "\\Desktop\\Python_projects\\Nvim_config"

vim.g.mapleader = ' '
vim.keymap.set('n', '<Leader>f', string.format(':cd %s<cr>', path_to_project))
vim.keymap.set('n', '<Leader>g', ':e some_script.py<cr>')
vim.keymap.set('n', '<C-b>', ":w <bar> exec '!python '.shellescape('%')<CR>")


--[[
Examples:
vim.keymap.set('n', 'e1', function() print('Example 1.') end)
vim.keymap.set('n', '<Leader>1', function() print('Pressed Leader 1.') end)
vim.keymap.set('n', '<Leader>r', function() print(vim.fn.expand('%:p')))
-- https://neovim.io/doc/user/builtin.html#expand()
-- % current file name, :p full path, :h extension
-- other special registers at https://neovim.io/doc/user/cmdline.html#c_CTRL-R
-- SPECIAL CHARS => https://neovim.io/doc/user/intro.html#key-notation
]]
