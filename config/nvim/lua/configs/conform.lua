local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    fish = { "fish_indent" },
    python = { "ruff_fix", "ruff_format" },
  },
}

require("conform").setup(options)
