local utils = require "utils"

-- all the following plugins are limited to the terminal, and should not be loaded by
-- vscode or similar applications that utilise neovim
if not utils.is_terminal() then
  return {}
end

return {
  {
    -- help me be better at remembering my own keys
    "folke/which-key.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.nvim"
    },
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
  {
    -- show beautiful indentation lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    -- enhanced inputs and selection interfaces
    'stevearc/dressing.nvim',
    event = "VeryLazy",
    opts = {},
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "open git overview" },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end,                    desc = "Find files" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,                     desc = "Find help" },
      { "<leader>fs", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "Find symbol in workspace" },
      { "<leader>ft", function() require("telescope.builtin").treesitter() end,                    desc = "Find symbol from treesitter" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end,                   desc = "Find diagnostics" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end,                    desc = "Open Git status" },
    },
    opts = {
      defaults = {
        winblend = 1
      },
    },
    config = function(_, opts)
      require('telescope').setup { opts }
      require('telescope').load_extension('fzf')
    end
  },

  -- file tree viewer with dev icons
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
          disabled_filetypes = { "fzf", "NvimTree" },
          theme = 'base16',
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
        },
        inactive_winbar = {
          lualine_a = {
            {
              'buffers',
              show_filename_only = true,
            },
          },
        }
      }
    end,
  },

  -- git primary helper
  {
    'tpope/vim-fugitive',
  },
  -- git diff view browser
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- terminal visuals
  {
    'tinted-theming/base16-vim',
    config = function()
      vim.cmd [[colorscheme base16-default-dark]]
    end
  },

}
