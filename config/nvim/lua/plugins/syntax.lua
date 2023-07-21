-- Syntax files aren't provided for non-TUI
-- TODO: Consider if it should be
local utils = require "utils"

local plugins = {
  {
    -- Go-go-go-go
    -- TODO: Consider deleting in favour of ray-x/go.nvim
    -- TODO: add GoUpdateBinaries if I keep vim-go
    'fatih/vim-go',
    disabled = true,
  },
  {
    -- Go-go-go-go neovim!
    'ray-x/go.nvim',
    disabled = true,
  },
  {
    -- PlantUML
    'aklt/plantuml-syntax',
  },
  {
    -- Terraform
    'hashivim/vim-terraform',
    ft = 'terraform',
    conf = function ()
      -- Aligning automatically
      vim.g.terraform_align = 1
      -- Foldin' 's pretty cool too
      vim.g.terraform_fold_sections = 1
      -- Automatically apply fmt on save
      -- TODO: Replace automatical apply of fmt on save with LSP functionality
      vim.g.terraform_fmt_on_save = 1
    end,
  },
  {
    -- Pandoc (Markdown superset)
    'vim-pandoc/vim-pandoc-syntax',
    ft = 'pandoc',
    dependencies = {
      {
        'vim-pandoc/vim-pandoc',
        conf = function ()
          -- Configuring vim-pandoc (not syntax)
          vim.cmd[[runtime! sections/pandoc.vim]]
        end,
      },
    },
    keys = {
      { "<leader>pw",  "<C-U>call <SID>pandocOnWrite()<CR>", desc = "Enable Pandoc render on write" },
      { "<leader>pS",  ":<C-U>call <SID>pandocSoft()<CR>", desc = "Enable Pandoc soft-mode" },
    },
  },
  {
    -- Rust
    -- TODO: Update Rust with relevant LSP configuration
    'rust-lang/rust.vim',
    ft = 'rust',
  },
  {
    -- systemd unit files syntax
    'Matt-Deacalion/vim-systemd-syntax',
  },
  {
    -- Simplified YAML syntax for speed increases
    -- TODO: Consider removing yaml plugin in lieu of yaml-companion or LSP
    'stephpy/vim-yaml',
    ft = 'yaml',
  }
}

for i, _ in ipairs(plugins) do
  plugins[i].cond = utils.is_terminal
  plugins[i].lazy = true
end

return plugins
