return {
  {
    -- it's sneak, but better
    'ggandor/leap.nvim',
    enabled = true,
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      leap.add_repeat_mappings(',', ';', {
        relative_directions = true,
        modes = { 'n', 'x', 'o' },
      })
    end,
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
    build = './install.sh build',
    cond = false, -- disabled due to build problems
    config = function()
      require 'silicon'.setup({
        font = 'Fantasque Sans Mono=16',
        theme = 'Monokai Extended',
      })
    end,
  },

}
