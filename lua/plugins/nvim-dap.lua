return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"
    local dap_virtual_text = require "nvim-dap-virtual-text"

    -- Ruby debugger configuration
    -- dap.adapters.ruby = function(callback, config)
    --   callback {
    --     type = "server",
    --     host = "127.0.0.1",
    --     port = 3001, -- Use a specific port number
    --     executable = {
    --       command = "bundle",
    --       args = { "exec", "rdbg", "-n", "--open", "--port", "3001" }, -- Specify the port here too
    --     },
    --   }
    -- end
    --
    -- dap.configurations.ruby = {
    --   {
    --     type = "ruby",
    --     name = "Rails",
    --     request = "attach",
    --     port = 3001, -- Make  sure this matches the port in the adapter
    --     server = "127.0.0.1",
    --     options = {
    --       source_filetype = "ruby",
    --     },
    --     localfs = true,
    --   },
    --   {
    --     type = "ruby",
    --     name = "Worker",
    --     request = "attach",
    --     port = 3002,
    --     server = "127.0.0.1",
    --     options = {
    --       source_filetype = "ruby",
    --     },
    --     localfs = true,
    --   },
    -- }
    dap.configurations.ruby = {
      {
        type = "ruby",
        name = "Rails Server",
        request = "attach",
        port = 3001,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
      },
      {
        type = "ruby",
        name = "Worker",
        request = "attach",
        command = "bundle",
        commandArgs = { "exec", "rdbg", "-n", "--open", "--port", "3002", "-c", "--", "bin/jobs", "start" },
        port = 3002,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
      },
    }

    dap.adapters.ruby = function(callback, config)
      if config.request == "attach" and config.command then
        local handle
        local pid_or_err
        handle, pid_or_err = vim.loop.spawn(config.command, {
          args = config.commandArgs,
          detached = true,
        }, function(code)
          handle:close()
          if code ~= 0 then print("rdbg exited with code", code) end
        end)
        if not handle then error("Unable to spawn rdbg: " .. tostring(pid_or_err)) end
        vim.defer_fn(
          function()
            callback {
              type = "server",
              host = config.server,
              port = config.port,
            }
          end,
          100
        )
      else
        callback {
          type = "server",
          host = config.server,
          port = config.port,
        }
      end
    end

    -- Existing configurations
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- Configure nvim-dap-virtual-text
    dap_virtual_text.setup {
      enabled = true, -- enable this plugin (the default)
      enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true, -- show stop reason when stopped for exceptions
      commented = false, -- prefix virtual text with comment string
      only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
      all_references = false, -- show virtual text on all all references of the variable (not only definitions)
      filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
      -- experimental features:
      virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
      -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }
  end,
}

-- return {
--   "mfussenegger/nvim-dap",
--   dependencies = { "kaka-ruto/nvim-ruby-debugger", "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text" },
--   config = function()
--     local dap = require "dap"
--     local ruby_debugger = require "ruby_debugger"
--     local dapui = require "dapui"
--     local dap_virtual_text = require "nvim-dap-virtual-text"
--
--     ruby_debugger.setup {
--       port = 38698,
--       host = "127.0.0.1",
--       log_level = "debug",
--     }
--     dap_virtual_text.setup { commented = true }
--     dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
--     dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
--     dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
--
--     dap.set_log_level "TRACE"
--   end,
-- }
-- table.insert(dap.configurations.ruby, {
--   type = "ruby",
--   name = "Rails",
--   request = "attach",
--   port = 3001,
--   server = "127.0.0.1",
--   options = {
--     source_filetype = "ruby",
--   },
--   cwd = vim.fn.getcwd(),
--   remoteWorkspaceRoot = "/Users/kaka/Code/ruby/autohaven",
-- remoteRoot = "/Users/kaka/Code/ruby/autohaven",
-- localRoot = "/Users/kaka/Code/ruby/autohaven",
-- pathMappings = {
--   ["/Users/kaka/Code/ruby/autohaven"] = "${workspaceFolder}",
-- },
-- })

-- dap.adapters.ruby = {
--   type = "server",
--   host = "127.0.0.1",
--   port = 3001,
-- }
--
-- dap.configurations.ruby = {
--   {
--     type = "ruby",
--     name = "Rails",
--     request = "attach",
--     port = 3001,
--     server = "127.0.0.1",
--     options = {
--       source_filetype = "ruby",
--     },
--     cwd = vim.fn.getcwd(),
--     sourceRoot = "/Users/kaka/Code/ruby/autohaven",
--     pathMappings = {
--       ["/app"] = "${workspaceFolder}/app",
--     },
--   },
-- }
--     dap.set_log_level "TRACE"
--   end,
-- }
