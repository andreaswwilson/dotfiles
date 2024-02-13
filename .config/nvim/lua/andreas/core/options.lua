local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- undo
opt.undofile = true -- save undo history
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- spell checking
-- ]s next misspelled word
-- z= - suggestion
-- zg - add to spell
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- turn off swap file
opt.swapfile = false

-- Folds used with nvim-ufo
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1" -- '0' is not bad
opt.foldenable = true
