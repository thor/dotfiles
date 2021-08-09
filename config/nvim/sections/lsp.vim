" LSP client configurations
lua << EOF
require'lspconfig'.terraformls.setup{
	cmd = { "terraform-ls", "serve" }
}
EOF
