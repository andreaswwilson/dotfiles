return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async", "luukvbaal/statuscol.nvim" },
	event = { "VeryLazy" },
	keys = {
		{
			"zR",
			function()
				require("ufo").openAllFolds()
			end,
			desc = "Open all folds",
		},
		{
			"zM",
			function()
				require("ufo").closeAllFolds()
			end,
			desc = "Close all folds",
		},
	},
	opts = {
		filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
	},
	config = function(_, opts)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
		for _, ls in ipairs(language_servers) do
			require("lspconfig")[ls].setup({
				capabilities = capabilities,
				-- you can add other fields for setting up lsp server in this table
			})
		end
		local builtin = require("statuscol.builtin")
		local cfg = {
			setopt = true,
			relculright = true,
			segments = {

				{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa", hl = "Comment" },

				{ text = { "%s" }, click = "v:lua.ScSa" },
				{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
			},
		}

		require("statuscol").setup(cfg)
		require("ufo").setup(opts)
	end,
}
