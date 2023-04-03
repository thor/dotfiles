function is_terminal()
	-- Utility function used to enable or disable addons depending
	-- on whether we are running neovim in our terminal or from VS Code.
	return vim.g.vscode == nil
end

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
		requires = { 'nvim-treesitter/nvim-treesitter' },
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
		requires = {{'kyazdani42/nvim-web-devicons'}},
		cond = is_terminal()
	}

	-- status line
	use {
		'nvim-lualine/lualine.nvim',
		requires = {
			-- provide icon support
			{ 'kyazdani42/nvim-web-devicons', opt = true },
			{ 'RRethy/nvim-base16' },
		},
		config = function()
			local paste = function() 
				if not vim.o.paste then 
					return ''
				end
				return 'ρ' 
			end
			-- The map is built from my previous vim-airline mode map, but
			-- it is not complete. I honestly don't know what all the modes are,
			-- so I'll let future me look that up at some point.
			local mode_map = {
				 COMMAND  = 'CMD',
				 INSERT  = 'I',
				 --ic = 'IC',
				 --ix = 'Ic',
				 NORMAL  = 'N',
				 --ni = '(I)',
				 --no = 'OP',
				 REPLACE  = 'R',
				 --Rv = 'RV',
				 --s  = 'S',
				 --S  = 'S-L',
				 --[''] = 'S-B',
				 TERMINAL  = 'T',
				 VISUAL  = 'V',
				 ['V-LINE']  = 'V-L',
				 ['V-BLOCK'] = 'V-B',
			}
			-- the actual configuration
			require('lualine').setup{
				sections = {
					lualine_a = {
						{ 
							'mode',
							fmt = function (str)
								if mode_map[str] then
									return mode_map[str]
								end
								return str
							end
						},
						{ paste },
					}
				},
				winbar = {
					lualine_a = { 'buffers' },
					lualine_z = { 'tabs' },
				}
			}
		end,
		cond = is_terminal()
	}

	-- git diff view browser
	use {
		'sindrets/diffview.nvim',
		requires = {{'nvim-lua/plenary.nvim'}},
		cond = is_terminal(),
	}

	-- terminal visuals
	---- Provide nvim-base16 to lualine
	use { 
		'RRethy/nvim-base16',
		config = function()
			vim.cmd('colorscheme base16-default-dark')
		end,
		cond = is_terminal(),
	}

	use { 
		'chriskempson/base16-vim',
		after = 'nvim-base16',
		config = function()
			-- Use 256 colors for the theme
			vim.g.base16colorspace = 256
			vim.cmd('colorscheme base16-default-dark')
			vim.api.nvim_create_autocmd({'ColorScheme'}, {
				group = vim.api.nvim_create_augroup('colorscheme', { clear = true }),
				colorgroup,
				callback = function() 
					-- Colour the line numbers a bit brighter to add contrast
					vim.cmd('highlight LineNr ctermbg=17')
					-- Colours the textwidth bar.
					vim.cmd('highlight ColorColumn ctermbg=18')
					-- Colours the cursor line, because I like it.
					vim.cmd('highlight CursorLine ctermbg=18')
					-- Remove background colour from spelling notices
					vim.cmd('highlight SpellCap ctermbg=NONE')
					-- Remove background colour from spelling errors
					vim.cmd('highlight SpellBad ctermbg=NONE')
				end
			})
		end,
		cond = is_terminal()
	}

end)
