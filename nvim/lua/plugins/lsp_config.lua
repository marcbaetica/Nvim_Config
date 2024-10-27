require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('mason-lspconfig').setup({
    ensure_installed = { 'pyright' }
})

local on_attach = function(_, _)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    -- <CTRL-o> -> what does it do
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, {})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    -- vim.lsp.buf.definition doesn't seem to work: method textDocument/implementation is not supported by any of the
    --                                              servers registered for the current buffer.
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
    --vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_reference, {})     -- Causes error on attach.
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

require('lspconfig').pyright.setup({
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    filetypes = {'python'},
})


-- This is the same as above:
-- config = require('lspconfig').pyright.config_def
--
-- require('lspconfig').pyright.setup({
--     on_attach = config.on_attach,
--     capabilities = config.capabilities,
--     filetypes = {'python'},
-- })


-- TODO: perhaps merge this with on_attach standalone definition or get that in the autocmd to remap dynamically.
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        print('Test!')
         --Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = {buffer = ev.buf}
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-q>', vim.lsp.buf.signature_help, opts)
        -- vim.keymap
        --     .set('n', '<Leader>sa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<Leader>sr', vim.lsp.buf.remove_workspace_folder,
        --                opts)
        -- vim.keymap.set('n', '<Leader>sl', function()
        --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, opts)
        vim.keymap.set({'n', 'v'}, '<Leader>la', vim.lsp.buf.code_action, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>lf',
                       function() vim.lsp.buf.format {async = true} end, opts)
    end
})
