return {
	"folke/which-key.nvim",
	keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
  init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		plugins = { spelling = true },
		key_labels = { ["<leader>"] = "SPC" },
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register({
			["<leader>d"] = { name = "Debug" },
			["<leader>dg"] = { name = "Debug Go" },
			["<leader>x"] = { name = "Trouble" },
			["<leader>g"] = { name = "Git" },
			["<leader>c"] = { name = "Code Actions" },
			["<leader>e"] = { name = "File Explorer" },
		})
	end,
}
