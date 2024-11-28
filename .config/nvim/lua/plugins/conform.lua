return {

  { -- Autoformat
    "stevearc/conform.nvim",

    dependencies = {
      {
        "rshkarin/mason-nvim-lint",
        opts = {
          ensure_installed = {
            "fixjson",
            "gofumpt",
            "goimports",
            "shfmt",
            "stylelua",
          }
        }
      }
    },

    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = "never"
        else
          lsp_format_opt = "fallback"
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        json = { "fixjson" },
        lua = { "stylua" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  }
}