local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "move up" })

map("n", "x", '"_x') -- delete single char without copy into register
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- buffers
map("n", "<A-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<A-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- qlist
map("n", "<leader>cn", ":cnext<CR>", { desc = "Next quicklist item", silent = true })
map("n", "<leader>cp", ":cprevious<CR>", { desc = "Previous quicklist item", silent = true })
