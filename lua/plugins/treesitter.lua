-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "ruby",
      "embedded_template",
      "gitignore",
      "sql",
      "yaml",
      "dockerfile",
      "json",
      "tmux",
      -- add more arguments for adding more treesitter parsers
    })
  end,
  -- Location and syntax-aware text objects
  {
    "RRethy/nvim-treesitter-textsubjects",
    after = "nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        textsubjects = {
          enable = true,
          prev_selection = ",", -- (Optional) keymap to select the previous selection
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
      }
    end,
  },
  -- Show code context
  {
    "romgrk/nvim-treesitter-context",
    after = "nvim-treesitter",
  },
  {
    -- Better commenting
    "JoosepAlviste/nvim-ts-context-commentstring",
    after = "nvim-treesitter",
    config = function() require("nvim-treesitter.configs").setup {} end,
  },
  {
    -- Split and join blocks of code with space j
    "Wansmer/treesj",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>j"] = { "<Cmd>TSJToggle<CR>", desc = "Toggle Treesitter Join" },
            },
          },
        },
      },
    },
  },
}
