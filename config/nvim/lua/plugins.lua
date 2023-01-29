require('packer').startup(function(use)
	-- Packer itself
	use 'wbthomason/packer.nvim'

	use {'krivahtoo/silicon.nvim', run = './install.sh'}
	-- file enhancements and syntax fixes, nvim-specific
	use 'neovim/nvim-lspconfig' -- core lsp
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	-- file tree viewer with dev icons
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {{'kyazdani42/nvim-web-devicons', opt = true }}
	}
end)

require('silicon').setup({
  font = 'Fantasque Sans Mono=16',
  theme = 'Monokai Extended',
})
