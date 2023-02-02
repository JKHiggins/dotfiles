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
        requires = { {'nvim-lua/plenary.nvim'} }
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

    -- Install colorscheme 'rose-pine'
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    -- Give us syntax in real time
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
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
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    -- Change behavior of signature popups
    use {
        "ray-x/lsp_signature.nvim",
    }

    -- Convient character wrap changing
    use {
        "tpope/vim-surround",
    }
end)
