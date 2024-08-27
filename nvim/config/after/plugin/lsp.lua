local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = true,
})

local cmp = require("cmp")
local cmp_select = {behavor = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-v>'] = cmp.mapping.confirm({ select = true }),
  ['<C-space>'] = cmp.mapping.complete(),
})

local cmp_config = lsp.defaults.cmp_config({})

cmp.setup(cmp_config)

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = {
    {name = 'copilot'},
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { text = "" } })

lsp.on_attach(function(_, bufnr)
  local opts = {buffer = bufnr, remap = false}
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.ensure_installed({
  "tsserver",
  "eslint",
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "tailwindcss",
  "dockerls",
  "graphql",
  "html",
  -- "remark_ls",
  "terraformls",
  "yamlls",
})

lsp.nvim_workspace()

-- null-ls setup
local null_ls = require("null-ls")

local format_denylist = {
  jsonls = true,
  tsserver = true,
  stylelint_lsp = true,
}

local format_denylist_by_filetype = {
  lua = {
    lua_ls = true,
  },
  markdown = {
    html = true,
  },
}

local function get_filter(bufnr)
  return function(client)
    if format_denylist[client.name] then
      return false
    end

    local filetype = vim.api.nvim_buf_get_option(bufnr or 0, "filetype")
    local denylist_for_filetype = format_denylist_by_filetype[filetype]
    if not denylist_for_filetype then
      return true
    end

    return not denylist_for_filetype[client.name]
  end
end

local function format(options)
  options = options or {}
  options.bufnr = options.bufnr or vim.api.nvim_get_current_buf()
  options.filter = get_filter(options.bufnr)
  vim.lsp.buf.format(options)
end

local null_opts = lsp.build_options("null-ls", {
  on_attach = function (client, bufnr)
    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })

    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = group,
        callback = function()
          format({ bufnr = bufnr, async = false })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end
})

null_ls.setup({
  on_attach = null_opts.on_attach,
  sources = {
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.hclfmt,
    null_ls.builtins.formatting.nginx_beautifier,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.scalafmt,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.yamlfmt,
  }
})

require('lspconfig').yamlls.setup({
  settings = {
    yaml = {
      kubernetes = "yaml/**/*.yaml"
    }
  }
})

lsp.setup()
