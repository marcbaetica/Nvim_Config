require('telescope').setup({})


--[[ Same as this inside the lazy-setup-spec definition.
  config = function()
    require("nvim-tree").setup {}
  end,
--]]
require('nvim-tree').setup({})