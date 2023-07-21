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

function M.is_terminal()
	-- Utility function used to enable or disable addons depending
	-- on whether we are running neovim in our terminal or from VS Code.
	return vim.g.vscode == nil
end

return M
