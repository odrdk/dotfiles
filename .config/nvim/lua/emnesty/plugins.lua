-- Gerenciador: lazy.nvim (o packer foi abandonado e não roda no Neovim 0.12).
-- Mesma lista de plugins de antes; :Lazy abre o painel.
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "AlphaTechnolog/pywal.nvim", name = "pywal" },
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-media-files.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "nvim-treesitter/nvim-treesitter",
  "NvChad/nvim-colorizer.lua",
  "nvim-tree/nvim-web-devicons",
  "windwp/nvim-autopairs",
  "akinsho/bufferline.nvim",
  "nvim-tree/nvim-tree.lua",
  "akinsho/toggleterm.nvim",
  "goolord/alpha-nvim",
  "lewis6991/gitsigns.nvim",

  -- lualine
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- cmp plugins
  "hrsh7th/nvim-cmp", -- The completion plugin
  "hrsh7th/cmp-buffer", -- buffer completions
  "hrsh7th/cmp-path", -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  "saadparwaiz1/cmp_luasnip", -- snippet completions

  -- snippets
  "L3MON4D3/LuaSnip", --snippet engine
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use
}, {
  ui = { border = "rounded" },
  change_detection = { notify = false },
})
