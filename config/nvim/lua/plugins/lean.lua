return {
  {
    "Julian/lean.nvim",
    -- ft do "lean" 未検出の時点でロードされないため、ファイルパターンのeventで読み込む
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- lean パーサは auto_install で自動取得
    },
    -- setup()経由(opts)は非推奨のため、READMEどおり vim.g.lean_config で設定する
    init = function()
      vim.g.lean_config = { mappings = true }
    end,
  },
}
