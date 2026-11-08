local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

local servidores = { "lua_ls", "clangd", "pyright", "gopls", "cssls", "html", "bashls" }

mason.setup()
mason_lspconfig.setup({ ensure_installed = servidores })

-- Neovim 0.11+: lspconfig.<servidor>.setup{} saiu; as configurações vêm do nvim-lspconfig e ligam assim.
vim.lsp.enable(servidores)
