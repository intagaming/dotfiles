if vim.g.vscode then return end

-- cmp setup
local lsp_zero_formatter = function(entry, item)
    local short_name = {
        nvim_lsp = 'LSP',
        nvim_lua = 'nvim'
    }

    local menu_name = short_name[entry.source.name] or entry.source.name

    item.menu = string.format('[%s]', menu_name)
    return item
end
local tailwind_color = function(entry, vim_item) -- for tailwind css autocomplete
    if vim_item.kind == 'Color' and entry.completion_item.documentation then
        local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
        if r then
            local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
            local group = 'Tw_' .. color
            if vim.fn.hlID(group) < 1 then
                vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
            end
            vim_item.kind = "■" -- or "⬤" or anything
            vim_item.kind_hl_group = group
            return vim_item
        end
    end
    -- vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. vim_item.kind) or vim_item.kind
    -- or just show the icon
    -- vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
    return vim_item
end

local luasnip = require("luasnip")
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    formatting = {
        format = function(entry, item)
            lsp_zero_formatter(entry, item)
            tailwind_color(entry, item)
            return item
        end,
    }
})

luasnip.setup({
    region_check_events = "CursorMoved",
    delete_check_events = "TextChanged,InsertLeave",
})

-- require("luasnip.loaders.from_vscode").lazy_load()

-- Border
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

-- LSP setup
local lspconfig = require('lspconfig')

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
-- Thanks jasonlyu123 @ https://github.com/sveltejs/language-tools/issues/2008#issuecomment-1987497624
lsp_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
lsp_capabilities.textDocument.completion = require('cmp_nvim_lsp').default_capabilities().textDocument.completion

local util = require 'vim.lsp.util'
local function in_dictionary(val, dict)
    return dict[val]
end
-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua
local function range_from_selection(bufnr, mode)
    local start = vim.fn.getpos('v')
    local end_ = vim.fn.getpos('.')
    local start_row = start[2]
    local start_col = start[3]
    local end_row = end_[2]
    local end_col = end_[3]

    if start_row == end_row and end_col < start_col then
        end_col, start_col = start_col, end_col
    elseif end_row < start_row then
        start_row, end_row = end_row, start_row
        start_col, end_col = end_col, start_col
    end
    if mode == 'V' then
        start_col = 1
        local lines = vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
        end_col = #lines[1]
    end
    return {
        ['start'] = { start_row, start_col - 1 },
        ['end'] = { end_row, end_col - 1 },
    }
end
local lsp_attach = (function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- local makeLspRequester = function(method, params, fallback, callback)
    --     callback = callback or nil
    --     if in_dictionary(vim.bo[bufnr].filetype, { typescript = true, typescriptreact = true,
    --             javascript = true, javascriptreact = true, ["javascript.jsx"] = true,
    --             ["typescript.tsx"] = true
    --         }) then
    --         for _, active_client in pairs(vim.lsp.get_active_clients()) do
    --             if active_client.name ~= "astro" and active_client.supports_method(method) then
    --                 active_client.request(method, params, callback, bufnr)
    --             end
    --         end
    --     else
    --         fallback()
    --     end
    -- end

    vim.keymap.set('n', 'gd', function()
        vim.lsp.buf.definition()
        -- local params = util.make_position_params()
        -- makeLspRequester('textDocument/definition', params, vim.lsp.buf.definition)
    end, opts)

    vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover()
        -- local params = util.make_position_params()
        -- makeLspRequester('textDocument/hover', params, vim.lsp.buf.hover)
    end, opts)

    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

    vim.keymap.set('n', 'gr', function()
        vim.lsp.buf.references()
        -- local params = util.make_position_params()
        -- params.context = {
        --     includeDeclaration = true,
        -- }
        -- makeLspRequester('textDocument/references', params, vim.lsp.buf.references)
    end, opts)

    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

    vim.keymap.set('i', '<C-h>', function()
        vim.lsp.buf.signature_help()
        -- local params = util.make_position_params()
        -- makeLspRequester('textDocument/signatureHelp', params, vim.lsp.buf.signature_help)
    end, opts)
end)

local handlers = {
    function(server_name)
        lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
        })
    end,

    ["tailwindcss"] = function()
        lspconfig.tailwindcss.setup({
            on_attach = function(client, bufnr)
                lsp_attach(client, bufnr)
                -- vim.opt.wrap = true
            end,
            capabilities = lsp_capabilities,
            init_options = {
                userLanguages = {
                    elixir = "phoenix-heex",
                    heex = "phoenix-heex",
                },
            },
            settings = {
                tailwindCSS = {
                    experimental = {
                        classRegex = {
                            { "cva\\(([^)]*)\\)",
                                "[\"'`]([^\"'`]*).*?[\"'`]" },
                            { "class:list=\\{([^}]*)\\}",
                                "[\"'`]([^\"'`]*).*?[\"'`]" },
                            { "clsx\\(([^)]*)\\)",
                                "[\"'`]([^\"'`]*).*?[\"'`]" },
                        },
                    },
                },
            },
        })
    end,

    ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }
    end,

    ["jsonls"] = function()
        lspconfig.jsonls.setup {
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            },
        }
    end,

    ["tsserver"] = function()
        require("typescript").setup({
            server = {
                init_options = {
                    preferences = {
                        importModuleSpecifierPreference = "non-relative",
                    }
                },
                on_attach = function(client, bufnr)
                    lsp_attach(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                end,
                capabilities = lsp_capabilities,
            }
        })
    end,

    ["astro"] = function()
        lspconfig.astro.setup {
            -- filetypes = { "astro", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
            --     "typescript.tsx" },
            on_attach = function(client, bufnr)
                lsp_attach(client, bufnr)
                -- local old_get_active_clients = vim.lsp.get_active_clients
                -- vim.lsp.get_active_clients = function(filter)
                --     local result = old_get_active_clients(filter)
                --
                --     local bufnr2 = vim.api.nvim_get_current_buf()
                --     if in_dictionary(vim.bo[bufnr2].filetype, { typescript = true, typescriptreact = true }) then
                --         local found_key = nil
                --         for key, active_client in pairs(result) do
                --             if active_client.name == "astro" then
                --                 found_key = key
                --                 break
                --             end
                --         end
                --         if found_key ~= nil then
                --             table.remove(result, found_key)
                --         end
                --     end
                --     return result
                -- end
            end,

            capabilities = lsp_capabilities,
            settings = {
                typescript = {
                    preferences = {
                        importModuleSpecifier = "non-relative"
                    }
                }
            },
        }
    end,

    ["eslint"] = function()
        lspconfig.eslint.setup {
            on_attach = function(client, bufnr)
                lsp_attach(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>e", "<cmd>EslintFixAll<CR>", opts)
            end,
            capabilities = lsp_capabilities,
        }
    end,
}

require('mason').setup()
require('mason-lspconfig').setup({ handlers = handlers })

vim.opt.signcolumn = 'yes'
vim.diagnostic.config({
    virtual_text = true
})
-- vim.lsp.set_log_level("debug")
