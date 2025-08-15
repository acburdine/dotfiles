return {
  "stevearc/conform.nvim",
  opts = {},
  config = function()
    local prettier = { "prettierd", "prettier", stop_after_first = true }

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },

        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        css = prettier,
        graphql = prettier,
        html = prettier,
        json = prettier,
        less = prettier,
        markdown = prettier,
        scss = prettier,
        yaml = prettier,

        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        nginx = { "nginxfmt" },
        fish = { "fish_indent" },
      },

      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
    })
  end,
}
