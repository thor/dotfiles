return {
  {
    -- Writing enhancements, such as soft & hard breaks
    'preservim/vim-pencil',
    ft = { 'pandoc', 'markdown' },
    dependencies = {'nvim-lualine/lualine.nvim'},
    conf = function ()
      -- soft as default
      vim.g['pencil#wrapModeDefault'] = 'soft'
      -- two spaces after periods (--=one_space (def), 1=two_spaces)
      vim.g['pencil#joinspaces'] = 1
      -- no concealment (--=disable, 1=one char, 2=hide char, 3=hide all (def))
      vim.g['pencil#conceallevel'] = 2
      -- add to lualine
      local lualine = require('lualine').get_config()
      -- TODO: does table.insert *even* work with lualine like this?
      table.insert(lualine.sections.lualine_x, 1, '%{PencilMode()}')
    end,
  },
  {
    -- TODO: Consider moving sentence chopper to LaTeX dedicated configuration
    'Konfekt/vim-sentence-chopper',
    disabled = true,
  }
}
