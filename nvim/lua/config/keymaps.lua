-- KEY MAPS
local path_to_project = os.getenv("USERPROFILE") .. "\\Desktop\\Python_projects\\Nvim_config"

vim.g.mapleader = ' '  -- Already set in lazy.lua as needed for installations. TODO: Break keymaps in basic and for plugins.
-- vim.g.maplocalleader = "\\"
vim.keymap.set('n', '<Leader>f', string.format(':cd %s<cr>', path_to_project))
--vim.keymap.set('n', '<Leader>g', ':e some_script.py<cr>')
vim.keymap.set('n', '<C-b>', ":w <bar> exec '!python '.shellescape('%')<CR>")
vim.keymap.set('i', '<C-b>', "<Esc> :w <bar> exec '!python '.shellescape('%')<CR>")


-- TELESCOPE SEARCH --
local telescope_builtins = require('telescope.builtin')
vim.keymap.set('n', 'ff', telescope_builtins.find_files, { desc = 'Telescope find files.' })
vim.keymap.set('n', 'fg', telescope_builtins.live_grep, { desc = 'Telescope live grep.' })
vim.keymap.set('n', 'fb', telescope_builtins.buffers, { desc = 'Telescope buffers.' })
vim.keymap.set('n', 'fh', telescope_builtins.help_tags, { desc = 'Telescope help tags.' })


-- CHANGE SCREEN CURSOR --
-- vim.keymap.set('n', '<C-j>', '<C-w>-j')  -- somehow this shrinks the  currently selected window
-- vim.keymap.set('n', '<C-k>', '<C-w>-k')  -- somehow this shrinks the currently selected window
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')


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
