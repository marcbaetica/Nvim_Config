-- https://neovim.io/doc/user/options.html
-- for more details :help options
-- full list at https://neovim.io/doc/user/quickref.html#option-list

-- NOTE: The font characteristics are defined at the terminal level.

local opt = vim.opt

opt.backup = false                          -- creates a backup file
opt.clipboard = 'unnamedplus'               -- allows neovim to access the system clipboard
opt.cmdheight = 2                           -- more space in the neovim command line for displaying messages
opt.completeopt = { 'menuone', 'noselect' } -- mostly just for cmp
opt.conceallevel = 0                        -- so that `` is visible in markdown files
opt.fileencoding = 'utf-8'                  -- the encoding written to a file
opt.hlsearch = true                         -- highlight all matches on previous search pattern
opt.ignorecase = true                       -- ignore case in search patterns
opt.mouse = 'a'                             -- allow the mouse to be used in neovim
opt.pumheight = 10                          -- pop up menu height
opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2                         -- always show tabs
opt.smartcase = true                        -- smart case
opt.smartindent = true                      -- make indenting smarter again
opt.splitbelow = true                       -- force all horizontal splits to go below current window
opt.splitright = true                       -- force all vertical splits to go to the right of current window
opt.swapfile = false                        -- creates a swapfile
-- opt.termguicolors = true                    -- set term gui colors (most terminals support this)
opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true                         -- enable persistent undo
opt.updatetime = 300                        -- faster completion (4000ms default)
opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.expandtab = true                        -- convert tabs to spaces
opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
opt.tabstop = 2                             -- insert 2 spaces for a tab
opt.cursorline = true                       -- highlight the current line
opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- hybrid line numbering (cursor line number with relative adjacent lines)
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = 'yes'                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- is one of my fav
vim.opt.sidescrolloff = 8
--vim.opt.guifont = 'monospace:h17"               -- the font used in graphical neovim applications
--vim.opt.guifont = "Jetbrains Mono:h17"               -- the font used in graphical neovim applications
vim.opt.guifont = {"Jetbrains Mono", "h17"}               -- the font used in graphical neovim applications

--vim.print(vim.opt.guifont)

--vim.opt.encoding = 'utf-8'
--vim.opt.font = ''
--fim.opt.fileencoding='utf-8'
--vim.opt.termencoding=utf-8
vim.opt.shortmess:append "c"

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work





