local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofumpt" },
    terraform = { "terraform_fmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = false,
  },
}

return options
