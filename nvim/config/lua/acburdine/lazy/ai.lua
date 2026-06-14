return {
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  -- {
  --   "copilotlsp-nvim/copilot-lsp",
  --   init = function()
  --     vim.g.copilot_nes_debounce = 500
  --     vim.lsp.enable("copilot_ls")
  --     vim.keymap.set("n", "<tab>", function()
  --       -- Try to jump to the start of the suggestion edit.
  --       -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
  --       local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
  --         or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
  --     end)
  --   end,
  -- },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {},
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },

  --   config = function()
  --     require("codecompanion").setup({
  --       strategies = {
  --         chat = {
  --           adapter = "copilot",
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
    },
    config = function()
      require("avante").setup({
        provider = "copilot",
        behavior = {
          auto_suggestions = false,
        },
        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ""
        end,
        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
        -- disable these in favor of ones from mcphub
        disabled_tools = {
          "list_files",
          "search_files",
          "read_file",
          "create_file",
          "rename_file",
          "delete_file",
          "create_dir",
          "rename_dir",
          "delete_dir",
          "bash",
        },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup({
        config = vim.fn.expand("~/.config/mcphub/servers.json"),
        workspace = {
          enabled = true,
          look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" },
          reload_on_dir_changed = true,
          port_range = { min = 40000, max = 41000 },
          get_port = nil,
        },

        auto_approve = false,
        auto_toggle_mcp_servers = true,
        extensions = {
          avante = {
            make_slash_commands = true,
          },
        },
      })
    end,
  },
}
