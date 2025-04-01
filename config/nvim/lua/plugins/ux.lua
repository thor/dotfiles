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
    opts = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#6e171e" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#765517" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#0c497a" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#603d1d" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#3b5727" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#5a1b6d" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#1e4c52" })
      end)
      return { indent = { highlight = highlight } }
    end,
  },
  {
    -- enhanced inputs and selection interfaces
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      input = {}
    },
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
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    },
    cmd = { "Telescope" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end,            desc = "Find files" },
      { "<leader>fb", function() require("telescope.builtin").find_buffers() end,            desc = "Find buffers" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,             desc = "Find by grep" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,             desc = "Find help" },
      { "<leader>fs", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Find symbol in workspace" },
      { "<leader>ft", function() require("telescope.builtin").treesitter() end,            desc = "Find symbol from treesitter" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end,           desc = "Find diagnostics" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end,            desc = "Open Git status" },
    },
    opts = function(_, opts)
      local defaultConfig = require("telescope.config")

      -- fetch the default Telescope configuration
      local vimgrep_arguments = { unpack(defaultConfig.values.vimgrep_arguments) }
      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--hidden")
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")

      local actions = require('telescope.actions')
      local options = {
        defaults = {
          -- `hidden = true` is not supported in text grep commands.
          vimgrep_arguments = vimgrep_arguments,
          winblend = 1,
          -- close on escape
          mappings = {
            i = {
              ["esc"] = actions.close
            }
          }
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                -- remove buffers by using c-d
                ["<c-d>"] = actions.delete_buffer + actions.move_to_top
              }
            }
          },

          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        }
      }
      -- return vim.tbl_deep_extend('force', opts, options)
      return options
    end,
    config = function(_, opts)
      require('telescope').setup(opts)
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
    end,
    priority = 1000
  },

}
