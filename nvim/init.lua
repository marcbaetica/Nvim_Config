require("config.lazy")

vim.keymap.set('n', 'ex1', function() print('Example 1') end)
vim.keymap.set('n', '<Leader>ex1', function() print('Example 1 with leader key!') end)
