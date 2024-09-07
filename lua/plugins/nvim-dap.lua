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
    local function get_test_command(file, line)
      local cmd = { "ruby", "-Itest" }
      table.insert(cmd, file)

      if line then
        local test_name =
          vim.fn.substitute(vim.fn.getline(line), [[^\s*\(def\s\+test_\|test\s\+['"`]\)\(.*\)['"`]\s*$]], "\\2", "")
        if test_name and test_name ~= "" then
          table.insert(cmd, "--name")
          table.insert(cmd, "/" .. test_name .. "/")
        end
      end

      return cmd
    end

    local project_root = vim.fn.getcwd()

    local function create_minitest_config(name, get_args)
      return {
        type = "ruby",
        name = name,
        request = "attach",
        command = "bundle",
        commandArgs = function()
          local args = { "exec", "rdbg", "-n", "--open", "--port", "3003", "-c", "--" }
          local test_cmd = get_args()
          for _, arg in ipairs(test_cmd) do
            table.insert(args, arg)
          end
          return args
        end,
        port = 3003,
        server = "127.0.0.1",
        cwd = "${workspaceFolder}",
        env = {
          ["RAILS_ENV"] = "test",
          ["RUBY_DEBUG_FORK_MODE"] = "parent",
        },
        useBundler = true,
        pathMappings = {
          [project_root] = "${workspaceFolder}",
        },
        localfs = true,
      }
    end
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
      },
      create_minitest_config("Minitest - Current File", function()
        local file = vim.fn.expand "%:p"
        return get_test_command(file)
      end),
      create_minitest_config("Minitest - Current Line", function()
        local file = vim.fn.expand "%:p"
        local line = vim.fn.line "."
        return get_test_command(file, line)
      end),
    }

    dap.adapters.ruby = function(callback, config)
      if config.request == "attach" and config.command then
        local handle
        local pid_or_err
        handle, pid_or_err = vim.loop.spawn(config.command, {
          args = config.commandArgs,
          detached = true,
          cwd = config.cwd,
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
          1000
        )
      else
        callback {
          type = "server",
          host = config.server,
          port = config.port,
        }
      end
    end
    -- Create commands to run the debugger configurations
    vim.api.nvim_create_user_command(
      "DebugMinitestFile",
      function() dap.run(dap.configurations.ruby[#dap.configurations.ruby - 1]) end,
      {}
    )

    vim.api.nvim_create_user_command(
      "DebugMinitestLine",
      function() dap.run(dap.configurations.ruby[#dap.configurations.ruby]) end,
      {}
    )

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
