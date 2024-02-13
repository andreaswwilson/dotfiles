return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		build = ":TSUpdate",

		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- enable indentation
				indent = { enable = true },
				-- ensure these language parsers are installed
				ensure_installed = {
					"bash",
					"dockerfile",
					"gitcommit",
					"gitignore",
					"go",
					"gomod",
					"gosum",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"rust",
					"terraform",
					"toml",
					"vim",
					"xml",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
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
