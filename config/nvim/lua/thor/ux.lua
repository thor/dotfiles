-- Select diagnostics gutter signs
local signs = {
  Error = "", Warn = "", Hint = "", Info = ""
}
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.INFO] = signs.Info,
      [vim.diagnostic.severity.HINT] = signs.Hint,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.ERROR] = signs.Error
    }
  }
})
