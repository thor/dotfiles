local utils = require "utils"

--------------------------------------------------------------------------------
-- Current plugin manager
return {
  -- interface-agnostic
  {
    'krivahtoo/silicon.nvim',
    build = './install.sh build',
    cond = false and utils.is_terminal,
    config = function()
      require 'silicon'.setup({
        font = 'Fantasque Sans Mono=16',
        theme = 'Monokai Extended',
      })
    end,
  },

  -- file tree viewer with dev icons
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = utils.is_terminal,
    config = function()
      require("sections/file-tree")
    end
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      -- provide icon support
      { 'nvim-tree/nvim-web-devicons' },
    },
    cond = utils.is_terminal,
    config = function()
      local paste = function()
        if not vim.o.paste then
          return ''
        end
        return 'ρ'
      end
      -- The map is built from my previous vim-airline mode map, but
      -- it is not complete. I honestly don't know what all the modes are,
      -- so I'll let future me look that up at some point.
      local mode_map = {
        COMMAND     = 'CMD',
        INSERT      = 'I',
        --ic = 'IC',
        --ix = 'Ic',
        NORMAL      = 'N',
        --ni = '(I)',
        --no = 'OP',
        REPLACE     = 'R',
        --Rv = 'RV',
        --s  = 'S',
        --S  = 'S-L',
        --[''] = 'S-B',
        TERMINAL    = 'T',
        VISUAL      = 'V',
        ['V-LINE']  = 'V-L',
        ['V-BLOCK'] = 'V-B',
      }
      -- the actual configuration
      require('lualine').setup {
        options = {
          theme = 'auto',
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function(str)
                if mode_map[str] then
                  return mode_map[str]
                end
                return str
              end
            },
            { paste },
          }
        },
        winbar = {
          lualine_a = {
            {
              'buffers',
              show_filename_only = false,
            },
          },
          lualine_z = { 'tabs' },
        }
      }
    end,
  },

  -- git primary helper
  {
    'tpope/vim-fugitive',
    cond = utils.is_terminal,
  },
  -- git diff view browser
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cond = utils.is_terminal,
  },

  -- terminal visuals
  {
    'echasnovski/mini.nvim',
    version = false,
    lazy = false,
    opts = {
      base16 = {
        -- default dark
        palette = {
          base00 = "#181818",
          base01 = "#282828",
          base02 = "#383838",
          base03 = "#585858",
          base04 = "#B8B8B8",
          base05 = "#D8d8d8",
          base06 = "#e8e8e8",
          base07 = "#f8f8f8",
          base08 = "#ab4642",
          base09 = "#dc9656",
          base0A = "#f7ca88",
          base0B = "#A1B56C",
          base0C = "#86c1b9",
          base0D = "#7cafc2",
          base0E = "#ba8baf",
          base0F = "#a16946"
        },
        use_cterm = true,
      },
    },
    config = function(_, opts)
      for key, value in pairs(opts) do
        require('mini.' .. key).setup(value)
      end
    end,
  },
}
