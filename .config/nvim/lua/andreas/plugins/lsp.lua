return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		config = function()
			require("mason").setup()
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
			local keymap = vim.keymap -- for conciseness

			local opts = { noremap = true, silent = true }
			local on_attach = function(_, bufnr)
				opts.buffer = bufnr

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts) -- smart rename
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
				opts.desc = "Signature help"
				keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			end

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
			local servers = { "lua_ls", "jqls", "bashls", "gopls", "marksman", "ruff_lsp", "pyright" }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end

			-- configure terraformls
			lspconfig.terraformls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
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
