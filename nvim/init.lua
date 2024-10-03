require("config.lazy")

vim.keymap.set('n', 'e1', function() print('Example 1.') end)
vim.keymap.set('n', '<Leader>1', function() print('Pressed Leader 1.') end)
vim.keymap.set('n', 'ex', ":w <bar> exec '!python3 '.shellscape('%')<CR>")

