return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  lazy = false,
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup()

    -- Simple and easy statusline.
    local statusline = require("mini.statusline")
    -- set use_icons to true if you have a Nerd Font
    statusline.setup({})

    require("mini.comment").setup()
    -- require("mini.completion").setup({
    --   window = {
    --     info = { border = "double" },
    --     signature = { border = "double" },
    --   },
    -- })
    require("mini.extra").setup()
    require("mini.git").setup()
    require("mini.diff").setup()
    require("mini.icons").setup()
    require("mini.bufremove").setup()
    -- require('mini.tabline').setup()
  end,
}
