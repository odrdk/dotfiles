local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

local linguagens = { "c", "lua", "python", "html", "css", "javascript" }
treesitter.install(linguagens)

vim.api.nvim_create_autocmd("FileType", {
  pattern = linguagens,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
