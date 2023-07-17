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
  },
  {
    -- Distraction free writing
    'junegunn/goyo.vim',
    -- TODO: Consider removing goyo or fixing the issue with the status lines
    disabled = true,
    -- Map key for distraction free writing mode
    keys = {{ "<F11>", ":Goyo<cr>" }},
    conf = function ()
      -- Turning on and off syntax to fix issues with italics and bold
      -- https://github.com/junegunn/goyo.vim/issues/156
      vim.api.nvim_create_autocmd({"GoyoLeave"}, {
        group = vim.api.nvim_create_augroup("goyo", { clear = true }),
        callback = function ()
          local previous_syntax = vim.opt.syntax
          vim.cmd[[syntax off]]
          vim.cmd[[syntax on]]
          vim.opt.syntax = previous_syntax
        end,
      })
    end,
  },
  {
    -- Hyper-focused writing in vim
    'junegunn/limelight.vim',
    cond = is_terminal,
  },
}
