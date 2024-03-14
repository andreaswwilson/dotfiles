return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		config = function()
			require("mason").setup()
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "williamboman/mason.nvim" },
			{ "jayp0521/mason-null-ls.nvim" },
		},

		event = "VeryLazy",
		keys = {
			{ "gr", "<cmd>Telescope lsp_references<CR>", desc = "Show LSP references" },
			{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
			{ "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "Show LSP definitions" },
			{ "gi", "<cmd>Telescope lsp_implementations<CR>", desc = "Show LSP implementations" },
			{ "gt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Show LSP type definitions" },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "See available code actions" },
			{ "<leader>cr", vim.lsp.buf.rename, desc = "Smart rename" },
			{ "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics" },
			{ "<leader>d", vim.diagnostic.open_float, desc = "Show line diagnostics" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic" },
			{ "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
			{ "K", vim.lsp.buf.hover, desc = "Show documentation for what is under cursor" },
			{ "<leader>rs", ":LspRestart<CR>", desc = "Restart LSP" },
		},
		config = function()
			local lspconfig = require("lspconfig")

			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"lua_ls",
					"jqls",
					"gopls",
					"marksman",
					"terraformls",
					"pyright",
					"ruff_lsp",
				},
			})

			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			vim.lsp.handlers["textdocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textdocument/signaturehelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
			-- used to enable autocompletion (assign to every lsp server config)
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Change the Diagnostic symbols in the sign column (gutter)
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Default setup
			local servers = { "lua_ls", "jqls", "bashls", "marksman", "ruff_lsp", "pyright" }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end

			-- go
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure terraformls
			lspconfig.terraformls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					require("lsp_signature").on_attach({
						bind = true, -- This is mandatory, otherwise border config won't get registered.
						handler_opts = {
							border = "rounded",
						},
					}, bufnr)
				end,
				filetypes = { "terraform" }, -- Specify the filetypes for which terraformls should be activated
			})
			-- lua_ls
			--
			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							version = "LuaJIT",
							path = runtime_path,
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							library = {
								-- Make the server aware of Neovim runtime files
								vim.fn.expand("$VIMRUNTIME/lua"),
								vim.fn.stdpath("config") .. "/lua",
							},
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	},
}
