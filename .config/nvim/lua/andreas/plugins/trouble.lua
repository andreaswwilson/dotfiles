return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<leader>xx",
			function()
				require("trouble").toggle()
			end,
			desc = "trouble: toggle",
		},
		{
			"<leader>xw",
			function()
				require("trouble").toggle("workspace_diagnostics")
			end,
			desc = "trouble: workspace diagnostics",
		},
		{
			"<leader>xd",
			function()
				require("trouble").toggle("document_diagnostics")
			end,
			desc = "trouble: document diagnostics",
		},
		{
			"<leader>xq",
			function()
				require("trouble").toggle("quickfix")
			end,
			desc = "trouble: quickfix",
		},
		{
			"<leader>xl",
			function()
				require("trouble").toggle("loclist")
			end,
			desc = "trouble: loclist",
		},
	},
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
