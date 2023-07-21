-- TeX related plugins
local utils = require "utils"
return {
  -- LaTeX editing & completion and all
  -- NOTE: Temporarily disabled while I contemplate how often I use TeX these days
  {
    'lervag/vimtex',
    cond = false and utils.is_terminal,
    dependencies = { 'junegunn/fzf.vim' },
    config = function()
      vim.g['$FZF_BIBTEX_CACHEDIR'] = '/tmp/'
			-- Loading the old vimtex vimscript configuration
			vim.cmd([[runtime! sections/vimtex.vim]])
    end,
    keys = {
      {
				-- TODO: Verify that this works if I have bibtex-ls and bibtex-cite setup.
        "@@", function()
          vim.cmd([[
            function! Bibtex_ls()
              let bibfiles = (
                  \ globpath('.', '*.bib', v:true, v:true) +
                  \ globpath('..', '*.bib', v:true, v:true) +
                  \ globpath('*/', '*.bib', v:true, v:true)
                  \ )
              let bibfiles = join(bibfiles, ' ')
              let source_cmd = 'bibtex-ls '.bibfiles
              return source_cmd
            endfunction

            function! s:bibtex_cite_sink_insert(lines)
                let r=system("bibtex-cite ", a:lines)
                execute ':normal! a' . r
                call feedkeys('a', 'n')
            endfunction
          ]])
          return [[
            <c-g>u<c-o>call fzf#run({
              'source': Bibtex_ls(),
              'sink*': function('<sid>bibtex_cite_sink_insert'),
              'down': '25%',
              'options': [ '--layout=reverse-list', '--multi', '--prompt', '\"Cite> \"' ]
            })<CR>
          ]]
        end, mode = "i", --silent 
      },
    }
  }
}
