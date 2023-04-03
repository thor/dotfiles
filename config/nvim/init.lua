-- Relatively clean init.lua, nvim 0.8+ only supported
-- thor at roht dott no
-- vim: set et :
-------------------------------------------------------------------------------

-- Initialise Lua-based plugins with packer
require('plugins')

-------------------------------------------------------------------------------
-- Core vim configurations
-- - (d) neovim default

-- Buffer management & behaviour
vim.o.hidden = true                -- vim can remember buffers' contents when hidden
vim.o.undofile = true              -- actually enable the saving of history to the file


-- Windows
vim.o.clipboard = 'unnamedplus'

-- Syntax highlighting and folds
-- TODO: replace marker with expr and use treesitter
vim.o.foldmethod = 'marker'         -- Change from manual to marker for folding defaults

-- Spacing / tabs / code-style
vim.o.tabstop     = 2 -- " Visual space per TAB used!
vim.o.softtabstop = -1 -- " Spaces entered per TAB in editing.
vim.o.shiftwidth  = 2 -- " Using 8 is ridicilous.
vim.o.autoindent  = true -- " (d) Because automatic indentation is useful.
-- " Configure how listchars should appear.
vim.o.listchars   = table.concat({'tab:▸ ', 'eol:¬', 'trail:·', 'extends:#','nbsp:␣'}, ',')

if not vim.g.vscode then

-- User interface / elements / locations
vim.o.number         = true -- " Show line numbers in the left bar.
vim.o.relativenumber = true -- " Let the line numbers be relative to pos.
vim.o.cursorline     = true -- " Reveal the line I'm currently on.
vim.o.wildmenu       = true -- " (d) Show tab-complete line for :cmds.
-- FIXME: verify colorcolumn works
vim.o.colorcolumn    = '+1' -- " Shows textwidth-column +1, e.g. 79+1=80
vim.o.title          = true -- " Use terminal title
vim.o.cmdheight      = 0 -- " Hide the status line unless command prompt active

-- Themes
vim.o.background = 'dark' -- " Use the dark theme of whatever colorscheme.

end

vim.o.backspace     = 'indent,eol,start' -- " (d) Backspace beyond single lines.
vim.o.modeline      = true -- " Configure settings per file.
vim.o.mouse         = 'a' -- " (d) Mouse-support is actually really cool.
vim.o.incsearch     = true -- " (d) Incremental search view for /searches.
-- Use ag instead of grep
vim.o.grepprg       = 'rg -n $*'
-- Remove options from views
-- TODO: fix viewoptions
-- set viewoptions -= options
-- Double frequency of swap writes for vim-signify
vim.o.updatetime    = 2000

-- Email configuration
-- TODO: insert e-mail configuration
-- Add format option 'w' to add trailing white space, incl. 'a' for
-- auto-formatting. Used together with neomutts text_flowed-option.

-------------------------------------------------------------------------------
-- Load remaining legacy configuration
vim.cmd.source(vim.fn.expand('<sfile>:p:h') .. '/legacy.vim')

