return {
	"stevearc/oil.nvim",
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
	opts = {
		default_file_explorer = true,
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	keys = {
		{
			"<leader>e",
			function()
				require("oil").open()
			end,
			desc = "Open oil",
		},
	},
}
