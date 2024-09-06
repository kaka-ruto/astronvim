-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- import/override with your plugins folder

  { import = "astrocommunity.pack.lua" },
  -- Copilot
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  -- Increment & decrement numbers with <C-a> & <C-x>
  { import = "astrocommunity.editing-support.dial-nvim" },
  -- Explain regex with gR
  { import = "astrocommunity.editing-support.nvim-regexplainer" },
  -- Rainbow parentheses
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  --Add end to if, for, while, etc.
  { import = "astrocommunity.editing-support.nvim-treesitter-endwise" },
  -- Preview markdown with :Glow
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  -- Track programming activity
  { import = "astrocommunity.media.vim-wakatime" },
  -- Common configuration presets for options, mappings, and autocommands
  -- Uncomment after a while, I had an error before
  -- { import = "astrocommunity.motion.mini-basics" },
  -- a/i textobjects
  { import = "astrocommunity.motion.mini-ai" },
  -- Go forward/backward with square brackets
  { import = "astrocommunity.motion.mini-bracketed" },
  -- Move line/selection in all directions with Alt + hjkl
  { import = "astrocommunity.motion.mini-move" },
  -- Fast and feature-rich surround actions
  { import = "astrocommunity.motion.mini-surround" },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "ms" .. "a", -- Add surrounding in Normal and Visual modes
        delete = "ms" .. "d", -- Delete surrounding
        find = "ms" .. "f", -- Find surrounding (to the right)
        find_left = "ms" .. "F", -- Find surrounding (to the left)
        highlight = "ms" .. "h", -- Highlight surrounding
        replace = "ms" .. "r", -- Replace surrounding
        update_n_lines = "ms" .. "n", -- Update `n_lines`
      },
    },
  },
  -- Extends vim's % key to highlight, navigate, and operate on sets of matching text
  { import = "astrocommunity.motion.vim-matchup" },
  -- Jump anywhere in buffer with s and S
  { import = "astrocommunity.motion.hop-nvim" },
  -- Mark important files with <leader><leader> a/e/m
  { import = "astrocommunity.motion.harpoon" },
  -- Bash language pack
  { import = "astrocommunity.pack.bash" },
  -- Json language pack
  { import = "astrocommunity.pack.json" },
  -- Markdown language pack
  { import = "astrocommunity.pack.markdown" },
  -- Tailwind CSS language pack
  { import = "astrocommunity.pack.tailwindcss" },
  -- YAML language pack
  -- { import = "astrocommunity.pack.yaml" },
  -- Animate scrolling
  { import = "astrocommunity.scrolling.mini-animate" },
  -- Highlight arguments
  { import = "astrocommunity.syntax.hlargs-nvim" },
  -- Easy alignment
  { import = "astrocommunity.syntax.vim-easy-align" },
  -- Statusline with mode
  { import = "astrocommunity.recipes.heirline-nvchad-statusline" },
  -- ChatGPT
  { import = "astrocommunity.editing-support.chatgpt-nvim" },
  -- Multiple cursors
  { import = "astrocommunity.editing-support.multiple-cursors-nvim" },
  -- Search and replace
  { import = "astrocommunity.search.nvim-spectre" },
  -- Code with AI
  { import = "astrocommunity.completion.avante-nvim" },
  -- Debugging
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
}
