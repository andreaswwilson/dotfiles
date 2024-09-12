return {
	"lewis6991/gitsigns.nvim",
	event = { "VeryLazy" },
	keys = {
		{ "<leader>gs", "<cmd>Gitsigns stage_hunk", desc = "Stage hunk", mode = "n" },
		{ "<leader>gS", "<cmd>Gitsigns stage_buffer", desc = "Stage buffer", mode = "n" },
		{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk", desc = "Undo stage hunk", mode = "n" },
	},
	opts = {
		base = "main",
	},
}
