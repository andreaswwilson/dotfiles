-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- Servers with standard setup
local servers = {
  "bashls",
  "jsonls",
  "lua_ls",
  "terraformls",
  "yamlls",
}
local nvlsp = require "nvchad.configs.lspconfig"
--
-- Custom on_attach function
local custom_on_attach = function(client, bufnr)
  -- Call the original on_attach function
  nvlsp.on_attach(client, bufnr)

  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = bufnr, desc = "LSP Telescope references" })
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

lspconfig.gopls.setup {
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
}
