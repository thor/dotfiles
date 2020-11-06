" LSP client configurations
lua << EOF
require'nvim_lsp'.terraformls.setup{
	cmd = { "terraform-ls", "serve" }
}
EOF
