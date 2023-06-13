--------------------------------------------------------------------------------
-- Helper functions for controlling plugins
function is_terminal()
  -- Utility function used to enable or disable addons depending
  -- on whether we are running neovim in our terminal or from VS Code.
  return vim.g.vscode == nil
end

--------------------------------------------------------------------------------
-- Current plugin manager
return {
  -- interface-agnostic
  {
    'krivahtoo/silicon.nvim', 
    build = './install.sh build',
		cond = false and is_terminal,
    config = function()
      require'silicon'.setup({
        font = 'Fantasque Sans Mono=16',
        theme = 'Monokai Extended',
			})
    end,
  },

  -- file enhancements and syntax fixes, nvim-specific, LSP
  --- core lsp
  { 'neovim/nvim-lspconfig', lazy = true },
  --- Colours for LSP
  {'folke/lsp-colors.nvim', lazy = true, cond = is_terminal },
  --- LSP error overview in the terminal
  {
    'folke/trouble.nvim',
    lazy = true,
    cond = is_terminal,
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function() 
      -- Configuring LSP client configurations
      -- TODO: Move to a better location, or make the plugin spec part of it?
      require('sections/lsp')
    end,
  },

  ---- enhanced highlighting, incl. additional treesitter context
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cond = is_terminal,
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        ensure_installed = { "bash", "lua", "rust", "vim", "go", "python" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        highlight = {
          -- `false` will disable the whole extension
          enable = true,
        }
      }
    end
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = is_terminal,
    config = function()
      require('treesitter-context').setup {
        -- Use the highlight group TreesitterContext to change the colors of the
        -- context. Per default it links to NormalFloat. Use the highlight group
        -- TreesitterContextLineNumber to change the colors of the context line
        -- numbers if line_numbers is set. Per default it links to LineNr. Use the
        -- highlight group TreesitterContextBottom to change the highlight of the
        -- last line of
        -- the context window. By default it links to NONE. 
        --
        -- However, you can use this to create a border by applying an underline
        -- highlight, e.g:
        -- 
        -- hi TreesitterContextBottom gui=underline guisp=Grey
        enable = true, 
      }
    end
  },

  -- file tree viewer with dev icons
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    cond = is_terminal,
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
    cond = is_terminal,
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
         COMMAND  = 'CMD',
         INSERT  = 'I',
         --ic = 'IC',
         --ix = 'Ic',
         NORMAL  = 'N',
         --ni = '(I)',
         --no = 'OP',
         REPLACE  = 'R',
         --Rv = 'RV',
         --s  = 'S',
         --S  = 'S-L',
         --[''] = 'S-B',
         TERMINAL  = 'T',
         VISUAL  = 'V',
         ['V-LINE']  = 'V-L',
         ['V-BLOCK'] = 'V-B',
      }
      -- the actual configuration
      require('lualine').setup{
        sections = {
          lualine_a = {
            { 
              'mode',
              fmt = function (str)
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
          lualine_a = { 'buffers' },
          lualine_z = { 'tabs' },
        }
      }
    end,
  },

  -- git diff view browser
  {
    'sindrets/diffview.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    cond = is_terminal,
  },

  -- terminal visuals
  ---- Provide nvim-base16 to lualine
  { 'RRethy/nvim-base16', lazy = true },

  {
    'chriskempson/base16-vim',
    dependencies = {'nvim-base16', 'RRethy/nvim-base16'},
    cond = is_terminal(),
    priority = 1000, -- load as soon as possible
    config = function()
      -- Use 256 colors for the theme
      vim.g.base16colorspace = 256
      vim.cmd('colorscheme base16-default-dark')
      vim.api.nvim_create_autocmd({'ColorScheme'}, {
        group = vim.api.nvim_create_augroup('colorscheme', { clear = true }),
        colorgroup,
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
    end,
  },
}

