local u = require 'utils'

require 'nvim-tree'.setup{
	disable_netrw = false,
	hijack_netrw = true,
	git = {
		enable = true,
		ignore = true,
	},
}

-- give files without icons padding for readability
vim.g.nvim_tree_icons = {
	default =  " "
}

u.map("n", "<C-n>", ":NvimTreeToggle<CR>")
u.map("n", "<localleader>n", ":NvimTreeToggle<CR>")
u.map("n", "<localleader>N", ":NvimTreeFindFileToggle<CR>")
u.map("n", "<localleader>r", ":NvimTreeRefresh<CR>")
