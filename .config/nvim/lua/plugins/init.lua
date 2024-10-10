return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "terraform",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      auto_install = true,
    },
  },
  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = { mode = "cursor", max_lines = 3 },
  },
}
