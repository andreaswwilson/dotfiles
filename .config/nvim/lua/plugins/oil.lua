return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      natural_order = true,
      show_hidden = true,
    },
    win_options = {
      wrap = true,
    }
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  keys = {
    {
      "<leader>e",
      function()
        require("oil").open()
      end,
      desc = "Open oil",
    },
  },
}
