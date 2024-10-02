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
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Find help" },
      { "<leader>fs", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,  desc = "Find symbol in workspace" },
      { "<leader>ft", function() require("telescope.builtin").treesitter() end,  desc = "Find symbol from treesitter" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end,  desc = "Find diagnostics" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end,  desc = "Open Git status" },
    },
    opts = {
      defaults = {
        winblend = 1
      },
    },
    config = function (_, opts)
      require('telescope').setup{opts}
      require('telescope').load_extension('fzf')
    end
  },
}
