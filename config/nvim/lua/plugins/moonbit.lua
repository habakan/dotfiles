return {
  {
    "moonbit-community/moonbit.nvim",
    ft = { "moonbit" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      treesitter = {
        enabled = true,
      },
      lsp = { enabled = false }, -- lsp.lua で管理
    },
  },
}
