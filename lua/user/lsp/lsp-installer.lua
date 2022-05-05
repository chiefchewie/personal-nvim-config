local lspconfig = require("lspconfig")
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  print("error loading nvim-lsp-installer in file: lua/user/lsp/init.lua")
	return
end

-- This is the same as Chris's lsp-installer file
local servers = { "rust_analyzer", "sumneko_lua" }
lsp_installer.setup(
  {
    ensure_installed = servers, -- ensure these servers are always installed
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui =
    {
      icons =
      {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗"
      }
    }
  }
)

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
end

