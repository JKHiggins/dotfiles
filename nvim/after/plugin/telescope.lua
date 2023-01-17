local builtin = require('telescope.builtin')

-- Find all project files ("project find")
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

-- Find only files in this git repo
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- Search for a file containing value ("project search")
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

