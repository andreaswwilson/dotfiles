return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  event = "VeryLazy", -- Delay loading slightly
  opts = function(_, opts)
    local formatters = {
      "gofumpt",
      "goimports",
      "prettier",
      "prettierd",
      "stylua",
      "shfmt",
      "fixjson",
    }
    local lsps = {
      "gopls",
      "lua_ls",
      "pyright",
      "tofu_ls",
    }

    local tools_to_install = {}
    vim.list_extend(tools_to_install, formatters)
    vim.list_extend(tools_to_install, lsps)

    -- Merge with any existing ensure_installed config
    opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, tools_to_install)
    opts.auto_update = true
  end,
}
