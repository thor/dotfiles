local utils = require "utils"
return {
  {
    'junegunn/fzf',
    cond = utils.is_terminal,
  },
  -- vim-integration for fuzzy file finder
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    cond = utils.is_terminal,
    config = function()
      -- Set the default fzf_layout
      vim.g.fzf_layout = { down = '~40%' }
      -- Dynamically move preview window up if the terminal is small
      vim.g.fzf_preview_window = { 'right,50%,<40(up,40%)', 'ctrl-/' }
      -- No customisation of Files command is necessary, but this is what it could look like
      --vim.api.nvim_create_user_command('Files',
      --  function(opts)
      --    vim.fn['fzf#vim#files'](opts.fargs[1], vim.fn['fzf#vim#with_preview'](), opts.bang)
      --  end,
      --  { nargs = '?', complete = 'dir', bang = true }
      --)
    end,
    keys = {
      { "<C-P>",      "<cmd>Files<CR>",   desc = "Open the file picker" },
      { "<leader>ph", "<cmd>Files ~<cr>", desc = "Open from $HOME" },
      { "<leader>pb", "<cmd>Buffers<cr>", desc = "Open the buffer picker" },
      { "<leader>pg", "<cmd>Rg<cr>",      desc = "Grep through files" },
      -- FIXME: Move the citation picker to the tex specific plugin configuration
      -- { "<leader>pc", "<cmd>vim.fn['vimtex#fzf#run']('cl', g:fzf_layout)<cr>", desc = "Open citation picker" },
      -- { "<leader>pt", "<cmd>vim.fn['vimtex#fzf#run']('t', g:fzf_layout)<cr>", desc = "Open cross reference picker?" },
    },
  },
}

-- TODO: Set FZF_BIBTEX_CACHEDIR in the tex plugin configuration
---let $FZF_BIBTEX_CACHEDIR = '/tmp/'
---
---function! Bibtex_ls()
---  let bibfiles = (
---      \ globpath('.', '*.bib', v:true, v:true) +
---      \ globpath('..', '*.bib', v:true, v:true) +
---      \ globpath('*/', '*.bib', v:true, v:true)
---      \ )
---  let bibfiles = join(bibfiles, ' ')
---  let source_cmd = 'bibtex-ls '.bibfiles
---  return source_cmd
---endfunction
---
---function! s:bibtex_cite_sink_insert(lines)
---    let r=system("bibtex-cite ", a:lines)
---    execute ':normal! a' . r
---    call feedkeys('a', 'n')
---endfunction
---
---inoremap <silent> @@ <c-g>u<c-o>:call fzf#run({
---			\ 'source': Bibtex_ls(),
---			\ 'sink*': function('<sid>bibtex_cite_sink_insert'),
---			\ 'down': '25%',
---			\ 'options': [
---				\ '--layout=reverse-list',
---				\ '--multi',
---				\ '--prompt',
---				\ '"Cite> "'
---			\ ]})<CR>
