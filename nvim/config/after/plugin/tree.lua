-- NOTE: this should not be required in init.lua, it's required
-- during lazy plugin setup
require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  sort_by = "case_sensitive",
  view = {
    width = 30,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "O", action = "cd" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not no_name and not directory then
      return
    end

    if directory then
      vim.cmd.cd(data.file)
    end

    -- open the tree
    require("nvim-tree.api").tree.open()
  end
})

vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle)
