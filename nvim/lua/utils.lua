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

M.open_spectre = function(is_cur)
  local format = require("format")
  local sp = require("spectre")
  local su = require("spectre.utils")
  local opts = {}

  if is_cur then
    opts.path = vim.fn.fnameescape(vim.fn.expand("%:p:."))

    if vim.loop.os_uname().sysname == "Windows_NT" then
      opts.path = vim.fn.substitute(opts.path, "\\", "/", "g")
    end
  end

  opts.search_text = vim.fn.escape(su.get_visual_selection(), "/\\")

  format.save_without_format()
  sp.open(opts)
end

return M
