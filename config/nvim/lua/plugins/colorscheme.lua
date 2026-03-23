return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      on_highlights = function(hl, c)
        -- カーソル行
        hl.CursorLine = { underline = true, sp = c.blue }
        hl.CursorLineNr = { fg = c.orange, bold = true }

        -- 行番号・サイン列
        hl.LineNr = { fg = "#a9b1d6" }
        hl.SignColumn = { fg = "#a9b1d6" }

        -- コメント
        hl.Comment = { fg = "#b4bef0", italic = true }

        -- Visual選択
        hl.Visual = { bg = "#5f6692" }
        hl.VisualNOS = { bg = "#5f6692" }

        -- 検索
        hl.Search = { fg = "#1a1b26", bg = c.yellow, bold = true }
        hl.IncSearch = { fg = "#1a1b26", bg = c.orange, bold = true }
        hl.CurSearch = { fg = "#1a1b26", bg = c.red, bold = true }

        -- フロートウィンドウ
        hl.NormalFloat = { bg = "#33364d" }
        hl.FloatBorder = { fg = "#7aa2f7", bg = "#33364d" }
        hl.FloatTitle = { fg = "#7aa2f7", bg = "#33364d", bold = true }

        -- ポップアップメニュー (補完など)
        hl.Pmenu = { fg = c.fg, bg = "#33364d" }
        hl.PmenuSel = { fg = "#1a1b26", bg = c.blue, bold = true }
        hl.PmenuSbar = { bg = "#414560" }
        hl.PmenuThumb = { bg = c.blue }

        -- 折り畳み
        hl.Folded = { fg = "#b4bef0", bg = "#414560" }
        hl.FoldColumn = { fg = "#a9b1d6" }

        -- ウィンドウ区切り線
        hl.WinSeparator = { fg = "#7078a5" }

        -- Diagnostic (仮想テキスト)
        hl.DiagnosticVirtualTextError = { fg = "#ffa0aa", bg = "#4d2d3e" }
        hl.DiagnosticVirtualTextWarn = { fg = "#ffbc98", bg = "#4d3e30" }
        hl.DiagnosticVirtualTextInfo = { fg = "#a8e2ff", bg = "#2e4260" }
        hl.DiagnosticVirtualTextHint = { fg = "#88eadb", bg = "#2e4848" }

        -- Diff
        hl.DiffAdd = { bg = "#2e4d42" }
        hl.DiffChange = { bg = "#2e4260" }
        hl.DiffDelete = { bg = "#4d2d3e" }
        hl.DiffText = { bg = "#4575aa" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
