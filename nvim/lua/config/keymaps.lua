vim.g.mapleader = ' '  -- Already set in lazy.lua as needed for installations.
local km = vim.keymap


-- CD TO PROJECTS DIR --
local path_to_project = os.getenv('USERPROFILE') .. '\\Desktop\\Projects'
km.set('n', '<A-f>', string.format(':cd %s<cr>', path_to_project))


-- RUN BUFFER CONTENTS --
-- TODO: Keeping this for running in mode async (in a quickfix buffer) by default. Glyphs like : turn to | due to nvim UI engine.
-- km.set({ 'n', 'i' }, '<C-b>', '<Esc>:w<CR>:let g:asyncrun_open=15<CR>:AsyncRun python %<CR>')  -- TODO: Not set up auto open window option.
km.set({ 'n', 'i' }, '<C-b>', '<Esc>:w<CR>:let g:asyncrun_open=15<CR>:AsyncRun -mode=term -focus=0 python %<CR>')  -- TODO: Not set up auto open window option.
-- km.set({ 'n', 'i' }, '<A-b>', '<Esc>:AsyncStop<CR>:cclose<CR>')
km.set({ 'n', 'i' }, '<A-b>', function()
    vim.print('Pressed close!')
    local buffers = vim.api.nvim_list_bufs()
    print('buf_name, buf_type, buf_loaded, buf_job_id')
    for _, buf in ipairs(buffers) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
        local buf_loaded = vim.api.nvim_buf_is_loaded(buf)
        local buf_job_id = vim.api.nvim_bif_get_var(buf, 'terminal_job_id')
        print(buf_name, buf_type, buf_loaded, buf_job_id)
        if 'terminal' == buf_type then
            print('It is a terminal!')
        end
end)



-- local buf = vim.api.nvim_get_current_buf()  -- buffer you want to stop

-- Get the terminal job ID
-- local ok, job_id = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
-- if ok and job_id then
    -- vim.fn.jobstop(job_id)  -- stops the running process
-- end

-- Now you can safely delete the buffer
-- vim.api.nvim_buf_delete(buf, { force = true })


km.set({ 'n', 'i' }, '<A-z-v>', function()
    vim.print('Pressed close!')     -- TODO: Remove this!
    local buf = vim.g.asyncrun_term_bufnr
    -- vim.print(buf)                  -- TODO: Remove this!
    -- returns nil
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.print('bd-ing!')        -- TODO: Remove this!
        vim.cmd('bd! ' .. buf)
    end
end)


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
