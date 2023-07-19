-- Configuration and mappings for VSCode

if not vim.g.vscode then
	return
end

-- vim-commentary-esque bindings
-- https://github.com/asvetliakov/vscode-neovim#vim-commentary
vim.keymap.set({'n', 'x', 'o'}, 'gc', '<Plug>VSCodeCommentary')
vim.keymap.set('n', 'gcc', '<Plug>VSCodeCommentaryLine')

vim.api.nvim_create_autocmd({'FileType'}, {
	pattern = 'tex',
	group = vim.api.nvim_create_augroup('vscode', { clear = true }),
	callback = function ()
		vim.keymap.set('n', 'k', 'gk', { buffer = true, silent = true })
		vim.keymap.set('n', 'j', 'gj', { buffer = true, silent = true })
	end,
})

