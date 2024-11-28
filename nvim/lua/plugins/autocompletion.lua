local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
            -- Other:
           -- require('luasnip').lsp_expand(args.body)
           -- require('snippy').expand_snippet(args.body)
           -- vim.fn["UltiSnips#Anon"](args.body)
           -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
     window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
     },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        -- Accept: true = currently selected item, false = only explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({  -- TODO: Add paths and other sources.
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        -- Other:
        -- { name = 'luasnip' },
        -- { name = 'ultisnips' },
        -- { name = 'snippy' },
    }, {
        { name = 'buffer' },
    }),
})
