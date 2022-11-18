require('packer').startup(function(use)
	-- Packer itself
	use 'wbthomason/packer.nvim'

	use {'krivahtoo/silicon.nvim', run = './install.sh'}
end)

require('silicon').setup({
  font = 'Fantasque Sans Mono=16',
  theme = 'Monokai Extended',
})
