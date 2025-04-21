return {
  -- might need to remove this file entirely as everything mentioned here is configured in other files
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    -- opts = function(_, opts)
    --   if opts.ensure_installed ~= "all" then
    --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "ruby" })
    --   end
    -- end,
  },
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "ruby_lsp" })
  --   end,
  -- },
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "ruby_lsp" })
  --   end,
  -- },
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       ruby = { "rubocop" },
  --     },
  --   },
  -- },
}
