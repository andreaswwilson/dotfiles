return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      "mikavilpas/blink-ripgrep.nvim",
    },

    -- use a release tag to download pre-built binaries
    version = 'v0.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = 'enter' },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      completion = {
        list = {
          selection = "auto_insert"
        }
      },


      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer', 'ripgrep' },
        --
        -- optionally disable cmdline completions
        -- cmdline = {},
      },
      providers = {
        providers = {
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            -- the options below are optional, some default values are shown
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {
              -- For many options, see `rg --help` for an exact description of
              -- the values that ripgrep expects.

              -- the minimum length of the current word to start searching
              -- (if the word is shorter than this, the search will not start)
              prefix_min_len = 3,

              -- The number of lines to show around each match in the preview window.
              -- For example, 5 means to show 5 lines before, then the match, and
              -- another 5 lines after the match.
              context_size = 5,

              -- The maximum file size that ripgrep should include in its search.
              -- Useful when your project contains large files that might cause
              -- performance issues.
              -- Examples: "1024" (bytes by default), "200K", "1M", "1G"
              max_filesize = "1M",

              -- (advanced) Any additional options you want to give to ripgrep.
              -- See `rg -h` for a list of all available options. Might be
              -- helpful in adjusting performance in specific situations.
              -- If you have an idea for a default, please open an issue!
              --
              -- Not everything will work (obviously).
              additional_rg_options = {}
            },
          },
        },
      },

      -- experimental signature help support
      signature = { enabled = true },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" }
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      { 'saghen/blink.cmp' },
      { 'L3MON4D3/LuaSnip' },
      -- { 'hrsh7th/nvim-cmp' },
      -- { 'hrsh7th/cmp-nvim-lsp' },
      -- { 'hrsh7th/cmp-buffer' },
      -- { 'hrsh7th/cmp-path' },
      -- { 'saadparwaiz1/cmp_luasnip' },
      { 'rafamadriz/friendly-snippets' },
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = "yes"
    end,
    config = function()
      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      -- Also enable ufo folding
      local lspconfig_defaults = require('lspconfig').util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lspconfig_defaults.capabilities,
        require('blink.cmp').get_lsp_capabilities(),
        -- require('cmp_nvim_lsp').default_capabilities(),
        {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }
      )
      -- LspAttach is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
          vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
          vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
          vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
          -- vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open:float()<cr>", opts)
          vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
          vim.keymap.set("n", "cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          vim.keymap.set("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        end,
      })

      require('mason').setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- LSP
          "bashls",
          "gitlab_ci_ls",
          "gopls",
          "jsonls",
          "lua_ls",
          "terraformls",
          "marksman",
        },

        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
          -- Custom handler for terraformls to disable semantic tokens
          ["terraformls"] = function()
            require("lspconfig").terraformls.setup({
              -- Disable semantic tokens for terraformls
              on_attach = function(client, _)
                client.server_capabilities.semanticTokensProvider = nil
              end,
            })
          end,
        },
      })

      -- local cmp = require('cmp')
      -- require('luasnip.loaders.from_vscode').lazy_load()
      -- cmp.setup({
      -- 	sources = {
      -- 		{ name = 'path' },
      -- 		{ name = 'nvim_lsp' },
      -- 		{ name = 'luasnip', keyword_length = 2 },
      -- 		{ name = 'buffer',  keyword_length = 3 },
      -- 	},
      -- 	window = {
      -- 		completion = cmp.config.window.bordered(),
      -- 		documentation = cmp.config.window.bordered(),
      -- 	},
      -- 	snippet = {
      -- 		expand = function(args)
      -- 			require('luasnip').lsp_expand(args.body)
      -- 		end,
      -- 	},
      -- 	mapping = cmp.mapping.preset.insert({
      -- 		-- confirm completion item
      -- 		['<Enter>'] = cmp.mapping.confirm({ select = true }),
      -- 		-- scroll up and down the documentation window
      -- 		['<C-u>'] = cmp.mapping.scroll_docs(-4),
      -- 		['<C-d>'] = cmp.mapping.scroll_docs(4),
      -- 		-- jump to the next snippet placeholder
      -- 	}),
      -- })
    end,
  },
}
