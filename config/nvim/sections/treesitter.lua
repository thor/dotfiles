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
