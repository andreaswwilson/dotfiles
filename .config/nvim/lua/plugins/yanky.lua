return {
  "gbprod/yanky.nvim",
  opts = {},
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },

    { "<C-n>", "<Plug>(YankyNextEntry)", mode = "n", desc = "Cycle to next yank in history" },
    { "<C-p>", "<Plug>(YankyPreviousEntry)", mode = "n", desc = "Cycle to previous yank in history" },
    {
      "<leader>p",
      function()
        Snacks.picker.yanky()
      end,
      mode = { "n", "x" },
      desc = "Open Yank History",
    },
  },
}
