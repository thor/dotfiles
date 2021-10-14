" LSP client configurations
lua << EOF
require'lspconfig'.terraformls.setup{
	cmd = { "terraform-ls", "serve" }
}
require'lspconfig'.tsserver.setup{}
require'trouble'.setup{}
EOF
