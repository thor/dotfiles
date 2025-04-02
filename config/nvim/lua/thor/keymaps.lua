-- Set mapleader to be space, convenient
vim.g.mapleader = " "
-- Set local leader to be the backspace, somewhat convenient
vim.g.localleader = "\\"

-- Make splits easier to deal with
vim.o.splitbelow = true
vim.o.splitright = true
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { noremap = true })


-- Navigate around buffers with just tab and shift-tab
vim.keymap.set('n', '<Tab>', ':bn<cr>', { noremap = true })
vim.keymap.set('n', '<S-Tab>', ':bp<cr>', { noremap = true })


-- Centre my location after moving up and down
vim.keymap.set('n', 'j', 'jzz', { noremap = true })
vim.keymap.set('n', 'k', 'kzz', { noremap = true })

-- Syntax debugging
-- TODO: Convert this line for the syntax debugging
-- map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
-- \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
-- \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

-- Global LSP client configurations
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)


-- Stop processing settings not relevant for e.g. VSCode
local utils = require("utils")
if not utils.is_terminal() then
  return
end


-- Helpful mappings
local mappings = {
  -- Group definitions
  { "<leader>s",  group = "spelling" },
  { "<leader>sw", "<cmd>set list!<cr>",      desc = "show whitespace symbols" },
  { "<leader>sc", "ea<C-X><C-S>",            desc = "spell check" },
  { "<leader>p",  group = "peek-a-boo" },
  { "<leader>c",  group = "code" },
  { "<leader>ce", vim.diagnostic.open_float, desc = "open diagnostics float" },
  { "<leader>cq", vim.diagnostic.setloclist, desc = "set location list(?)" },
  { "<leader>x",  group = "diagnostics" },
}

-- Setup friendly keymaps for myself with which-key
local wk = require("which-key")
wk.add(mappings)
