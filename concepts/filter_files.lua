--[[
vim.keymap.set({'n', 'i'}, '<C-b>', function()
    vim.print(vim.fn.expand('%'))
    -- vim.print(vim.fn.expand('%:p'))     -- absolute path
    -- vim.print(vim.fn.expand('%:t'))     -- filename only
    -- vim.print(vim.fn.expand('%:h'))     -- path relative to working dir
    local buf_id = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(buf_id)
    local is_buf_modified = vim.api.nvim_buf_get_option(buf_id, 'modified')
    vim.print(buf_id, buf_name)
    vim.print(string.format('is_buf_modified=%s', is_buf_modified))
    vim.print(string.format('vim.bo.modified=%s', vim.bo.modified))
    vim.print(string.format('vim.bo[vim.api.nvim_get_current_buf()].modified=%s', vim.bo[vim.api.nvim_get_current_buf()].modified))
    vim.api.nvim_buf_call(0, function()
        print('Saving the file.')
        vim.cmd('w')
    end)
    local is_buf_modified = vim.api.nvim_buf_get_option(buf_id, 'modified')
    vim.print(string.format('is_buf_modified=%s', is_buf_modified))
    vim.print(string.format('vim.bo.modified=%s', vim.bo.modified))
    vim.print(string.format('vim.bo[vim.api.nvim_get_current_buf()].modified=%s', vim.bo[vim.api.nvim_get_current_buf()].modified))
end)
--]]


vim.keymap.set({'n', 'i'}, '<C-b>', function()
    vim.print(string.format('Current file: %s', vim.fn.expand('%')))
    local current_buf_id = vim.api.nvim_get_current_buf()
    if vim.bo[current_buf_id].modified then
        print('Buffer was modified. Saving contents.')
        vim.cmd('write')
        print(string.format('Is buffer still modified: %s', vim.bo[current_buf_id].modified))
    end
    -- vim.cmd('luafile %')    -- TODO: temp just to update the latest config. Remove later!
    local save_file_command = string.format('luafile %s', vim.api.nvim_buf_get_name(0))
    vim.cmd(save_file_command)    -- TODO: Temp just to update the latest config. Remove later!
    -- Won't render if buffer is not attached to a file. Neither will nvim.bo be populated.
    -- local file_name = vim.fn.expand('%')
    local file_name = vim.api.nvim_buf_get_name(0)
    vim.print(string.format('file_name=%s', file_name))
    vim.print(type(file_name))
    local file_extension = file_name ~= '' and file_name:match('^.+%.([^.]+)$') or nil
    vim.print(string.format('file_extension=%s', file_extension))
    vim.print(type(file_extension))
end)

