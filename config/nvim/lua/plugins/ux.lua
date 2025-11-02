local utils = require "utils"

-- all the following plugins are limited to the terminal, and should not be loaded by
-- vscode or similar applications that utilise neovim
if not utils.is_terminal() then
  return {}
end

local have_make = vim.fn.executable("make") == 1

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
    opts = {
      spec = {
        { "<leader>f", group = "find stuff" },
      },
    }
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
      input = {},
      picker = {}
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
        -- fix broken build due to CMake version lagging behind
        -- https://github.com/LazyVim/LazyVim/blob/12818a6cb499456f4903c5d8e68af43753ebc869/lua/lazyvim/plugins/extras/editor/telescope.lua#L65-L67
        build = have_make and "make" or
                'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release \z
                && cmake --build build --config Release \z
                && cmake --install build --prefix build',
        config = function() require("telescope").load_extension("fzf") end,
      },
      {
        'crispgm/telescope-heading.nvim',
        config = function() require("telescope").load_extension("heading") end,
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        -- install the latest stable version
        version = "*",
        config = function() require("telescope").load_extension("frecency") end,
      }
    },
    lazy = true,
    cmd = { "Telescope" },
    keys = function(_)
      local ts = function(fn) return function() vim.cmd("Telescope " .. fn) end end
      return {
        { "<C-P>",      ts("find_files theme=ivy"),   desc = "Find files (ivy)" },
        { "<leader>ff", ts("frecency workspace=CWD"), desc = "Find files" },
        { "<leader>fF", ts("find_files"),             desc = "Find files (no rank)" },
        { "<leader>fb", ts("buffers"),                desc = "Find buffers" },
        { "<leader>fg", ts("live_grep"),              desc = "Find by grep" },
        { "<leader>fh", ts("heading"),                desc = "Find heading" },
        { "<leader>fH", ts("help_tags"),              desc = "Find help" },
        { "<leader>fs", ts("lsp_workspace_symbols"),  desc = "Find symbol in workspace" },
        { "<leader>ft", ts("treesitter"),             desc = "Find symbol from treesitter" },
        { "<leader>fd", ts("diagnostics"),            desc = "Find diagnostics" },
        { "<leader>gs", ts("git_status"),             desc = "Open Git status" },
      }
    end,
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
            i = { ["Esc"] = actions.close }
          },
          layout_strategy = "flex",
          layout_config = {
            vertical = { width = 0.9 },
            horizontal = { width = 0.9 },
          },
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
        },
      }
      -- return vim.tbl_deep_extend('force', opts, options)
      return options
    end,
  },

  -- file tree viewer with dev icons
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { "<C-n>",      ":NvimTreeFindFileToggle<CR>", desc = "Toggle file in tree" },
      { "<leader>nT", ":NvimTreeToggle<CR>",         desc = "Toggle file tree" },
      { "<leader>nt", ":NvimTreeFindFile<CR>",       desc = "Show file in tree" },
      { "<leader>nr", ":NvimTreeRefresh<CR>",        desc = "Refresh files" }
    },
    -- Disable netrw
    init = function()
      vim.g.loaded_netrw       = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = function()
      -- give files without icons padding for readability
      vim.g.nvim_tree_icons = {
        default = " "
      }
      return {
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        git = {
          enable = true,
          ignore = true,
        },
      }
    end,
  },

  -- status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      -- provide icon support
      { 'nvim-tree/nvim-web-devicons' },
    },
    opts = function()
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
      return {
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
  -- jujutsu diffeditor
  {
    "julienvincent/hunk.nvim",
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = { "DiffEditor" },
    opts = {},
  },

  -- terminal visuals
  {
    'tinted-theming/base16-vim',
    lazy = false,
    config = function()
      vim.cmd [[colorscheme base16-default-dark]]
    end,
    priority = 1000
  },
  {
    'qpkorr/vim-bufkill',
    keys = {
      { "<leader>qq", "<cmd>:BD<cr>", desc = "delete the buffer" },
      { "<leader>qw", "<cmd>:BW<cr>", desc = "wipe the buffer" }
    },
    event = { "BufAdd", "BufNew", "BufDelete" },
  }
}
