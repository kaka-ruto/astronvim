-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require "null-ls"

    null_ls.setup {
      sources = {
        -- Ruby-specific
        -- null_ls.builtins.formatting.rubocop.with {
        --   command = "bundle", -- Use bundle if using in project
        --   args = { "exec", "rubocop", "--autocorrect", "--stdin", "$FILENAME" },
        -- },
        -- null_ls.builtins.diagnostics.rubocop.with {
        --   command = "bundle",
        --   args = { "exec", "rubocop", "--stdin", "$FILENAME" },
        --   env = {
        --     RUBYOPT = "-W0",
        --   },
        -- },
        -- null_ls.builtins.formatting.rubocop,
        -- null_ls.builtins.diagnostics.rubocop,

        -- ERB templates
        -- null_ls.builtins.formatting.erb_lint,
        --
        -- -- Web development
        -- null_ls.builtins.formatting.prettier.with {
        --   filetypes = { "javascript", "css", "scss", "html", "json" },
        -- },
        --
        -- -- YAML formatting
        null_ls.builtins.formatting.yamlfmt,
        --
        -- -- SQL formatting
        null_ls.builtins.formatting.sqlfluff,
      },
    }
  end,
}
