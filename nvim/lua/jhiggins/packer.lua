-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Install Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
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
    use('pixelastic/vim-undodir-tree')

    -- Git stuff
    use('tpope/vim-fugitive')

    -- Install a snippets engine
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })

    -- Setup the LSP
    use {
        'neovim/nvim-lspconfig',
        requires = {
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

    -- Use Mason to manage LSP servers
    use {
        "mason-org/mason.nvim"
    }

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

    -- Popup modals
    use 'rcarriga/nvim-notify'

    -- Snippets
    use {
        "chrisgrieser/nvim-scissors",
        dependencies = "nvim-telescope/telescope.nvim", -- optional
        config = function()
            require("scissors").setup({
                snippetDir = "~/.config/nvim/snippets",
            })
        end
    }

    -- Testing
    use { "nvim-neotest/nvim-nio" }

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

    -- Note tracking
    use {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    }

    -- Code searching
    use {
        "ibhagwan/fzf-lua",
        requires = { "nvim-tree/nvim-web-devicons" }
    }

    use {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
    }

    -- ChatGPT

    use {
        "jackMort/ChatGPT.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope.nvim"
        }
    }

end)
