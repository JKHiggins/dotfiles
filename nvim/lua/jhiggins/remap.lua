-- Set leader
vim.g.mapleader = " "

-- Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Write with just my thumb :D
vim.keymap.set("n", "<leader><enter>", vim.cmd.write)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep it centered when searching
vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "N", "nzzzv", { noremap = true, silent = true })

-- Paste over highlight without losing whats in buffer
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Copy to the clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Format the current buffer using LSP
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

-- Fix list stuff??
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Replace current word in buffer
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Set chmod +x on the current file without leaving vim
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Close all but current window
vim.keymap.set("n", "<leader>oc", "<cmd>only<CR>")

-- Insert a timestamp at the current cursor location
vim.keymap.set("n", "<leader>ts", "i<C-R>=strftime('%FT%TZ')<CR> - ")

-- Insert a timestamp below current line
vim.keymap.set("n", "<leader>ots", "o<Esc>o<Esc>i<C-R>=strftime('%FT%TZ')<CR> - ")

-- Insert a timestamp above current line
vim.keymap.set("n", "<leader>Ots", "O<Esc>O<Esc>i<C-R>=strftime('%FT%TZ')<CR> - ")
