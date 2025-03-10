-- Syntax files aren't provided for non-TUI
local utils = require "utils"

---@type LazySpec[]
local plugins = {
  {
    -- Go-go-go-go neovim!
    'ray-x/go.nvim',
    disabled = true,
    ft = 'go',
  },
  {
    -- PlantUML
    'aklt/plantuml-syntax',
  },
  {
    -- Terraform
    'hashivim/vim-terraform',
    ft = 'terraform',
    config = function()
      -- Aligning automatically
      vim.g.terraform_align = 1
      -- Foldin' 's pretty cool too
      vim.g.terraform_fold_sections = 1
      -- Automatically apply fmt on save
      -- TODO: Replace automatical apply of fmt on save with LSP functionality
      vim.g.terraform_fmt_on_save = 1
    end,
  },
  {
    -- Pandoc (Markdown superset)
    'vim-pandoc/vim-pandoc-syntax',
    ft = 'pandoc',
    dependencies = {
      {
        'vim-pandoc/vim-pandoc',
        config = function()
          -- Configuring vim-pandoc (not syntax)
          vim.cmd [[runtime! sections/pandoc.vim]]
        end,
      },
    },
    keys = {
      { "<leader>pw", "<C-U>call <SID>pandocOnWrite()<CR>", desc = "Enable Pandoc render on write" },
      { "<leader>pS", ":<C-U>call <SID>pandocSoft()<CR>",   desc = "Enable Pandoc soft-mode" },
    },
  },
  {
    -- Rust
    -- TODO: Update Rust with relevant LSP configuration
    'rust-lang/rust.vim',
    ft = 'rust',
  },
  {
    -- systemd unit files syntax
    'Matt-Deacalion/vim-systemd-syntax',
  },
  {
    -- Simplified YAML syntax for speed increases
    -- TODO: Consider removing yaml plugin in lieu of yaml-companion or LSP
    'stephpy/vim-yaml',
    ft = 'yaml',
  },
  {
    -- LaTeX editing & completion and all
    -- NOTE: Temporarily disabled while I contemplate how often I use TeX these days
    'lervag/vimtex',
    ft = 'tex',
    cond = true,
    dependencies = { 'junegunn/fzf.vim', 'preservim/vim-pencil' },
    config = function()
      vim.g['$FZF_BIBTEX_CACHEDIR'] = '/tmp/'
      -- Loading the old vimtex vimscript configuration
      vim.cmd([[runtime! sections/vimtex.vim]])
    end,
    keys = {
      {
        -- TODO: Verify that this works if I have bibtex-ls and bibtex-cite setup.
        "@@",
        function()
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
        end,
        mode = "i",
        expr = true,
      },
    }
  }
}

for _, v in ipairs(plugins) do
  if not v.cond or v.cond == {} then
    v.cond = utils.is_terminal
  end
  v.lazy = true
end

return plugins
