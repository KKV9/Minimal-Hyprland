require "nvchad.options"

-- Define patterns and their corresponding filetypes in a table
local filetypes = {
  { pattern = ".*/hypr/.*%.conf", filetype = "hyprlang" },
  { pattern = ".*/waybar/config", filetype = "json" },
  { pattern = ".*/mako/config", filetype = "dosini" },
  { pattern = ".*/gtk2.base", filetype = "gtkrc" },
  { pattern = ".*/kdeglobals.base", filetype = "dosini" }
}

-- Loop through the table and add file type associations
for _, entry in ipairs(filetypes) do
  vim.filetype.add({
    pattern = { [entry.pattern] = entry.filetype }
  })
end
