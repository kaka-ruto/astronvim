-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    -- Auto-resize vim windows
    "beauwilliams/focus.nvim",
    config = function() require("focus").setup() end,
    event = "User AstroFile",
  },
  {
    -- Move to alternate file
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup {
        mappings = {
          "rails",
          {
            -- (.*) is a folder/file name
            -- %1 is the first folder/file name, %2 is the second folder/file name, and so forth
            pattern = "gems/(.*)/spec/app/units/(.*)/(.*)/(.*)_spec.rb",
            target = "gems/%1/app/units/%2/%3/%4.rb",
            context = "rb",
          },
          {
            pattern = "gems/(.*)/app/units/(.*)/(.*)/(.*).rb",
            target = "gems/%1/spec/app/units/%2/%3/%4_spec.rb",
            context = "spec",
          },
          -- Test to fixtures
          {
            pattern = "test/models/(.*)_test.rb",
            target = "test/fixtures/%1.yml",
            transformer = "pluralize",
            context = "fixtures",
          },
          {
            pattern = "test/fixtures/(.*).yml",
            target = "test/models/%1_test.rb",
            transformer = "singularize",
            context = "spec",
          },
          -- Gemfile to Gemfile.lock
          {
            pattern = "Gemfile",
            target = "Gemfile.lock",
            context = "lock",
          },
          {
            pattern = "Gemfile.lock",
            target = "Gemfile",
            context = "lock",
          },
        },
        style = {
          border = "rounded",
          seperator = "|",
          width = 0.8,
          minHeight = 2,
        },
      }
    end,
    -- Lazy load
    cmd = { "Other", "OtherSplit", "OtherVSplit" },
    keys = { { "<leader>v", "<CMD>OtherVSplit<CR>", desc = "Open alternate file in vertical split" } },
  },
}
