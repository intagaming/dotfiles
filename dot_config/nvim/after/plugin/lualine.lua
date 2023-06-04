local function codeium()
    return "🪄" .. vim.fn['codeium#GetStatusString']()
end

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
        lualine_x = { codeium, 'encoding', 'fileformat', 'filetype' },
        lualine_c = {'filename', packageinfo},
    }
}
