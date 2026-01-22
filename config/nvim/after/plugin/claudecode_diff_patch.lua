-- claudecode.nvim diff.lua patch
-- diff preview時にsnacks_win_opts.positionを参照してターミナルレイアウトを決定する
-- (縦ディスプレイでposition="bottom"の場合、ターミナルを下に配置)

local function apply_patch()
  local ok, diff_module = pcall(require, "claudecode.diff")
  if not ok then
    return
  end

  -- _setup_blocking_diff関数のupvalueからdisplay_terminal_in_new_tabを探す
  local target_func = diff_module._setup_blocking_diff
  if not target_func then
    return
  end

  -- upvalueを探索してdisplay_terminal_in_new_tabを見つける
  local upvalue_index = nil
  local original_func = nil
  local config_index = nil
  local config_value = nil

  local i = 1
  while true do
    local name, value = debug.getupvalue(target_func, i)
    if name == nil then
      break
    end
    if name == "display_terminal_in_new_tab" then
      upvalue_index = i
      original_func = value
    end
    if name == "config" then
      config_index = i
      config_value = value
    end
    i = i + 1
  end

  if not upvalue_index or not original_func then
    vim.notify("claudecode_diff_patch: could not find display_terminal_in_new_tab", vim.log.levels.WARN)
    return
  end

  -- 必要なヘルパー関数のupvalueも取得
  local get_autocmd_group = nil
  local find_claudecode_terminal_window = nil
  local capture_window_options = nil
  local get_default_terminal_options = nil
  local apply_window_options = nil

  i = 1
  while true do
    local name, value = debug.getupvalue(target_func, i)
    if name == nil then
      break
    end
    if name == "get_autocmd_group" then
      get_autocmd_group = value
    elseif name == "find_claudecode_terminal_window" then
      find_claudecode_terminal_window = value
    elseif name == "capture_window_options" then
      capture_window_options = value
    elseif name == "get_default_terminal_options" then
      get_default_terminal_options = value
    elseif name == "apply_window_options" then
      apply_window_options = value
    end
    i = i + 1
  end

  -- original_funcからもupvalueを取得（target_funcにない場合）
  if not get_autocmd_group or not capture_window_options or not get_default_terminal_options or not apply_window_options then
    i = 1
    while true do
      local name, value = debug.getupvalue(original_func, i)
      if name == nil then
        break
      end
      if name == "get_autocmd_group" and not get_autocmd_group then
        get_autocmd_group = value
      elseif name == "find_claudecode_terminal_window" and not find_claudecode_terminal_window then
        find_claudecode_terminal_window = value
      elseif name == "capture_window_options" and not capture_window_options then
        capture_window_options = value
      elseif name == "get_default_terminal_options" and not get_default_terminal_options then
        get_default_terminal_options = value
      elseif name == "apply_window_options" and not apply_window_options then
        apply_window_options = value
      elseif name == "config" and not config_value then
        config_value = value
      end
      i = i + 1
    end
  end

  -- パッチ適用済みのdisplay_terminal_in_new_tab関数
  local patched_display_terminal_in_new_tab = function()
    local original_tab = vim.api.nvim_get_current_tabpage()

    local terminal_ok, terminal_module = pcall(require, "claudecode.terminal")
    if not terminal_ok then
      vim.cmd("tabnew")
      local new_tab = vim.api.nvim_get_current_tabpage()
      return original_tab, nil, false, new_tab
    end

    local terminal_bufnr = terminal_module.get_active_terminal_bufnr()
    if not terminal_bufnr or not vim.api.nvim_buf_is_valid(terminal_bufnr) then
      vim.cmd("tabnew")
      local new_tab = vim.api.nvim_get_current_tabpage()
      return original_tab, nil, false, new_tab
    end

    local existing_terminal_win = find_claudecode_terminal_window and find_claudecode_terminal_window()
    local had_terminal_in_original = existing_terminal_win ~= nil
    local terminal_options
    if existing_terminal_win and capture_window_options then
      terminal_options = capture_window_options(existing_terminal_win)
    elseif get_default_terminal_options then
      terminal_options = get_default_terminal_options()
    else
      terminal_options = {}
    end

    vim.cmd("tabnew")
    local new_tab = vim.api.nvim_get_current_tabpage()

    local initial_buf = vim.api.nvim_get_current_buf()
    local name_ok, initial_name = pcall(vim.api.nvim_buf_get_name, initial_buf)
    local mod_ok, initial_modified = pcall(vim.api.nvim_buf_get_option, initial_buf, "modified")
    local linecount_ok, initial_linecount = pcall(function()
      return vim.api.nvim_buf_line_count(initial_buf)
    end)
    if name_ok and mod_ok and linecount_ok then
      if (initial_name == nil or initial_name == "") and initial_modified == false and initial_linecount <= 1 then
        pcall(vim.api.nvim_buf_set_option, initial_buf, "bufhidden", "wipe")
      end
    end

    local terminal_config = config_value and config_value.terminal or {}
    local split_side = terminal_config.split_side or "right"
    local split_width = terminal_config.split_width_percentage or 0.30

    -- [PATCH] snacks_win_opts.positionを参照してsplit方向を決定
    local snacks_opts = terminal_config.snacks_win_opts or {}
    local position = snacks_opts.position
    local is_horizontal = position == "bottom" or position == "top"

    local hide_in_new_tab = false
    if config_value and config_value.diff_opts and type(config_value.diff_opts.hide_terminal_in_new_tab) == "boolean" then
      hide_in_new_tab = config_value.diff_opts.hide_terminal_in_new_tab
    end

    if hide_in_new_tab or not terminal_bufnr or not vim.api.nvim_buf_is_valid(terminal_bufnr) then
      return original_tab, nil, had_terminal_in_original, new_tab
    end

    -- [PATCH] 水平/垂直分割の切り替え
    if is_horizontal then
      vim.cmd("split")
    else
      vim.cmd("vsplit")
    end

    local terminal_win = vim.api.nvim_get_current_win()

    -- [PATCH] ウィンドウ位置の調整
    if is_horizontal then
      if position == "top" then
        vim.cmd("wincmd K")
      else
        vim.cmd("wincmd J")
      end
    else
      if split_side == "left" then
        vim.cmd("wincmd H")
      else
        vim.cmd("wincmd L")
      end
    end

    vim.api.nvim_win_set_buf(terminal_win, terminal_bufnr)

    if apply_window_options then
      apply_window_options(terminal_win, terminal_options)
    end

    if get_autocmd_group then
      vim.api.nvim_create_autocmd("BufEnter", {
        buffer = terminal_bufnr,
        group = get_autocmd_group(),
        callback = function()
          if vim.bo.buftype == "terminal" and vim.fn.mode() == "n" then
            vim.cmd("startinsert")
          end
        end,
        desc = "Auto-enter terminal mode when focusing Claude Code terminal",
      })
    end

    -- [PATCH] サイズ設定（水平/垂直で切り替え）
    if is_horizontal then
      local total_height = vim.o.lines
      local split_height = snacks_opts.height or 0.30
      local terminal_height = math.floor(total_height * split_height)
      vim.api.nvim_win_set_height(terminal_win, terminal_height)
    else
      local total_width = vim.o.columns
      local terminal_width = math.floor(total_width * split_width)
      vim.api.nvim_win_set_width(terminal_win, terminal_width)
    end

    -- [PATCH] フォーカスを元のウィンドウに戻す
    if is_horizontal then
      vim.cmd("wincmd " .. (position == "bottom" and "k" or "j"))
    else
      vim.cmd("wincmd " .. (split_side == "right" and "h" or "l"))
    end

    return original_tab, terminal_win, had_terminal_in_original, new_tab
  end

  -- upvalueを置き換え
  debug.setupvalue(target_func, upvalue_index, patched_display_terminal_in_new_tab)
end

-- プラグインのロード後に実行
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    vim.defer_fn(apply_patch, 100)
  end,
})

-- 既にロード済みの場合は即座に実行
if package.loaded["claudecode.diff"] then
  apply_patch()
end
