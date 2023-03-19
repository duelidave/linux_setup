-- LSP Configuration

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = require("lsp.defaults").default_on_attach

-- add completion capability
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')
local servers = { 'tsserver', 'pyright', 'metals', 'dartls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

require('dap.ext.vscode').load_launchjs()
