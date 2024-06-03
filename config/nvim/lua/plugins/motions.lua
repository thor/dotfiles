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
    lazy = false,
    conf = function(_, opts)
      local leap = require('leap')
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      --leap.add_repeat_mappings(';', ',', {
      --  relative_directions = true,
      --  modes = {'n', 'x', 'o'},
      --})
    end
  }
}
