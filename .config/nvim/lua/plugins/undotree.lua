return {
	"mbbill/undotree",
	keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo tree", mode = "n" } },
	config = function()
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_WindowLayout = 2
	end,
}
