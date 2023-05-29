local function codeium()
    return "🪄" .. vim.fn['codeium#GetStatusString']()
end

require('lualine').setup {
    options = {
        icons_enabled = false,
        section_separators = '',
        component_separators = ''
    },
    sections = {
        lualine_x = { codeium, 'encoding', 'fileformat', 'filetype' },
    }
}
