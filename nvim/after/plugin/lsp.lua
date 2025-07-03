require("mason").setup()
local lspconfig = require("lspconfig")

vim.lsp.config('*', {
    on_attach = function(_, bufnr)
        -- we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
        nmap('gI', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
        nmap('<leader>ds', function() Snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')
        nmap('<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
    end,
    offset_encoding='utf-8',
})

vim.lsp.config('pyright', {
    on_attach = vim.lsp.config['*'].on_attach,
    settings = {
        ['pyright'] = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        ['python'] = {
            analysis = {
                typeCheckingMode = "basic"
            }
        }
    },
    root_markers = { '.git' },
})

vim.lsp.config('ruff', {
    on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            args = {},
        }
    }
})

lspconfig.jsonls.setup({})

local omnisharp_bin = "/home/jhiggins/.local/omnisharp/OmniSharp"

lspconfig.omnisharp.setup({
    on_attach = function(client, bufnr)
        if client.name == "omnisharp" then
            client.server_capabilities.semanticTokensProvider = {
                full = vim.empty_dict(),
                legend = {
                    tokenModifiers = { "static_symbol" },
                    tokenTypes = {
                        "comment",
                        "excluded_code",
                        "identifier",
                        "keyword",
                        "keyword_control",
                        "number",
                        "operator",
                        "operator_overloaded",
                        "preprocessor_keyword",
                        "string",
                        "whitespace",
                        "text",
                        "static_symbol",
                        "preprocessor_text",
                        "punctuation",
                        "string_verbatim",
                        "string_escape_character",
                        "class_name",
                        "delegate_name",
                        "enum_name",
                        "interface_name",
                        "module_name",
                        "struct_name",
                        "type_parameter_name",
                        "field_name",
                        "enum_member_name",
                        "constant_name",
                        "local_name",
                        "parameter_name",
                        "method_name",
                        "extension_method_name",
                        "property_name",
                        "event_name",
                        "namespace_name",
                        "label_name",
                        "xml_doc_comment_attribute_name",
                        "xml_doc_comment_attribute_quotes",
                        "xml_doc_comment_attribute_value",
                        "xml_doc_comment_cdata_section",
                        "xml_doc_comment_comment",
                        "xml_doc_comment_delimiter",
                        "xml_doc_comment_entity_reference",
                        "xml_doc_comment_name",
                        "xml_doc_comment_processing_instruction",
                        "xml_doc_comment_text",
                        "xml_literal_attribute_name",
                        "xml_literal_attribute_quotes",
                        "xml_literal_attribute_value",
                        "xml_literal_cdata_section",
                        "xml_literal_comment",
                        "xml_literal_delimiter",
                        "xml_literal_embedded_expression",
                        "xml_literal_entity_reference",
                        "xml_literal_name",
                        "xml_literal_processing_instruction",
                        "xml_literal_text",
                        "regex_comment",
                        "regex_character_class",
                        "regex_anchor",
                        "regex_quantifier",
                        "regex_grouping",
                        "regex_alternation",
                        "regex_text",
                        "regex_self_escaped_character",
                        "regex_other_escape",
                    },
                },
                range = true,
            }
        end
    end,
    cmd = { omnisharp_bin },
})

lspconfig.terraformls.setup({
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.tf", "*.tfvars" },
            callback = vim.lsp.buf.format(),
        })
    end
})

vim.lsp.enable('ruff')
vim.lsp.enable('pyright')
vim.lsp.enable('lua_ls')
vim.lsp.enable('bash_ls')
vim.lsp.enable('terraformls')
vim.lsp.enable('jsonls')
vim.lsp.enable('omnisharp')


local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'

-- Configure the CMP
local cmp_config = {
    window = {
        completion = { -- no border;  thin-style scrollbar
            scrollbar = '',
        },

        documentation = { -- no border; native-style scrollbar
            border = nil,
            scrollbar = '',
            -- other options
        },
    },

    preselect = cmp.PreselectMode.None,
    completion = {
        completeopt = "menu,menuone,noinsert",
    },

    mapping = {
        ["<CR>"] = cmp.config.disable,
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-y>"] = cmp.mapping.confirm(),
        ["<C-l>"] = cmp.mapping(function(fallback)
            if luasnip and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function(fallback)
            if luasnip and luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    sources = cmp.config.sources({
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
    }, {
        { name = "buffer" },
    }),

    formatting = {
        format = lspkind.cmp_format({
            windowmode = 'symbol_text',
            maxwidth = 100,
            ellipsis_char = '...',
            symbol_map = { Copilot = "" }
        }),
    }
}

cmp.setup(cmp_config)
