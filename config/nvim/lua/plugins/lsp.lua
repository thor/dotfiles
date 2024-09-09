local utils = require "utils"

-- do not load lsp enhancements if nvim is used as the interface rather than editor
if not utils.is_terminal() then
  return {}
end

return {
  -- file enhancements and syntax fixes, nvim-specific, LSP
  {
    -- help us get packages for lsps without having to deal with a lot of system config
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "open Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts "MasonSettings" | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup()
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    -- support diagnostics with generic linters
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- yaml
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.formatting.yamlfmt,
          -- python (see lsp for ruff and pyright)
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.diagnostics.pylint.with({
            extra_args = { "--disable", "too-few-public-methods,missing-function-docstring" },
          }),
          -- shell scripts
          null_ls.builtins.formatting.shfmt,
          -- others
          null_ls.builtins.code_actions.refactoring,
        },
      })
    end,
  },
  {
    -- easy integration of mason and lspconfig
    "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
  },
  {
    --- core lsp configs
    'neovim/nvim-lspconfig',
    dependencies = "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    config = function()
      -- bash
      require 'lspconfig'.bashls.setup {}
      -- go
      require 'lspconfig'.gopls.setup {}
      -- python
      require 'lspconfig'.pylsp.setup {
        cmd = { "python", "-m", "pylsp" },
        plugins = {
          black = {
            enabled = true,
          },
        },
      }
      require 'lspconfig'.pyright.setup {}
      -- php (!)
      require 'lspconfig'.phpactor.setup {}
      require 'lspconfig'.ruff_lsp.setup {}
      -- terraform
      require 'lspconfig'.terraformls.setup {
        cmd = { "terraform-ls", "serve" },
      }
      require 'lspconfig'.tflint.setup {}
      -- toml
      require 'lspconfig'.taplo.setup {}
      -- typescript
      require 'lspconfig'.tsserver.setup {}
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
      -- yaml
      require 'lspconfig'.yamlls.setup {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
          },
        },
      }
      -- cpp
      require 'lspconfig'.clangd.setup {}

      -- Use the LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          -- Goals: to provide a better usage experience with which-keyboard
          local opts = function(opts)
            local shared = { buffer = ev.buf }
            return vim.tbl_extend("error", shared, opts)
          end
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts { desc = "go to declaration" })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts { desc = "go to definition" })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts { desc = "show hover docs" })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts { desc = "go to implementation" })
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts { desc = "show signature help" })
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts { desc = "add workspace folder" })
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
            opts { desc = "remove workspace folder" })
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts { desc = "list workspace folders" })
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts { desc = "show type definition" })
          vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts { desc = "rename symbol" })
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts { desc = "code actions" })
          vim.keymap.set('n', '<leader>cf', function()
            vim.lsp.buf.format { async = true }
          end, opts { desc = "format document" })
        end
      })
    end,
  },
  --- LSP error overview in the terminal
  {
    'folke/trouble.nvim',
    opts = {},
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-tree/nvim-web-devicons'
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "diagnostics"
      },
      {
        "<leader>xb",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "buffer diagnostics"
      },
      {
        "<leader>xl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "local list"
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "quick fix list"
      },
      {
        "gr",
        "<cmd>Trouble lsp toggle pinned=true focus=true win.position=bottom<cr>",
        desc = "code references"
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "definitions/references"
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "symbols"
      },
    }
  },

  ---- enhanced highlighting, incl. additional treesitter context
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        ensure_installed = {
          "bash",
          "javascript",
          "json",
          "lua",
          "go",
          "terraform",
          "typescript",
          "tsx",
          "markdown",
          "markdown_inline",
          "php",
          "python",
          "rust",
          "vim",
          "yaml",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Do not install parsers automatically, due missing tree-sitter CLI
        auto_install = false,

        -- None to ignore
        ignore_install = {},

        highlight = {
          -- `false` will disable the whole extension
          enable = true,
        },
        modules = {}
      }
    end
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
