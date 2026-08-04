-- jjui in a floating terminal, local plugin
local dir = vim.fn.expand("~/dev/thor/jjui.nvim")

return {
  {
    dir = dir,
    name = "jjui.nvim",
    cond = vim.uv.fs_stat(dir) ~= nil,
    -- the plugin maps <leader>jj itself once loaded
    keys = { { "<leader>jj", desc = "open jjui" } },
    cmd = "JJUI",
  },
}
