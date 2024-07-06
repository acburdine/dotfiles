local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons"},
  },
  {
    "nvim-telescope/telescope.nvim",
    version="^0.1.1",
    dependencies={"nvim-lua/plenary.nvim"}
  },
  {
    "joshdick/onedark.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    priority = 1000
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {"nvim-treesitter/nvim-treesitter"}
  },
  {
    "theprimeagen/harpoon",
    lazy = false,
    dependencies={"nvim-lua/plenary.nvim"}
  },
  {"acburdine/undotree"},
  {"tpope/vim-fugitive"},
  {"airblade/vim-gitgutter"},
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  },
  {"itchyny/lightline.vim"},
  {
    "windwp/nvim-autopairs",
    lazy = false,
    dependencies={"nvim-treesitter/nvim-treesitter"},
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup {
        check_ts = true
      }
      npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")
    end
  },
  {
    "windwp/nvim-ts-autotag",
    event="InsertEnter",
    dependencies={"nvim-treesitter/nvim-treesitter"},
    config = function()
      require("nvim-ts-autotag").setup {
        enable = true
      }
    end
  },
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies={"nvim-treesitter/nvim-treesitter"},
    event = "InsertEnter"
  },
  {"tpope/vim-eunuch"},
  {"editorconfig/editorconfig-vim"},
  {"jose-elias-alvarez/null-ls.nvim"},
  {"MunifTanjim/prettier.nvim"},
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
    end
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end
  },
  {
    "kkoomen/vim-doge",
    build = ':call doge#install()'
  },
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true
        }
      })
    end
  },
  {'isobit/vim-caddyfile'},
  {
    "ray-x/go.nvim",
    config = function()
      require("go").setup()
    end,
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()'
  }
})
