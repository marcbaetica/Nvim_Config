-- Syntax parsers
{
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    opts = {...}
},

-- opts = {...}, here is esentially the equivalent of the force enabling later: require('nvim-treesitter.configs').setup {...},
-- table of options plugin configuration data. It’s passed to the plugin’s setup function, if you also have a config = function(_, opts) ... end that calls setup(opts).
-- [[
-- options table, plugin options, setup arguments
-- It’s a declarative way of telling the plugin how to behave, without immediately running code.
-- opts → just data / configuration values
-- config → actual code that runs after the plugin loads
-- ]]




-- ~/.config/nvim/lua/plugins/treesitter.lua
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua', 'python', 'vim', 'json', 'bash' },
    highlight = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = { init_selection = '<CR>', node_incremental = '<CR>', node_decremental = '<BS>' },
    },
}

-- Is the same as:

-- ~/.config/nvim/lua/config/treesitter_opts.lua
local opts = {
    ensure_installed = { 'lua', 'python', 'vim', 'json', 'bash' },
    highlight = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = { init_selection = '<CR>', node_incremental = '<CR>', node_decremental = '<BS>' },
    },
}

return opts


-- Then in your Lazy.nvim plugin spec:
{
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup(require('config.treesitter_opts'))
    end,
},





require("nvim-treesitter.configs").setup {
  playground = {
    enable = true,
  },
}

--[[ “force-enables”:
You are explicitly enabling the Playground module via the setup function, overriding its default (which is disabled).
So in technical terms, this is called:
“explicit configuration via setup”
or more casually:
Explicit enablement — you are telling the plugin, “I want this feature on, no matter what the default is.”
It forces the feature to be active if the plugin loads and the parser is available.
--]]

--[[
Breaking it down:
require("nvim-treesitter.configs") → load the module
.setup{ ... } → configure the plugin with the options you provide
playground = { enable = true } → explicitly turns on Playground, instead of leaving it off (default)
✅ That’s why I said earlier: “force-enables” — it’s literally overriding the default disabled state.
-- ]]



--[[
Ah! Now I see exactly what you mean — you’re asking:  

> In Lazy.nvim, when you do `opts = { ... }` in a plugin spec, what is that conceptually called?  

Let me explain clearly.  

---

## 1️⃣ In Lazy.nvim

Example:

```lua
{
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {
      highlight = { enable = true },
      incremental_selection = { enable = true },
  },
}
```

Here:

- `opts` is **a table of options**  
- It’s **passed to the plugin’s setup function**, if you also have a `config = function(_, opts) ... end` that calls `setup(opts)`  
- It’s basically **“plugin configuration data”**  

---

## 2️⃣ Terminology

In Lazy.nvim documentation, `opts` is called:

- **Options table**  
- **Plugin options**  
- **Setup arguments**  

Conceptually:  

> It’s a **declarative way of telling the plugin how to behave**, without immediately running code.  

You can think of it as **data that will later be consumed by the setup function**.

---

### 3️⃣ Difference from `config = function() ... end`

- `opts` → just **data / configuration values**  
- `config` → **actual code that runs** after the plugin loads  

You can combine them like this:

```lua
{
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  opts = {
    highlight = { enable = true },
    incremental_selection = { enable = true },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
```

- `opts` holds the **settings**  
- `config` is the **setup function** that applies those settings  

---

### 4️⃣ TL;DR

- **`opts`** = **plugin options table** (data describing how the plugin should behave)  
- **`config`** = **code that actually sets up the plugin**  
- Using `opts` alone in Lazy.nvim **does nothing unless you run it in `config`**  

---

If you want, I can draw a **tiny diagram showing how `opts` flows into `setup()` via `config()`**, so you’ll see the difference between `opts` and `require().setup()`.  

Do you want me to do that?
-- ]]
