-- Select diagnostics gutter signs
-- TODO: Consider choosing between one of the infos or others
local signs = {
  Error = "", Warn = "", Hint = "", Info = "", Other = ""
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
