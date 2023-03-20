function set_hl(group, val)
  vim.api.nvim_set_hl(0, group, val)
end

set_hl('FloatBorder', { bg = "NONE" })
set_hl('NormalFloat', { bg = "NONE" })
set_hl('TelescopeNormal', { bg = "NONE" })
set_hl('TelescopeBorder', { bg = "NONE" })
