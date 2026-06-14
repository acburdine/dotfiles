return {
  "stevearc/conform.nvim",
  opts = {},
  config = function()
    local prettier = { "prettierd", "prettier", stop_after_first = true }
    local prettier_filetypes = {
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
      css = true,
      graphql = true,
      html = true,
      json = true,
      less = true,
      markdown = true,
      scss = true,
      yaml = true,
    }
    local has_local_prettier = function(ctx)
      local start_path = (ctx and ctx.dirname) or vim.uv.cwd()
      local git_root = vim.fs.root(start_path, ".git")
      local stop = git_root and vim.fs.dirname(git_root) or nil

      return vim.fs.find("node_modules/prettier", {
        path = start_path,
        upward = true,
        stop = stop,
        type = "directory",
      })[1] ~= nil
    end

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        python = { "black" },

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
      formatters = {
        prettierd = {
          condition = function(_, ctx)
            return has_local_prettier(ctx)
          end,
        },
        prettier = {
          condition = function(_, ctx)
            return has_local_prettier(ctx)
          end,
        },
      },

      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype

        if prettier_filetypes[ft] then
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local dirname = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()

          if not has_local_prettier({ dirname = dirname }) then
            return {
              lsp_format = "never",
              timeout_ms = 500,
            }
          end
        end

        return {
          lsp_format = "fallback",
          timeout_ms = 500,
        }
      end,
    })
  end,
}
