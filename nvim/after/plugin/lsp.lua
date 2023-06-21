local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'lua_ls',
  'pylsp',
  'ruby_ls',
  'omnisharp',
  'terraformls',
  'bashls',
  'marksman'
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
end)

local omnisharp_bin = "/home/jhiggins/.local/omnisharp/OmniSharp"

lsp.configure('omnisharp', {
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

lsp.configure('terraformls', {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.tf", "*.tfvars" },
      callback = vim.lsp.buf.format(),
    })
  end
})

lsp.setup()

local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'
local cmp_config = lsp.defaults.cmp_config({
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

    mapping = cmp.mapping.preset.insert({
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<Tab>"] = cmp.mapping.confirm({
        -- this is the important line
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
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
    }),

    sources = cmp.config.sources({
      -- { name = "copilot", group_index = 2 },
      { name = "nvim_lsp" },
      { name = "luasnip" },             -- For luasnip users.
    }, {
      { name = "buffer" },
    }),

    formatting = {
      format = lspkind.cmp_format({
        windowmode = 'symbol_text',
        maxwidth = 80,
        ellipsis_char = '...',
      }),
    }
  })

  cmp.setup(cmp_config)
