local M = {}

function M.t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.map(mode, lhs, rhs, opts)
	-- Wrapper for creating keymaps with my preferred defaults
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return M
