return {
    'Shatur/neovim-session-manager',
    config = function()
        local config = require('session_manager.config')
        require('session_manager').setup({
            autoload_mode = config.AutoloadMode.CurrentDir,
            autosave_ignore_buftypes = { "neo-tree" },
        })

        local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands

        vim.api.nvim_create_autocmd({ 'User' }, {
            pattern = "SessionLoadPost",
            group = config_group,
            callback = function()
                require 'neo-tree.sources.manager'.show('filesystem')
            end,
        })
    end
}
