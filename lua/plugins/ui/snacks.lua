return {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true, timeout = 6500 },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
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
