-- Leader key
vim.g.mapleader = " "

-- 折り返し時に表示行単位で移動
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })

-- ESC連打でハイライト解除
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

-- ターミナルモードからの脱出
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", { noremap = true, silent = true })
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", { noremap = true, silent = true })
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", { noremap = true, silent = true })
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", { noremap = true, silent = true })

-- Todo.md タスク管理
vim.keymap.set("n", "<leader>th", ":edit ~/todo.md<CR>", { noremap = true, silent = true, desc = "Open home todo.md" })
vim.keymap.set("n", "<leader>tp", ":edit todo.md<CR>", { noremap = true, silent = true, desc = "Open project todo.md" })

vim.keymap.set("n", "<leader>tt", function()
  local line = vim.api.nvim_get_current_line()
  if line:match("%- %[ %]") then
    line = line:gsub("%- %[ %]", "- [x]", 1)
  elseif line:match("%- %[x%]") then
    line = line:gsub("%- %[x%]", "- [ ]", 1)
  end
  vim.api.nvim_set_current_line(line)
end, { noremap = true, silent = true, desc = "Toggle todo checkbox" })

vim.keymap.set("n", "<leader>tn", function()
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^(%s*)") or ""
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(row, indent .. "- [ ] ")
  vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
  vim.cmd("startinsert!")
end, { noremap = true, silent = true, desc = "Create new todo" })
