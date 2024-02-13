return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-tree/nvim-web-devicons",
	},

	cmd = "Telescope",
	keys = {
		{ "<leader>ff",       "<cmd>Telescope git_files<cr>",                 desc = "Fuzzy find files in .git" },
		{ "<leader>fF",       "<cmd>Telescope find_files<cr>",                desc = "Fuzzy find files in cwd" },
		{ "<leader>fr",       "<cmd>Telescope oldfiles<cr>",                  desc = "Fuzzy find recent files" },
		{ "<leader>fg",       "<cmd>Telescope live_grep<cr>",                 desc = "Find string in cwd" },
		{ "<leader>fw",       "<cmd>Telescope grep_string<cr>",               desc = "Find string under cursor in cwd" },
		{ "<leader>fb",       "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find string in current buffer" },
		{ "<leader><leader>", "<cmd>Telescope buffers<cr>",                   desc = "List open buffers" },
		{ "<leader>fh",       "<cmd>Telescope help_tags<cr>",                 desc = "Open help tags" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				vimgrep_arguments = { 'rg', '--hidden', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-g', '!.git' },
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = { undo = {} },
		})
		telescope.load_extension("fzf")
	end,
}
