vim.g.hidden_all = 0

function ToggleHiddenAll()
    if vim.g.hidden_all == 0
    then
        vim.g.hidden_all = 1
        vim.opt.ruler = false
        vim.opt.showmode = false
        vim.opt.laststatus = 0
        vim.opt.showcmd = false
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.cmd("hi NonText guifg=bg")
    else
        vim.g.hidden_all = 0
        vim.opt.ruler = true
        vim.opt.showmode = true
        vim.opt.laststatus = 2
        vim.opt.showcmd = true
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.cmd("hi NonText guifg=fg")
    end
end
