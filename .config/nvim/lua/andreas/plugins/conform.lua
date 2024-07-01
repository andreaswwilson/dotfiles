return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ lsp_format = "fallback", timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				python = { "ruff", "black" },
				terraform = { "terraform_fmt" },
				yaml = { "prettierd" },
				go = { "gofumpt" },
			},
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	timeout_ms = 500,
			-- 	async = false,
			-- }
		})
	end,
}
