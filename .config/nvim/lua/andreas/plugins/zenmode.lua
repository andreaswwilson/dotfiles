return {
	-- { "folke/twilight.nvim" },
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			window = {
				width = 180,
			},
		},

		keys = { { "<leader>Z", "<cmd>:ZenMode<CR>", desc = "Toggle ZenMode" } },
	},
}
