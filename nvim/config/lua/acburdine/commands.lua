-- because I fat-finger things all the time
vim.api.nvim_create_user_command("W", function() vim.cmd("w") end, {})
