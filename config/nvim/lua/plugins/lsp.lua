return {
  -- file enhancements and syntax fixes, nvim-specific, LSP
  --- core lsp
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    config = function()
      -- python
      require 'lspconfig'.pylsp.setup {
        -- To enable pylsp-rope logging
        -- cmd = { "pylsp", "-v", "--log-file", "/tmp/nvim-pylsp.log" },
        cmd = { "python", "-m", "pylsp" },
      }
      -- terraform
      require 'lspconfig'.terraformls.setup {
        cmd = { "terraform-ls", "serve" },
      }
      -- typescript
      require 'lspconfig'.tsserver.setup { }
      -- lua
      require 'lspconfig'.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Stop bothering me that 'vim' is missing; assume it's global
              globals = { 'vim' },
            },
            workspace = {
              -- Load in the nvim APIs
              library = vim.api.nvim_get_runtime_file("", true),
              -- Don't bother us about applying configurations
              checkThirdParty = false,
            },
          }
        },
      }
      -- TODO: Convert ale configuration into LSP configuration
      -- let g:ale_sign_error = "◉"
      -- let g:ale_sign_warning = "◉"
      -- let g:ale_sign_info = "◈"
      -- highlight ALEErrorSign ctermfg=9 ctermbg=18
      -- highlight ALEWarningSign ctermfg=11 ctermbg=18
      -- highlight ALEInfoSign ctermfg=6 ctermbg=18

      -- Use the LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end
      })
    end,
  },
  --- Colours for LSP
  -- TODO: switcheroo to rrethy's nvim-base16
  { 'folke/lsp-colors.nvim',       lazy = true, cond = is_terminal },
  --- LSP error overview in the terminal
  {
    'folke/trouble.nvim',
    cond = is_terminal,
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require 'trouble'.setup {}
    end
  },

  ---- enhanced highlighting, incl. additional treesitter context
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cond = is_terminal,
    config = function()
      require 'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        ensure_installed = {
          "bash",
          "lua",
          "rust",
          "vim",
          "go",
          "python",
          "terraform",
          "markdown"
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        highlight = {
          -- `false` will disable the whole extension
          enable = true,
        }
      }
    end
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cond = is_terminal,
    config = function()
      require('treesitter-context').setup {
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
    end
  },
}
