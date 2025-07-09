vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', { desc = 'Get the hunk in the left' })
vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', { desc = 'Get the hunk in the right' })
