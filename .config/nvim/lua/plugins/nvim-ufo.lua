return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async", "luukvbaal/statuscol.nvim" },
  event = { "LspAttach" },
  keys = {
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
      desc = "Open all folds",
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
      desc = "Close all folds",
    },
  },
  opts = {
    filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
  },
}
