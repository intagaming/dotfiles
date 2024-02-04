return {
    'Shatur/neovim-session-manager',
    cond = not vim.g.vscode,
    config = function()
        local config = require('session_manager.config')
        require('session_manager').setup({
            autoload_mode = config.AutoloadMode.CurrentDir,
        })

        -- local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {})
        --
        -- vim.api.nvim_create_autocmd({ 'User' }, {
        --     pattern = "SessionLoadPost",
        --     group = config_group,
        --     callback = function()
        --         require 'neo-tree.sources.manager'.show('filesystem')
        --     end,
        -- })
    end
}
