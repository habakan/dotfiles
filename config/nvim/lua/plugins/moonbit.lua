return {
  {
    "moonbit-community/moonbit.nvim",
    ft = { "moonbit" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      treesitter = {
        enabled = true,
        auto_install = true,
      },
      lsp = { enabled = false }, -- lsp.lua で管理
    },
  },
}
