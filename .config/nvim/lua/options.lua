require "nvchad.options"

vim.o.relativenumber = true
vim.o.termguicolors = true

-- undo
vim.o.undofile = true -- save undo history
vim.o.undodir = os.getenv "HOME" .. "/.vim/undodir"

-- Folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99

-- turn off swap file
vim.o.swapfile = false
