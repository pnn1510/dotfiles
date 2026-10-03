local js_filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio", "leoluz/nvim-dap-go" },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    require("dap-go").setup()
    require("dapui").setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>dc", dap.continue, {})
  end,
  opts = function()
    local dap = require("dap")
    for _, ft in ipairs(js_filetypes) do
      dap.configurations[ft] = dap.configurations[ft] or {}
      table.insert(dap.configurations[ft], {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome (dev server)",
        url = "http://localhost:3000", -- Vite default is 5173
        webRoot = "${workspaceFolder}",
      })
    end
  end,
}

-- dont for get to install debugger here: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- eg: go... brew install delve, then add go dependencies
