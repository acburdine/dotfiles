-- miscellaneous nvim plugins
return {
  {
    "tpope/vim-fugitive",
    config = function ()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end
  },
  {"airblade/vim-gitgutter"},
  {"tpope/vim-eunuch"},
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    config = function()
      require("nvim-surround").setup()
    end
  },
}
