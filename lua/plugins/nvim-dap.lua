return {
  {
    -- When developing locally, use the following:
    dir = "~/Code/lua/nvim-ruby-debugger",
    -- "kaka-ruto/nvim-ruby-debugger",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function(_, opts) require("nvim-ruby-debugger").setup(opts) end,
  },
}
