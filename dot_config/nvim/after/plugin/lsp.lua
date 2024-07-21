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

local lsp_attach = require "an7/lsp_attach"

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
        -- Make the server aware of Neovim runtime files
        local workspace_library = vim.api.nvim_get_runtime_file("", true)
        -- Love2D support
        table.insert(workspace_library, "${3rd}/love2d/library")

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
                        library = workspace_library,
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

    ["astro"] = function()
        lspconfig.astro.setup {
            on_attach = lsp_attach,
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

    ["csharp_ls"] = function()
        lspconfig.csharp_ls.setup {
            on_init = function(client)
                local path = client.workspace_folders[1].name

                -- Configure projects with >= 2 solution files
                if string.find(path, 'slime-client-game', 1, true) ~= nil then
                    client.config.settings["csharp"].solution = path .. "/slime-client-game.sln"
                end

                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                return true
            end,
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = { csharp = { solution = "" } }
        }
    end,
}

require('mason').setup()
require('mason-lspconfig').setup({ handlers = handlers })

-- Godot LSP on Windows
lspconfig.gdscript.setup {
    on_attach = lsp_attach,
    capabilities = lsp_capabilities,
    cmd = { 'ncat', 'localhost', '6005' },
}

vim.opt.signcolumn = 'yes'
vim.diagnostic.config({
    virtual_text = true
})
-- vim.lsp.set_log_level("debug")
