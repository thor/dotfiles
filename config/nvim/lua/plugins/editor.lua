return {
  {
    -- it's sneak, but better
    url = 'https://codeberg.org/andyg/leap.nvim',
    enabled = true,
    lazy = false,
    keys = {
      { "s",  '<Plug>(leap-forward)',     mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  '<Plug>(leap-backward)',    mode = { "n", "x", "o" }, desc = "Leap backward to", },
      { "gs", '<Plug>(leap-from-window)', mode = { "n", "x", "o" }, desc = "Leap from windows", },
    },
    opts = {},
  },
  -- simplified magic to align things
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function(_, opts)
      require('mini.align').setup(opts)
    end,
    keys = {
      { "ga", desc = "easily align", },
      { "gA", desc = "easily align with preview", }
    }
  },
  -- create beautiful screenshots of code
  {
    'krivahtoo/silicon.nvim',
    build = './install.sh',
    cond = true, -- disabled due to build problems
    config = function()
      require 'silicon'.setup({
        font = 'FantasqueSansMono Nerd Font=15',
        theme = 'Monokai Extended',
        line_number = true,
        pad_vert = 40,
        pad_horiz = 60,
      })
    end,
  },

}
