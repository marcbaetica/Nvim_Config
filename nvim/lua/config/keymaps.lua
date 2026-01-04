vim.g.mapleader = ' '  -- Already set in lazy.lua as needed for installations.
local km = vim.keymap


-- CD TO PROJECTS DIR --
local path_to_project = os.getenv('USERPROFILE') .. '\\Desktop\\Projects'
km.set('n', '<A-f>', string.format(':cd %s<cr>', path_to_project))


-- RUN BUFFER CONTENTS --
-- TODO: Keeping this for running in mode async (in a quickfix buffer) by default. Glyphs like : turn to | due to nvim UI engine.
-- km.set({ 'n', 'i' }, '<C-b>', '<Esc>:w<CR>:let g:asyncrun_open=15<CR>:AsyncRun python %<CR>')  -- TODO: Not set up auto open window option.
-- km.set({ 'n', 'i' }, '<C-b>', '<Esc>:w<CR>:let g:asyncrun_open=15<CR>:AsyncRun -mode=term -focus=0 python %<CR>')  -- TODO: Not set up auto open window option.
vim.keymap.set({'n', 'i'}, '<C-b>', function()
    local current_buf_id = vim.api.nvim_get_current_buf()
    if vim.bo[current_buf_id].modified then
        print('Buffer was modified. Saving contents.')
        vim.cmd('write')
        print(string.format('Is buffer still modified: %s', vim.bo[current_buf_id].modified))
    end
    -- Won't render if buffer is not attached to a file. Neither will nvim.bo be populated.
    -- local file_name = vim.fn.expand('%')
    local file_name = vim.api.nvim_buf_get_name(0)
    local file_extension = file_name ~= '' and file_name:match('^.+%.([^.]+)$') or nil
    vim.print(string.format('file_extension=%s', file_extension))
    if file_extension == 'py' then
        vim.print(string.format('Found extension [%s]. Running...', file_extension))
        -- vim.cmd('let g:asyncrun_open=15')
        vim.cmd(string.format('AsyncRun -mode=term -focus=0 python %s', file_name))
    elseif file_extension == 'lua' then
        vim.print(string.format('Found extension [%s]. Running...', file_extension))
        -- vim.cmd('let g:asyncrun_open=15')
        vim.cmd(string.format('AsyncRun -mode=term -focus=0 nvim --headless -c "luafile %s" -c "qa!"', file_name))
    else
        vim.print(string.format('Extension [%s] is not supported for running.', file_extension))
    end
end)

-- km.set({ 'n', 'i' }, '<A-b>', '<Esc>:AsyncStop<CR>:cclose<CR>')
km.set({ 'n', 'i' }, '<A-b>', function()
    vim.print('Pressed close!')
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
        local buf_loaded = vim.api.nvim_buf_is_loaded(buf)
        vim.print(string.format('buf_name=%s, %s', buf_name, type(buf_name)))
        vim.print(string.format('buf_type=%s, %s', buf_type, type(buf_type)))
        vim.print(string.format('buf_loaded=%s, %s', buf_loaded, type(buf_loaded)))
        -- better to guard it with pcall as 'terminal_job_id' only exists on terminal buffers so this line will throw an error for any normal buffer
        -- local buf_job_id = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')      
        -- pcall freezes operation if failure so a better option is to run it conditionally if the buffer is a terminal
        -- local ok, buf_job_id = pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
        if 'terminal' == buf_type then
            local ok, buf_job_id = pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
            vim.print('It is a terminal!')
            vim.print(string.format('ok=%s, %s', ok, type(ok)))
            vim.print(string.format('buf_job_id=%s, %s', buf_job_id, type(buf_job_id)))
            local job_status = vim.fn.jobwait({buf_job_id}, 0)[1]   -- 0ms timeout
            print(job_status)
            if ok == true then
                vim.print(string.format('Stopping runnig job with id %d in buffer with id %d.', buf_job_id, buf))
                local chan = vim.api.nvim_buf_get_option(buf, "channel")
                vim.print(string.format('chan=%s', chan))
                if job_status == -1 then
                    vim.print('Job is still running. Sending interrupt signal.')
                    vim.fn.chansend(chan, "\003")  -- Ctrl-C
                    vim.print('Done.')
                end
                -- vim.fn.jobstop(buf_job_id)
                local job_status = vim.fn.jobwait({buf_job_id}, 0)[1]   -- 0ms timeout
                print(job_status)
                local chan = vim.api.nvim_buf_get_option(buf, "channel")
                vim.print(string.format('chan=%s', chan))
                -- without closing the window, nvim will freeze upon a new AsyncRun -mode=term run
                vim.api.nvim_buf_delete(buf, { force = true })      -- deleting the buffer closes the window as well
            end
        end
        vim.print('\n')
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
