return {
  'stevearc/oil.nvim',
  init = function()
    -- disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      natural_order = true,
      show_hidden = true,
      is_always_hidden = function(name, _)
        return name == '..' or name == '.git'
      end,
    },
    watch_for_changes = true,
    win_options = {
      wrap = true,
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  keys = {
    {
      '<leader>e',
      function()
        require('oil').open()
      end,
      desc = 'Open oil',
    },
  },
}
