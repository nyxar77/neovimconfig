return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",              -- UI for nvim-dap
        "nvim-telescope/telescope-dap.nvim", -- DAP integration for Telescope
        "theHamsta/nvim-dap-virtual-text"    -- Virtual text for inline debugging
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        require("nvim-dap-virtual-text").setup()

        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
        vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<Leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Set Conditional Breakpoint" })

        vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Open DAP REPL" })
        vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "Run Last Debugging Session" })

        -- DAP UI
        vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
        vim.keymap.set("n", "<Leader>de", dapui.eval, { desc = "Evaluate expression" })
    end
}
