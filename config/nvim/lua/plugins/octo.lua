return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = {
      { "<leader>op", "<cmd>Octo pr list<cr>", desc = "Octo: PR list" },
      { "<leader>od", "<cmd>Octo pr diff<cr>", desc = "Octo: PR diff" },
      -- PR番号を入力してdiffを開く
      {
        "<leader>oP",
        function()
          local pr = vim.fn.input("PR number: ")
          if pr ~= "" then
            vim.cmd("Octo pr edit " .. pr)
            vim.cmd("Octo pr diff")
          end
        end,
        desc = "Octo: open PR by number + diff",
      },
    },
    config = function()
      require("octo").setup({
        picker = "telescope",
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    },
  },
}
