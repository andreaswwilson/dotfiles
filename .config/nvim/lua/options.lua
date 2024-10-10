require "nvchad.options"

vim.o.relativenumber = true
vim.o.termguicolors = true

-- undo
vim.o.undofile = true -- save undo history
vim.o.undodir = os.getenv "HOME" .. "/.vim/undodir"

-- Folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldnestmax = 3
-- turn off swap file
vim.o.swapfile = false

-- backspace
vim.o.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
