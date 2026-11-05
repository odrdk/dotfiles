local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "AlphaTechnolog/pywal.nvim", name = "pywal" },

  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-media-files.nvim",
  "lukas-reineke/indent-blankline.nvim",
  { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate", lazy = false },
  "NvChad/nvim-colorizer.lua",
  "nvim-tree/nvim-web-devicons",
  "windwp/nvim-autopairs",
  "akinsho/bufferline.nvim",
  "nvim-tree/nvim-tree.lua",
  "akinsho/toggleterm.nvim",
  "goolord/alpha-nvim",
  "lewis6991/gitsigns.nvim",
  "nvim-lualine/lualine.nvim",

  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
})
