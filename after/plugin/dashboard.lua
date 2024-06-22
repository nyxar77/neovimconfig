local dashboard = require('dashboard');

dashboard.setup({
    theme = 'hyper', --  theme is doom and hyper default is hyper
    config = {
        header = {
    [[                                   ]],
    [[          ▀████▀▄▄              ▄█ ]],
    [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
    [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
    [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
    [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
    [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
    [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
    [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
    [[   █   █  █      ▄▄           ▄▀   ]],
        },

        shortcut = {
            { icon = '󰊳 ', desc = 'Update', group = '@property', action = 'Lazy update', key = 'u' },
            {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Files',
                group = 'Label',
                action = 'Telescope find_files',
                key = 'f',
            },
            {
                icon = '', -- GitHub icon
                desc = 'GitHub',
                group = '@property',
                action = 'Open GitHub acc',
                key = 'g',
                link = 'https://github.com/fe2-Nyxar',
            },
            {
                desc = ' Apps',
                group = 'DiagnosticHint',
                action = 'Telescope app',
                key = 'a',
            },
            {
                desc = ' dotfiles',
                group = 'Number',
                action = 'Telescope dotfiles',
                key = 'd',
            },
            },
    },
    hide = {
        statusline= false,    -- hide statusline default is true
        tabline = false,       -- hide the tabline
        winbar = false,        -- hide winbar
    },
    disable_move = true,
})

