-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        colorcolumn = "120", -- sets vim.opt.colorcolumn
        showtabline = 0, -- sets vim.opt.showtabline, disable tabline
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
        -- Save all unsaved buffers
        ["<Leader>w"] = { ":wa<CR>", desc = "Save all" },
        ["q"] = "<Nop>", -- Disable the "recording" mode
        -- Map <Enter> in normal mode to insert a newline character and keep the cursor in normal mode
        ["<CR>"] = { ':call append(".", "")<Bar>normal! j0<CR>', noremap = true, silent = true },
        -- Yank all lines in file
        ["<Leader>co"] = { [[:%y+ <CR> ]], noremap = true, silent = true },
        -- Select whole file contents (like ctrl A)
        ["<Leader>vv"] = { [[ggVG]], noremap = true },
        -- Ctrl A + paste
        ["<Leader>pp"] = { [[ggVGp]], noremap = true },
        -- Copy current file path
        ["<Leader>cd"] = { [[:let @+=expand('%')<CR>]], noremap = true },
        -- Copy current file name with extension
        ["<Leader>cf"] = { [[:let @+=expand('%:t')<CR>]], noremap = true },
        -- Copy current file path with line number
        ["<Leader>cl"] = { [[:let @+=expand('%') . ':' . line('.')<CR>]], noremap = true },
        -- Open a file in the same dir as the open buffer
        [",e"] = { [[:e <C-R>=expand("%:h") . "/" <CR>]] },
        -- Split open a file in the same dir as the open buffer
        [",v"] = { [[:vs <C-R>=expand("%:h") . "/" <CR>]] },
        ["<Leader>a"] = { [[:OtherVSplit<CR>]] },
        -- Telescope find in dir
        ["<Leader>fd"] = { [[:Telescope dir find_files<CR>]], noremap = true, silent = true },
        -- Telescope grep dir
        ["<Leader>gd"] = { [[:Telescope dir live_grep<CR>]], noremap = true, silent = true },
        -- Rename all occurrences of word under cursor
        ["lr"] = {
          function()
            local old_word = vim.fn.expand "<cword>"
            local new_word = vim.fn.input("Replace " .. old_word .. " by? ", old_word)
            -- Check if the new_word is different from the old_word and is not empty
            if new_word ~= old_word and new_word ~= "" then
              vim.cmd(":%s/\\<" .. old_word .. "\\>/" .. new_word .. "/g")
            end
          end,
        },
        -- Create a new file in the current directory, with current buffer contents
        -- If the immediate directory does not exist, create it
        -- Switch to the new file
        ["<Leader><Leader>cf"] = {
          function()
            local full_path = vim.fn.expand "%:p"
            local short_path = vim.fn.fnamemodify(full_path, ":~:.")
            local new_file_path = vim.fn.input("Copy paste to new file in: ", short_path)

            if new_file_path ~= "" then
              local new_file_path_directory = vim.fn.fnamemodify(new_file_path, ":h")

              if vim.fn.isdirectory(new_file_path_directory) == 0 then vim.fn.mkdir(new_file_path_directory, "p") end

              vim.cmd("w " .. new_file_path)
              vim.cmd [[normal! ggVGy]]
              vim.cmd [[normal! G\"0P]]
              vim.cmd("e " .. new_file_path)
            end
          end,
        },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },
  },
}
