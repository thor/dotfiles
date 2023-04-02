require('packer').startup(function(use)
	-- Packer itself
	use 'wbthomason/packer.nvim'

	-- interface-agnostic
	use {
		'krivahtoo/silicon.nvim', 
		run = './install.sh',
		config = function() require('silicon').setup({
			font = 'Fantasque Sans Mono=16',
			theme = 'Monokai Extended',
		}) 
		end
	}

	-- file enhancements and syntax fixes, nvim-specific
	---- core lsp
	use 'neovim/nvim-lspconfig'
	---- enhanced highlighting, incl. additional treesitter context
	use { 'nvim-treesitter/nvim-treesitter', 
		run = ':TSUpdate',
		config = function() 
			require'nvim-treesitter.configs'.setup {
				-- A list of parser names, or "all"
				ensure_installed = { "bash", "lua", "rust", "vim", "go", "python" },

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				highlight = {
					-- `false` will disable the whole extension
					enable = true,
				}
			}
		end
	} 
	use {
		'nvim-treesitter/nvim-treesitter-context',
		after = 'nvim-treesitter/nvim-treesitter',
		config = function() 
			require'treesitter-context'.setup {
				-- Use the highlight group TreesitterContext to change the colors of the
				-- context. Per default it links to NormalFloat. Use the highlight group
				-- TreesitterContextLineNumber to change the colors of the context line
				-- numbers if line_numbers is set. Per default it links to LineNr. Use the
				-- highlight group TreesitterContextBottom to change the highlight of the
				-- last line of
				-- the context window. By default it links to NONE. 
				--
				-- However, you can use this to create a border by applying an underline
				-- highlight, e.g:
				-- 
				-- hi TreesitterContextBottom gui=underline guisp=Grey
				enable = true, 
			}
		end
	}


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
