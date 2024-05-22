return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ lsp_fallback = true, timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				go = { "goimports", "gofumpt" },
				python = { "ruff", "black" },
				terraform = { "terraform_fmt" },
			},
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	timeout_ms = 500,
			-- 	async = false,
			-- },
		})
	end,
}
