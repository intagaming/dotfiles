vim.keymap.set('n', '<leader>trf', function()
    local current_buf = vim.api.nvim_buf_get_name(0)

    vim.ui.input({
        prompt = "New path: ",
        default = current_buf,
    }, function(text)
        if text == nil or text == "" then return end

        local ok = require("typescript").renameFile(current_buf, text)
        if not ok then return end

        print("Renamed. Remember to :wa to save buffers after renaming!")
    end)
end)

vim.keymap.set('n', '<leader>ti', function() require("typescript").actions.addMissingImports() end)
vim.keymap.set('n', '<leader>tu', function() require("typescript").actions.removeUnused() end)
