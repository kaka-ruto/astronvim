-- Extend core plugins without overriding them

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { -- add a new dependency to telescope that is our new plugin
      -- view media fles - works only on linux as of this installation
      "nvim-telescope/telescope-media-files.nvim",
      -- Find files in a dir
      "princejoogie/dir-telescope.nvim",
      -- So we can customize fzf to find files ignoring filename case
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    -- the first parameter is the plugin specification
    -- the second is the table of options as set up in Lazy with the `opts` key
    config = function(plugin, opts)
      -- run the core AstroNvim configuration function with the options table
      require "astronvim.plugins.configs.telescope"(plugin, opts)

      -- require telescope and load extensions as necessary
      require("telescope").load_extension "media_files"
      require("telescope").load_extension "dir"
      require("telescope").load_extension "fzf"
    end,
  },
}
