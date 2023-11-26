require'nvim-treesitter.configs'.setup {
  ensure_installed = { "help", "javascript", "typescript", "c", "lua", "vim", "help", "terraform", "hcl" },
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  endwise = {
    enable = true,
  }
}

local opt = vim.opt;
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
