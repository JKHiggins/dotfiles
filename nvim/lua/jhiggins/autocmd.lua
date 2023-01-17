vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[exe 'norm m`' | %s/\s\+$//e | norm g``]],
})
