return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim", "zapling/mason-conform.nvim" },
	event = "VeryLazy",
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
				bash = { "shfmt" },
				go = { "gofumpt", "goimports" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				python = { "ruff", "black" },
				terraform = { "terraform_fmt" },
				yaml = { "prettierd" },
			},
			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes
				local ignore_filetypes = { "json" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				return {
					lsp_fallback = true,
					timeout_ms = 500,
					async = false,
				}
			end,
		})

		require("mason-conform").setup({})
	end,
}
