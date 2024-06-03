local utils = require('utils')

return {
  {
    'L3MOND4D3/LuaSnip',
    build = "echo 'js_regexp is optional; okay if it fails'; make install_jsregexp" or nil,
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end
  },
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    cond = utils.is_terminal,
    dependencies = {
      -- the core of it all
      -- TODO: Consider moving lspconfig into this file
      'neovim/nvim-lspconfig',
      -- the binding plugin between nvim-cmp and the native lsp
      { 'hrsh7th/cmp-nvim-lsp' },
      -- do I want buffer completion source?
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      {
        'petertriho/cmp-git',
        dependencies = "nvim-lua/plenary.nvim"
      },
      -- a snippets engine is required for nvim-cmp
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' }
    },
    config = function()
      -- Set up nvim-cmp.
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          -- We must specify a snippet engine, and we use luasnip
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.scroll_docs(-4),
          ['<C-n>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        -- We must also specify sources, which includes the snippet engine
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- Set configuration for specific filetype, here Git
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'buffer' },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      -- Setup lspconfig capabilities
      -- TODO: Consider moving to lspconfig, or as further up, the other way around
      -- Set up lspconfig.
      local lspconfig = require('lspconfig')
      local lsp_defaults = lspconfig.util.default_config

      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )
    end
  },

}
