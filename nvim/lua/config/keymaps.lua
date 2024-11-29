-- KEY MAPS
local path_to_project = os.getenv('USERPROFILE') .. '\\Desktop\\Python_projects\\Nvim_config'

vim.g.mapleader = ' '  -- Already set in lazy.lua as needed for installations. TODO: Break keymaps in basic and for plugins.
-- vim.g.maplocalleader = "\\"
vim.keymap.set('n', '<Leader>f', string.format(':cd %s<cr>', path_to_project))
--vim.keymap.set('n', '<Leader>g', ':e some_script.py<cr>')
--vim.keymap.set('n', '<C-b>', ":w <bar> exec '!python '.shellescape('%')<CR>")
--vim.keymap.set('i', '<C-b>', "<Esc> :w <bar> exec '!python '.shellescape('%')<CR>")  -- https://vi.stackexchange.com/a/29347
-- make sure 'let g:asyncrun_open = 23' or w/e is set or under options by default to auto open window
--vim.keymap.set('n', '<C-b>', ':AsyncRun python %<CR>')  -- won't work unless asyncrun_open is set to a value or :copen 15 is run
vim.keymap.set({ 'n', 'i' }, '<C-b>', '<Esc>:w<CR>:let g:asyncrun_open=15<CR>:AsyncRun python %<CR>')  -- TODO: Not set up auto open window option.
vim.keymap.set({ 'n', 'i' }, '<Leader>b', '<Esc>:AsyncStop<CR>:cclose<CR>')
--vim.keymap.set('n', '<C-b>', '<Esc>:AsyncStop<CR>:cclose<CR>')


-- EDITING THE FILE --
-- Note! <C-/> maps to <C-_> in Windows!
--vim.keymap.set({'n', 'i'}, '<C-/>', ':lua print("Toggled comments!")<CR>')  -- to test combination triggering
--vim.keymap.set({'n', 'i'}, '<C-_>', require("Comment.api").call("toggle_current_linewise_op"))  -- won't work
--vim.keymap.set({'n', 'i'}, '<C-_>', require("Comment.api").toggle_current_linewise_op())  -- gives property is nill
vim.keymap.set({'n'}, '<C-_>', ':normal gcc<CR>')           -- commenting the line
vim.keymap.set({'i'}, '<C-_>', '<ESC>:normal gcc<CR>a')     -- commenting the line and go back into insert mode


-- TELESCOPE SEARCH --
local telescope_builtins = require('telescope.builtin')
vim.keymap.set('n', 'ff', telescope_builtins.find_files, { desc = 'Telescope find files.' })
vim.keymap.set('n', 'fg', telescope_builtins.live_grep, { desc = 'Telescope live grep.' })
vim.keymap.set('n', 'fb', telescope_builtins.buffers, { desc = 'Telescope buffers.' })
vim.keymap.set('n', 'fh', telescope_builtins.help_tags, { desc = 'Telescope help tags.' })


---- NVIM-TREE FS MANIPULATION --
-- Alternative to :NvimTreeOpen and NvimTreeClose:
vim.keymap.set({'n'}, '<leader>df', ':NvimTreeToggle<CR>', {desc = 'Open/Close neovim directory tree.'})
vim.keymap.set({'i'}, '<leader>df', '<ESC>:NvimTreeToggle<CR>', {desc = 'Open/Close neovim directory tree.'})


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
