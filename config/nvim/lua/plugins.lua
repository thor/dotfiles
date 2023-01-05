require('packer').startup(function(use)
	-- Packer itself
	use 'wbthomason/packer.nvim'

	use {'krivahtoo/silicon.nvim', run = './install.sh'}
	-- file enhancements and syntax fixes, nvim-specific
	use 'neovim/nvim-lspconfig' -- core lsp
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)

require('silicon').setup({
  font = 'Fantasque Sans Mono=16',
  theme = 'Monokai Extended',
})
