math.randomseed(os.time())

local M = {}

local SIZE_TYPES = { "", "K", "M", "G", "T", "P", "E", "Z" }

M.format_size = function(size)
  for _, v in ipairs(SIZE_TYPES) do
    local type_size = math.abs(size)
    if type_size < 1024.0 then
      if type_size > 9 then
        return string.format("%d%s", size, v)
      else
        return string.format("%.1f%s", size, v)
      end
    end
    size = size / 1024.0
  end
  return string.format("%.1f%s", size, "Y")
end

local YEAR = os.date("%Y")

M.format_time = function(sec)
  if YEAR ~= os.date("%Y", sec) then
    return os.date("%b %d  %Y", sec)
  end
  return os.date("%b %d %H:%M", sec)
end

local mode_perm_map = {
  ["0"] = "---",
  ["1"] = "--x",
  ["2"] = "-w-",
  ["3"] = "-wx",
  ["4"] = "r--",
  ["5"] = "r-x",
  ["6"] = "rw-",
  ["7"] = "rwx",
}

local mode_type_map = {
  ["directory"] = "d",
  ["link"] = "l",
}

M.format_mode = function(mode, type)
  local owner, group, other = string.format("%3o", mode):match("(.)(.)(.)$")
  local str = mode_type_map[type] or "-"
  str = str .. mode_perm_map[owner]
  str = str .. mode_perm_map[group]
  str = str .. mode_perm_map[other]
  return str
end

M.count_split = function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local split_count = 0

  for _, win in ipairs(wins) do
    local cfg = vim.api.nvim_win_get_config(win)
    -- TODO: is this correct?
    if cfg.relative == "" and cfg.external == false then
      split_count = split_count + 1
    end
  end

  return split_count
end

M.random_string = function(length, num, alpha, Alpha)
  local chars = {}
  if num then
    for i = 48, 57 do
      table.insert(chars, string.char(i))
    end
  end
  if alpha then
    for i = 97, 122 do
      table.insert(chars, string.char(i))
    end
  end
  if Alpha then
    for i = 65, 90 do
      table.insert(chars, string.char(i))
    end
  end
  local str = ""
  for _ = 1, length do
    str = str .. chars[math.random(#chars)]
  end
  return str
end

return M
