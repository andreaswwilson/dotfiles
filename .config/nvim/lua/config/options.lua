local opt = vim.opt
-- line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)
opt.relativenumber = true -- show relative line numbers
-- undo
opt.undofile = true -- save undo history
opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
-- line wrapping
opt.wrap = true -- enable line wrapping
-- turn off swap file

opt.swapfile = false
-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
-- clipboard
opt.clipboard:append 'unnamedplus' -- use system clipboard as default register:wq

-- sessions
opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'
