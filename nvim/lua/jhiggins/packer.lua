-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Install Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Extend the user input/select windows
    use {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup {
                input = { relative = "editor" },
                select = {
                    backend = { "telescope", "fzf", "builtin" },
                },
            }
        end,
        disable = false,
    }

    -- Install colorscheme 'catppuccin'
    use({
        'catppuccin/nvim',
        as = 'catppuccin',
    })

    -- Give us syntax in real time
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')

    -- Harpoon some frequent files
    use('theprimeagen/harpoon')

    -- A nice undotree that maintains undo history
    use('mbbill/undotree')

    -- Git stuff
    use('tpope/vim-fugitive')

    -- Setup the LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },

            -- LSP kind, icon support
            { 'onsails/lspkind.nvim' },
        }
    }

    -- Change behavior of signature popups
    use { "ray-x/lsp_signature.nvim" }

    -- Convient character wrap changing
    use { "tpope/vim-surround" }

    -- Block commenting
    use { "terrortylor/nvim-comment" }

    -- Expand motion repeating to include other movements
    use { "Houl/repmo-vim" }

    -- Install lualine to support having a powerline
    use {
        "nvim-lualine/lualine.nvim",
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }

    use 'rcarriga/nvim-notify'

    use {
        'kawre/leetcode.nvim',
        requires = {
            { "nvim-treesitter/nvim-treesitter" },
            { "nvim-telescope/telescope.nvim" },
            { "nvim-lua/plenary.nvim" }, -- required by telescope
            { "MunifTanjim/nui.nvim" },
            { "rcarriga/nvim-notify" },
            { "nvim-tree/nvim-web-devicons" },
        },
        build = ":TSUpdate html",
        config = function()
            require('leetcode').setup({
                domain = "com",
                arg = "leetcode.nvim",
                lang = "python",
                sql = "mysql",
                logging = true,
                console = {
                    size = {
                        width = "75%",
                        height = "75%",
                    },
                    dir = "row",
                },

                description = {
                    width = "40%",
                },
            })
        end
    }

    use {
        "chrisgrieser/nvim-scissors",
        dependencies = "nvim-telescope/telescope.nvim", -- optional
        config = function()
            require("scissors").setup({
                snippetDir = "~/.config/nvim/snippets",
            })
        end,
    }

    use {
        "nvim-neotest/neotest",
        config = function()
            require("jhiggins.config.neotest").post()
        end,
        requires = {
            { "nvim-neotest/neotest-python" },
            { "nvim-neotest/neotest-plenary" },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "antoinemadec/FixCursorHold.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
            { "nvim-neotest/neotest-python" },
            {
                "mfussenegger/nvim-dap",
                config = function()
                    require("jhiggins.config.dap").post()
                end,
            },
            { "mfussenegger/nvim-dap-python" },
            { "rcarriga/nvim-dap-ui" }
        }
    }
end)
