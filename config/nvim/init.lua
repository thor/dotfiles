-- Relatively clean init.lua, nvim 0.8+ only supported
-- thor at roht dott no
-- vim: set et :
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Core vim configurations
-- - (d) neovim default

-- Buffer management & behaviour
vim.o.hidden = true   -- vim can remember buffers' contents when hidden
vim.o.undofile = true -- actually enable the saving of history to the file


-- Windows
vim.o.clipboard    = 'unnamedplus'

-- Syntax highlighting and folds
vim.o.foldmethod   = "expr"
vim.o.foldexpr     = "nvim_treesitter#foldexpr()"
vim.o.foldtext     =
[[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
vim.o.foldnestmax  = 3
vim.o.foldminlines = 1

-- Spacing / tabs / code-style
vim.o.expandtab    = true -- " spaces over tabs, sorry mac
vim.o.tabstop      = 2    -- " Visual space per TAB used!
vim.o.softtabstop  = -1   -- " Spaces entered per TAB in editing.
vim.o.shiftwidth   = 2    -- " Using 8 is ridicilous.
vim.o.autoindent   = true -- " (d) Because automatic indentation is useful.
---- Configure how listchars should appear.
vim.opt.listchars  = { tab = '▸ ', eol = '¬', trail = '·', lead = '·', extends = '#', nbsp = '␣' }

if not vim.g.vscode then
  -- User interface / elements / locations
  vim.o.number         = true -- " Show line numbers in the left bar.
  vim.o.relativenumber = true -- " Let the line numbers be relative to pos.
  vim.o.cursorline     = true -- " Reveal the line I'm currently on.
  vim.o.wildmenu       = true -- " (d) Show tab-complete line for :cmds.
  vim.o.colorcolumn    = '+1' -- " Shows textwidth-column +1, e.g. 79+1=80
  vim.o.title          = true -- " Use terminal title
  vim.o.cmdheight      = 0    -- " Hide the status line unless command prompt active

  -- Themes
  vim.o.background     = 'dark' -- " Use the dark theme of whatever colorscheme.
  vim.o.termguicolors  = true   -- " Use all the terminal GUI colours (256+)
end

vim.opt.backspace = { 'indent', 'eol', 'start' }   -- " (d) Backspace beyond single lines.
vim.o.modeline    = true                           -- " Configure settings per file.
vim.o.mouse       = 'a'                            -- " (d) Mouse-support is actually really cool.
vim.o.incsearch   = true                           -- " (d) Incremental search view for /searches.
-- Use ag instead of grep
vim.o.grepprg     = 'rg -n $*'
-- Double frequency of swap writes for vim-signify
vim.o.updatetime  = 2000

-- Set mapleader to be space, convenient
vim.g.mapleader   = " "
-- Set local leader to be the backspace, somewhat convenient
vim.g.localleader = "\\"


-- Get the guicursor of my dreams
vim.o.guicursor = vim.o.guicursor .. ",a:blinkwait175-blinkoff100-blinkon170"

-- Restore it after exiting
vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    vim.o.guicursor = "a:hor100-blinkon1"
  end
})

-------------------------------------------------------------------------------
-- Bootstrap the package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Initialise Lua-based plugins with lazy
require('lazy').setup("plugins")

-------------------------------------------------------------------------------
-- Load keyboard mappings, and whatever else of my settings that aren't plugins
require 'thor.keymaps'
require 'thor.commands'
require 'thor.ux'

-- Load VSCode
require 'thor.vscode'
