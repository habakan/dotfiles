return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      on_highlights = function(hl, c)
        -- カーソル行にアンダーラインを引く
        hl.CursorLine = { underline = true, sp = c.blue }
        -- カーソル行の行番号を強調
        hl.CursorLineNr = { fg = c.orange, bold = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
