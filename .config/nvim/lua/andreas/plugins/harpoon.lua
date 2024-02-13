return {
	"ThePrimeagen/harpoon",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
	keys = {
		{ "<s-m>", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Mark File", mode = "n" },
		{ "<TAB>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Toggle harpoon menu", mode = "n" },
	},
}
