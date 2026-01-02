-- Might not be useful since transitioning to AsyncRun mode to terminal instead of to a quickfix buffer.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.cursorcolumn = false                                      -- disable cursorcolumn 
        vim.api.nvim_set_hl(0, "CursorColumn", { bg = "NONE" })                 -- in case color still exists
        vim.cmd("hi! link qfFileName NONE")                                     -- needed for the next step to work
        vim.api.nvim_set_hl(0, "qfFileName", { fg = "NONE", bg = "NONE" })      -- disable all front and background qf coloring
    end,
})


-- NOTE:
-- vim.api.nvim_set_hl(ns, "CursorColumn", { bg = "NONE" }) directly modifies the HIGHLIGHT GROUP.
-- ns = namespace, 0 for global
-- group_name = name of the highlight group to modify
-- opts = table of attributes to change: fg, bg, bold, italic, etc.
-- It doesn't touch buffer/window-local options, which is why vim.opt_local.cursorcolumn = false is still needed. It disables the option itself, but not the highlight.
-- opt only controls options, not highlighted groups.
-- vim.opt_local.cursorcolumn as an option is window-local, but the color it uses comes from the highlit group CursorColumn, which is global.
-- That's why, in order to change to color, the highlight group must be overriden.
-- Catpuchin and other colorschemes do: hi! def link qfFileName Normal. This means qfFileName doesn't have its own color - it inherits from Normal.
-- NONE breaks the link, allowing the changes from nvim_set_hl to take effect.

