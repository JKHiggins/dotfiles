local ls = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

require("luasnip.loaders.from_vscode").lazy_load({
    paths = { "~/.config/nvim/snippets" }
})

ls.setup({
    history = true,

    -- Auto update on text changed
    updateevents = "TextChanged", "TextChangedI",


    enable_autosnippets = true,
})

vim.keymap.set({"i"}, "<C-K>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-L>", function()
    if ls.jumpable(1) then
        ls.jump(1)
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-H>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-J>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
