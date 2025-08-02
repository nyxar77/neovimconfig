return {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true, timeout = 8000 },
        quickfile = { enabled = true },
        scope = { enabled = true },
        -- scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
    --[[ config = function()
        require "snacks".setup {
            header = {
                "                                   ",
                "          ▀████▀▄▄              ▄█ ",
                "            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ",
                "    ▄        █          ▀▀▀▀▄  ▄▀  ",
                "   ▄▀ ▀▄      ▀▄              ▀▄▀  ",
                "  ▄▀    █     █▀   ▄█▀▄      ▄█    ",
                "  ▀▄     ▀▄  █     ▀██▀     ██▄█   ",
                "   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ",
                "    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ",
                "   █   █  █      ▄▄           ▄▀   ",
            },
        }
    end ]]
}
