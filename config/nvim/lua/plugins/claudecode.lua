return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = function()
      local cols = vim.o.columns
      local lines = vim.o.lines
      -- 縦型ディスプレイ判定: 比率が1.5未満なら縦型とみなす
      -- (文字セルは縦長なので、縦型でも columns > lines になる)
      local is_vertical = cols / lines < 1.5
      if is_vertical then
        return {
          terminal = {
            provider = "snacks",
            snacks_win_opts = {
              position = "bottom",
              height = 0.30,
            },
          },
        }
      else
        return {
          terminal = {
            split_side = "right",
            split_width_percentage = 0.40,
            provider = "snacks",
          },
        }
      end
    end,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    },
  },
}
