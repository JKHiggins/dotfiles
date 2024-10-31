local builtin = require('telescope.builtin')

-- Find all project files ("project find")
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

-- Find only files in this git repo
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- Search for a file containing value ("project search")
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
    end,
})

local function filenameFirst(_, path)
    local tail = vim.fs.basename(path)
    local parent = vim.fs.dirname(path)
    if parent == "." then return tail end
    return string.format("%s\t\t%s", tail, parent)
end

require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "dsioTheme"
        },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--ignore-file',
            '.gitignore'
        },
        path_display = {
            "shorten"
        },
    },
    pickers = {
        find_files = {
            path_display = filenameFirst,
        },
        git_files = {
            path_display = filenameFirst,
        }
    }
}
