require('packer').startup(function(use)
	-- Packer itself
	use 'wbthomason/packer.nvim'

	use {'krivahtoo/silicon.nvim', run = './install.sh'}
	-- file enhancements and syntax fixes, nvim-specific
	---- core lsp
	use 'neovim/nvim-lspconfig'
	---- enhanced highlighting, incl. additional treesitter context
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } 
	use 'nvim-treesitter/nvim-treesitter-context'

	-- file tree viewer with dev icons
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {{'kyazdani42/nvim-web-devicons', opt = true }}
	}

	-- git diff view browser
	use {
		'sindrets/diffview.nvim',
		requires = {{'nvim-lua/plenary.nvim'}}
	}
end)

require('silicon').setup({
  font = 'Fantasque Sans Mono=16',
  theme = 'Monokai Extended',
})
