return {
    'nvim-lualine/lualine.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'vuki656/package-info.nvim' },
    config = function()
        -- local function codeium()
        --     return "🪄" .. vim.fn['codeium#GetStatusString']()
        -- end

        local package_info = require("package-info")
        local function packageinfo()
            return package_info.get_status()
        end

        require('lualine').setup {
            options = {
                icons_enabled = false,
                section_separators = '',
                component_separators = ''
            },
            sections = {
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_c = { 'filename', packageinfo },
            }
        }
    end
}
