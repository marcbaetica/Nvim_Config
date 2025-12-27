vim.g.mapleader = ' '  -- Already set in lazy.lua as needed for installations.
local km = vim.keymap


-- CD TO PROJECTS DIR --
local path_to_project = os.getenv('USERPROFILE') .. '\\Desktop\\Projects'
km.set('n', '<A-f>', string.format(':cd %s<cr>', path_to_project))


-- RUN BUFFER CONTENTS --
km.set({ 'n', 'i' }, '<C-b>', '<Esc>:w<CR>:let g:asyncrun_open=15<CR>:AsyncRun python %<CR>')  -- TODO: Not set up auto open window option.
km.set({ 'n', 'i' }, '<A-b>', '<Esc>:AsyncStop<CR>:cclose<CR>')


-- EDITING THE FILE --
km.set({'n'}, '<C-_>', ':normal gcc<CR>')           -- commenting the line
km.set({'i'}, '<C-_>', '<ESC>:normal gcc<CR>a')     -- commenting the line and go back into insert mode


-- TELESCOPE SEARCH --
local telescope_builtins = require('telescope.builtin')
km.set('n', 'ff', telescope_builtins.find_files, { desc = 'Telescope find files.' })
km.set('n', 'fg', telescope_builtins.live_grep, { desc = 'Telescope live grep.' })
km.set('n', 'fb', telescope_builtins.buffers, { desc = 'Telescope buffers.' })
km.set('n', 'fh', telescope_builtins.help_tags, { desc = 'Telescope help tags.' })


-- FS TREE VIEW --
km.set({'n', 'i', 'v'}, '<leader>df', '<ESC>:NvimTreeToggle<CR>', {desc = 'Open/Close neovim directory tree.'})


-- CHANGE SCREEN CURSOR --
-- km.set('n', '<C-j>', '<C-w>-j')  -- somehow this shrinks the  currently selected window
-- km.set('n', '<C-k>', '<C-w>-k')  -- somehow this shrinks the currently selected window
km.set('n', '<C-j>', ':wincmd j<CR>')
km.set('n', '<C-k>', ':wincmd k<CR>')
km.set('n', '<C-h>', ':wincmd h<CR>')
km.set('n', '<C-l>', ':wincmd l<CR>')


-- SEARCH NEXT/PREVIOUS WORD --
km.set('n', '<esc>', '<esc>:noh<return><esc>', { desc = 'Disable highlighting from <S-*> (next) or <S-#> (previous).' })


--[[
https://neovim.io/doc/user/builtin.html#expand()
% current file name, :p full path, :h extension
other special registers at https://neovim.io/doc/user/cmdline.html#c_CTRL-R
SPECIAL CHARS => https://neovim.io/doc/user/intro.html#key-notation
]]
