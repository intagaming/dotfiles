return {
    'Exafunction/codeium.vim',
    cond = not vim.g.vscode,
    config = function()
        vim.g.codeium_no_map_tab = 1
        vim.keymap.set('i', '<M-l>', function() return vim.fn['codeium#Accept']() end, { expr = true })
    end
}
