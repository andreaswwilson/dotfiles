local map = vim.keymap.set
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("x", "p", [["_dP]]) -- Don't overwrite register when pasting
map("n", "x", '"_x') -- delete single char without copy into register
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "move up" })

-- map("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>")
-- map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "telescope diagnostics" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

local wk = require("which-key")
wk.add({
	{ "<leader>f", group = "find" },
	{ "<leader>b", group = "buffer" },
	{ "<leader>x", group = "trouble" },
	-- Find mappings
	{ "<leader>ff", "<cmd>Pick files<cr>", desc = "Find files" },
	{ "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Find buffer" },
	{ "<leader>fw", "<cmd>Pick grep_live_align<cr>", desc = "Find in files" },
	{ "<leader>fW", "<cmd>Pick buf_lines scope='current' preserve_order=true<cr>", desc = "Find in current buffer" },
	{ "<leader>fr", "<cmd>Pick resume<cr>", desc = "Resume picker" },
	{ "<leader>fo", "<cmd>Pick oldfiles<cr>", desc = "Resume picker" },
	{ "<leader>fd", "<cmd>Pick diagnostic<cr>", desc = "Find diagnostics" },
	{ "<leader>fk", "<cmd>Pick keymaps<cr>", desc = "Find keymaps" },
	{ "<leader>fh", "<cmd>Pick help<cr>", desc = "Find help" },
	{ "<leader>fc", "<cmd>Pick commands<cr>", desc = "Find commands" },

	-- Buffer mappings
	{
		"<leader>bd",
		function()
			require("mini.bufremove").delete()
		end,
		desc = "Delete buffer",
	},
	{ "<leader>bo", "<cmd>%bdelete|edit #<cr>", desc = "Close other buffers" },
	{ "<S-h>", "<cmd>bprevious<cr>", desc = "Previous buffer" },
	{ "<S-l>", "<cmd>bnext<cr>", desc = "Next buffer" },

	-- smart splits
	-- Moving between splits
	{ "<C-h>", require("smart-splits").move_cursor_left, desc = "Move cursor left" },
	{ "<C-j>", require("smart-splits").move_cursor_down, desc = "Move cursor down" },
	{ "<C-k>", require("smart-splits").move_cursor_up, desc = "Move cursor up" },
	{ "<C-l>", require("smart-splits").move_cursor_right, desc = "Move cursor right" },
	{ "<C-\\>", require("smart-splits").move_cursor_previous, desc = "Move cursor to previous split" },
	-- Swapping buffers between windows
	{ "<leader><leader>h", require("smart-splits").swap_buf_left, desc = "Swap buffer left" },
	{ "<leader><leader>j", require("smart-splits").swap_buf_down, desc = "Swap buffer down" },
	{ "<leader><leader>k", require("smart-splits").swap_buf_up, desc = "Swap buffer up" },
	{ "<leader><leader>l", require("smart-splits").swap_buf_right, desc = "Swap buffer right" },

	{ "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Diagnostic open float" },
})