local options = {
  formatters_by_ft = {
    go = { "gofumpt" },
    lua = { "stylua" },
    sh = { "shfmt" },
    terraform = { "terraform_fmt" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
}

return options
