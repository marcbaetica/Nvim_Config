-- MASON

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
    ensure_installed = { 'pyright', 'rust_analyzer' }
})

-- TODO: Continue review after this point!


-- LSPs

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

require'lspconfig'.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}

--require('lspconfig').rust_analyzer.setup({
--    on_attach = on_attach,
--    capabilities = require('cmp_nvim_lsp').default_capabilities(),
--    filetypes = {'rust'},
--})

--require('lspconfig').rust_analyzer.setup({
--    on_attach = on_attach,
--    capabilities = require('cmp_nvim_lsp').default_capabilities(),
--    root_dir = function()
--        return vim.fn.getcwd()
--    end,
--    cmd = { "rustup", "run", "stable", "rust-analyzer" },
--    settings = {
--        rust_analyzer = {
--            useLibraryCodeForTypes = true,
--            autoSearchPaths = true,
--            autoImportCompletions = false,
--            reportMissingImports = true,
--            followImportForHints = true,
--
--            cargo = {
--                allFeatures = true,
--            },
--            checkOnSave = {
--                command = "cargo clippy",
--            },
--        },
--    },
--})

--require'lspconfig'.rust_analyzer.setup{
--    settings = {
--        ['rust-analyzer'] = {
--            diagnostics = {
--                enable = false;
--            }
--        }
--    }
--}

--require('lspconfig').rust_analyzer.setup {
--  settings = {
--    ["rust-analyzer"] = {
--      workspace = {
--        symbol = {
--          search = {
--            kind = "all_symbols"
--          }
--        }
--      }
--    },
--  }
--}


--require('lspconfig').rust_analyzer.setup({
--    on_attach = on_attach,
--    capabilities = capabilities,
--    root_dir = function()
--        return vim.fn.getcwd()
--    end,
--    --cmd = { "rustup", "run", "stable", "rust-analyzer" },
--    settings = {
--        rust_analyzer = {
--            useLibraryCodeForTypes = true,
--            autoSearchPaths = true,
--            autoImportCompletions = false,
--            reportMissingImports = true,
--            followImportForHints = true,
--
--            cargo = {
--                allFeatures = true,
--            },
--            checkOnSave = {
--                command = "cargo clippy",
--            },
--        },
--    },
--})






--require('nvim-autopairs').setup({
--  -- disable_filetype = { "TelescopePrompt" , "vim" },
--})

-- SETUP: https://github.com/windwp/nvim-autopairs?tab=readme-ov-file#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)


-- RUST

--require'lspconfig'.rust_analyzer.setup {
--    settings = {
--        ['rust-analyzer'] = {
--            check = {
--                command = "clippy";
--            },
--            diagnostics = {
--                enable = true;
--            }
--        }
--    }
--}


--require'cmp'.setup({
--  snippet = {
--    expand = function(args)
--         vim.fn["vsnip#anonymous"](args.body)
--    end,
--  },
--  sources =  {
--    { name = 'nvim_lsp' },
--    { name = 'vsnip' },
--    { name = 'path' },
--    { name = 'buffer' },
--  },
--})

-- / RUST



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
