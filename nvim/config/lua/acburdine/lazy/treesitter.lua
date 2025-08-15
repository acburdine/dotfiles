return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "javascript", "typescript", "c", "lua", "vim",
          "terraform", "hcl", "bash" },
        sync_install = false,
        auto_install = true,

        highlight = {
          enable = true,

          additional_vim_regex_highlighting = { "markdown" },
        },

        endwise = {
          enable = true,
        }
      }

      local opt = vim.opt;
      opt.foldlevel = 20
      opt.foldmethod = "expr"
      opt.foldexpr = "nvim_treesitter#foldexpr()"
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" }
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    after = "nvim-treesitter",
    config = function()
      require 'treesitter-context'.setup {
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false,      -- Enable multiwindow support.
        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded.
        mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20,     -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end
  },
  {
    "windwp/nvim-autopairs",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup {
        enable = true
      }
    end
  },
  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "InsertEnter"
  },
}
