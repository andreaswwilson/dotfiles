return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
		build = ":TSUpdate",

		config = function()
			local treesitter = require("nvim-treesitter.configs")

			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				sync_install = false,
				-- enable indentation
				indent = { enable = true },
				-- ensure these language parsers are installed
				ensure_installed = {},
				-- Automatically install missing parsers when entering buffer
				auto_install = true,
			})
		end,
	},
	-- Show context of the current function
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = { mode = "cursor", max_lines = 3 },
	},
}
