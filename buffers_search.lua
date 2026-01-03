local buffers = vim.api.nvim_list_bufs()
print(buffers)
-- for k, v in pairs(buffers) do
    -- print(k, v)
-- end
print('buf, buf_type, buf_loaded, buf_name')
for _, buf in ipairs(buffers) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
    local buf_loaded = vim.api.nvim_buf_is_loaded(buf)
    print(buf, buf_type, buf_loaded, buf_name)
    if buf_type == 'terminal' then
        print('This is a terminal!')
    end
end

