require('nvim-tree').setup({
    disable_netrw = false,
    hijack_netrw  = false,
    update_cwd    = true,
    renderer = {
        icons = {
            show = {
                file        = true,
                folder      = true,
                folder_arrow = true,
                git         = true,
            },
        },
    },
    git = {
        enable = true,
    },
})
