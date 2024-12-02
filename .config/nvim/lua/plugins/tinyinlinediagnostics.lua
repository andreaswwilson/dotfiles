return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000,    -- needs to be loaded in first
  init = function()
    vim.diagnostic.config({ virtual_text = false })
  end,
  config = true,
  opts = {
    preset = "minimal",
    options = {
      multilines = true,
      show_source = true,
    },
  },
}
