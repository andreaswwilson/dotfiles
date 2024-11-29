local opt = vim.opt
-- line numbers
opt.number = true         -- shows absolute line number on cursor line (when relative number is on)
opt.relativenumber = true -- show relative line numbers
--
-- tabs & indentation
opt.autoindent = true -- copy indent from current line when starting new one
opt.expandtab = true  -- expand tab to spaces
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.tabstop = 2       -- 2 spaces for tabs (prettier default)
--
-- undo
opt.undofile = true -- save undo history
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- line wrapping
opt.wrap = true -- enable line wrapping

-- Add UFO folding configuration
opt.foldcolumn = "0"
opt.foldlevel = 99 -- Using ufo provider need a large value
opt.foldlevelstart = 99
opt.foldenable = true
-- turn off swap file
opt.swapfile = false

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- appaerance
opt.cursorline = true -- highlight the current cursor line
opt.termguicolors = true

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register:wq
