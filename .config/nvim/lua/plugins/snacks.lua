return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  keys = {
    { "<leader>gb", function() Snacks.git.blame_line() end,   desc = "Git Blame Line" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>gg", function() Snacks.lazygit() end,          desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end,      desc = "Lazygit Log (cwd)" },
    { "<leader>un", function() Snacks.notifier.hide() end,    desc = "Dismiss All Notifications" },
  }
}
