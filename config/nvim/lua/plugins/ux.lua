return {
  {
    -- help me be better at remembering my own keys
    "folke/which-key.nvim",
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
  }
}
