return {
	"stevearc/aerial.nvim",
	opts = {
		layout = {
			default_direction = "prefer_left",
		},
		attach_mode = "global",
		show_guides = true,
	},

	keys = {
		{ "<leader>a", "<cmd>AerialToggle<CR>", desc = "Toggle Aerial", mode = "n" },
	},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
