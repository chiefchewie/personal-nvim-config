local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	return
end

local lsp_installer_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not lsp_installer_status_ok then
  print("error loading nvim-lsp-installer in file: lua/user/lsp/init.lua")
	return
end

local lsp_handlers = require "user.lsp.handlers"

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
  local default_options = {
      on_attach = lsp_handlers.on_attach,
      capabilities = lsp_handlers.capabilities,
  }

  if lsp == "sumneko_lua" then
    local sumneko_options = require("user.lsp.settings.sumneko_lua")
    default_options = vim.tbl_deep_extend("force", sumneko_options, default_options)
  end

  lspconfig[lsp].setup(default_options)
end

lsp_handlers.setup()
