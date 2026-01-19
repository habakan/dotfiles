-- 基本設定
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.showcmd = true

-- 見た目
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both" -- 行番号とスクリーンライン両方をハイライト
vim.opt.virtualedit = "onemore"
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.laststatus = 2
vim.opt.wildmode = { "list", "longest" }
vim.opt.termguicolors = true

-- Tab設定
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- 検索設定
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true

-- クリップボード連携
vim.opt.clipboard = "unnamedplus"
