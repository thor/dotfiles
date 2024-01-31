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
      { 'RRethy/nvim-base16' },
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
  ---- Provide nvim-base16 to lualine
  -- TODO: remove base16 setups and possibly replace with mini.base16
  {
    'RRethy/nvim-base16',
    lazy = false,
    enabled = true,
    config = function()
      vim.cmd [[colorscheme base16-default-dark]]
      vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
        group = vim.api.nvim_create_augroup('colorscheme', { clear = true }),
        callback = function()
          -- Colour the line numbers a bit brighter to add contrast
          vim.cmd('highlight LineNr ctermbg=17')
          -- Colours the textwidth bar.
          vim.cmd('highlight ColorColumn ctermbg=18')
          -- Colours the cursor line, because I like it.
          vim.cmd('highlight CursorLine ctermbg=18')
          -- Remove background colour from spelling notices
          vim.cmd('highlight SpellCap ctermbg=NONE')
          -- Remove background colour from spelling errors
          vim.cmd('highlight SpellBad ctermbg=NONE')
        end
      })
    end
  },
}
