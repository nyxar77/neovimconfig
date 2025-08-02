return {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    -- lazy = true,
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",              -- UI for nvim-dap
        "nvim-telescope/telescope-dap.nvim", -- DAP integration for Telescope
        "theHamsta/nvim-dap-virtual-text",   -- Virtual text for inline debugging
        "leoluz/nvim-dap-go"
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup()

        --DANGER: DAP Config part

        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
        vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<F9>", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<F10>", dap.step_out, { desc = "Step Out" })
        vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<Leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Set Conditional Breakpoint" })
        -- Terminate the debugging session
        vim.keymap.set("n", "<Leader>dq", dap.terminate, { desc = "Terminate Debug Session" })
        vim.keymap.set("n", "<Leader>dp", dap.pause, { desc = "Pause Debugger" })

        vim.keymap.set("n", "<Leader>dr", dap.repl.toggle, { desc = "Toggle DAP UI" })
        vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "Run Last Debugging Session" })


        --DANGER: DAPUI Config part

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
        vim.keymap.set("n", "<Leader>dh", function()
            require("dap.ui.widgets").hover()
        end, { desc = "Hover Variables" })

        vim.keymap.set("n", "<Leader>de", function()
            dapui.eval(nil, { enter = true })
        end, { desc = "Evaluate expression" })

        -- DAP UI
        -- open and close dap ui automatically when debugging start/finish
        -- dap.listeners.before.attach["dapui_config"] = function()
        --     dapui.open()
        -- end


        --DANGER: Adapters & configuration

        require("dap-go").setup()
        dap.configurations.c = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopAtEntry = false,
                MIMode = "lldb",
            },
            {
                name = "Attach to lldbserver :1234",
                type = "cppdbg",
                request = "launch",
                MIMode = "lldb",
                miDebuggerServerAddress = "localhost:1234",
                miDebuggerPath = "/usr/bin/lldb",
                cwd = "${workspaceFolder}",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
            },
        }

        dap.adapters.php = {
            type = "executable",
            command = "node",
            args = {
                vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
            },
        }
        dap.configurations.php = {
            {
                type = "php",
                request = "launch",
                name = "Listen for Xdebug",
                port = 9003,
                pathMappings = {
                    ["/var/www/html"] = "${workspaceFolder}",
                },
            },
        }
    end
}
