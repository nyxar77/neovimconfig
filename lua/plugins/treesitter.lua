return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = 'main',
        event = "BufEnter",
        config = function()
            local treesitter = require "nvim-treesitter"
            local treesitter_config = require 'nvim-treesitter.config'
            local ensure_installed = {
                "zig",
                "lua",
                "luau",
                "javascript",
                "typescript",
                "c",
                "php",
                "css",
                "nix",
                "desktop",
                "fish",
                "bash",
                "json",
                "jsonc",
                "dockerfile",
                "xml",
                "python",
                "rust",
                "html",
                "graphql",
                "solidity",
                "yuck",
                "rasi",
                "scss",
                "markdown",
                "markdown_inline",
                "yaml",
                "toml",
                "ini",
                "diff",
                "git_rebase",
                "git_config",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "nginx",
                "hyprlang",
                "go"
            }
            treesitter.install { ensure_installed = ensure_installed }
            treesitter.setup {
                install_dir = vim.fn.stdpath('data') .. '/site',
            }
            vim.api.nvim_create_autocmd("fileType", {
                pattern = ensure_installed,
                callback = function()
                    vim.treesitter.start()
                end
            })
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufReadPost",
        branch = "main",
        config = function()
            local move = require "nvim-treesitter-textobjects.move"
            require("nvim-treesitter-textobjects").setup({
                move = {
                    set_jumps = true,
                },
                textobjects = {
                    select = {
                        lookahead = true, -- Automatically jump forward to textobj
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aP"] = "@parameter.outer",
                            ["iP"] = "@parameter.inner",
                            -- ["aC"] = "@conditional.outer",
                            -- ["iC"] = "@conditional.inner",
                            -- ["al"] = "@loop.outer",
                            -- ["il"] = "@loop.inner",
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V',  -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = false,
                    },

                },
            })
            vim.keymap.set({ "x", "o" }, "af", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
            end, { desc = "select around function" })
            vim.keymap.set({ "x", "o" }, "if", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
            end, { desc = "select inside function" })
            vim.keymap.set({ "x", "o" }, "ac", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
            end, { desc = "select around the class" })
            vim.keymap.set({ "x", "o" }, "ic", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
            end, { desc = "select inside the class" })
            -- You can also use captures from other query groups like `locals.scm`
            vim.keymap.set({ "x", "o" }, "as", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
            end, { desc = "select scope" })

            --NOTE: move
            vim.keymap.set({ "n", "x", "o" }, "t]f", function()
                move.goto_next_start("@function.outer", "textobjects")
            end, { desc = "Next function start" })

            vim.keymap.set({ "n", "x", "o" }, "t]]", function()
                move.goto_next_start("@class.outer", "textobjects")
            end, { desc = "Next class start" })

            vim.keymap.set({ "n", "x", "o" }, "t]l", function()
                move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
            end, { desc = "Next loop start" })

            vim.keymap.set({ "n", "x", "o" }, "t]s", function()
                move.goto_next_start("@local.scope", "locals")
            end, { desc = "Next scope" })

            vim.keymap.set({ "n", "x", "o" }, "t]z", function()
                move.goto_next_start("@fold", "folds")
            end, { desc = "Next fold" })

            vim.keymap.set({ "n", "x", "o" }, "t]F", function()
                move.goto_next_end("@function.outer", "textobjects")
            end, { desc = "Next function end" })

            vim.keymap.set({ "n", "x", "o" }, "t][", function()
                move.goto_next_end("@class.outer", "textobjects")
            end, { desc = "Next class end" })

            vim.keymap.set({ "n", "x", "o" }, "t[f", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end, { desc = "Prev function start" })

            vim.keymap.set({ "n", "x", "o" }, "t[[", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end, { desc = "Prev class start" })

            vim.keymap.set({ "n", "x", "o" }, "t[F", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end, { desc = "Prev function end" })

            vim.keymap.set({ "n", "x", "o" }, "t[]", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end, { desc = "Prev class end" })

            vim.keymap.set({ "n", "x", "o" }, "t]c", function()
                move.goto_next("@conditional.outer", "textobjects")
            end, { desc = "Next conditional" })

            vim.keymap.set({ "n", "x", "o" }, "t[c", function()
                move.goto_previous("@conditional.outer", "textobjects")
            end, { desc = "Prev conditional" })
        end,
    }
}
