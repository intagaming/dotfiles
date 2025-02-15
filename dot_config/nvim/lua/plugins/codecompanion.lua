return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        strategies = {
            chat = {
                adapter = "openrouter",
            },
            inline = {
                adapter = "openrouter",
            },
        },
        adapters = {
            openrouter = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    name = "OpenRouter",
                    env = {
                        url = "https://openrouter.ai/api",
                        api_key = "CODECOMPANION_OPENROUTER_API_KEY",
                        chat_url = "/v1/chat/completions",
                    },
                    schema = {
                        model = {
                            default = "deepseek/deepseek-chat",
                        },
                    },
                })
            end,
        },
    },
    config = function(_, opts)
        require("codecompanion").setup(opts)
        vim.keymap.set({ "n", "v" }, "<Leader>cc", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
        vim.keymap.set({ "n", "v" }, "<C-M-i>", "<cmd>CodeCompanionChat Toggle<cr>",
            { noremap = true, silent = true })
        vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    end
}
